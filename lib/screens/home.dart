import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        // streamの設定部分で、前述したデータの取得処理を記載
        // Cloud FirestoreからStreamでデータを取得
        // FirebaseFirestore.instanceでCloud Firestoreのデータベースのインスタンスを取得します。
        // collection(~)でコレクションを選択
        // orderBy(~)でフィールドの値にて並べ替え
        // 最後にsnapshots()でStreamにてデータの取得を行う
        stream: FirebaseFirestore.instance
            .collection('todo')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('エラーが発生しました');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.requireData.docs
              .map<String>((DocumentSnapshot document) {
            final documentData = document.data()! as Map<String, dynamic>;
            return documentData['todoText']! as String;
          }).toList();

          final reverseList = list.reversed.toList();

          return ListView.builder(
            itemCount: reverseList.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(
                  reverseList[index],
                  style: const TextStyle(fontSize: 20),
                ),
              );
            },
          );
        },
      ),

      // body: Stack(
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.symmetric(
      //         horizontal: 20,
      //         vertical: 15,
      //       ),
      //       child: Column(
      //         children: [
      //           searchBox(),
      //           Expanded(
      //             child: ListView(
      //               children: [
      //                 Container(
      //                   margin: const EdgeInsets.only(
      //                     top: 50,
      //                     bottom: 20,
      //                   ),
      //                   child: const Text(
      //                     'All ToDos',
      //                     style: TextStyle(
      //                       fontSize: 30,
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                 ),
      //                 for (ToDo todo in _foundToDo.reversed)
      //                   ToDoItem(
      //                     todo: todo,
      //                     onToDoChanged: _handleToDoChange,
      //                     onDeleteItem: _deleteToDoItem,
      //                   ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: Container(
      //               margin: const EdgeInsets.only(
      //                 bottom: 20,
      //                 right: 20,
      //                 left: 20,
      //               ),
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 20,
      //                 vertical: 5,
      //               ),
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 boxShadow: const [
      //                   BoxShadow(
      //                     color: Colors.grey,
      //                     offset: Offset(0.0, 0.0),
      //                     blurRadius: 10.0,
      //                     spreadRadius: 0.0,
      //                   ),
      //                 ],
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //               child: TextField(
      //                 controller: _todoController,
      //                 decoration: const InputDecoration(
      //                   hintText: 'Add a new todo item',
      //                   border: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             margin: const EdgeInsets.only(
      //               bottom: 20,
      //               right: 20,
      //             ),
      //             child: ElevatedButton(
      //               child: const Text(
      //                 '+',
      //                 style: TextStyle(
      //                   fontSize: 40,
      //                 ),
      //               ),
      //               onPressed: () {
      //                 _addToDoItem(_todoController.text);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: tdBlue,
      //                 minimumSize: const Size(60, 60),
      //                 elevation: 10,
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String todo) {
    setState(() {
      todoList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo,
        ),
      );
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            // ClipRRect : 画像などのコンテンツの角を丸くする
            // widgetをClipRRectでラップし、borderRadiusに角丸の半径を指定
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpeg'),
            ),
          )
        ],
      ),
    );
  }
}
