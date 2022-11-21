class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: '映画を観る', isDone: true),
      ToDo(id: '02', todoText: '買い物をする', isDone: false),
      ToDo(id: '03', todoText: '選択をする'),
      ToDo(id: '04', todoText: 'アニメを見る'),
      ToDo(id: '05', todoText: 'メールチェック'),
    ];
  }
}
