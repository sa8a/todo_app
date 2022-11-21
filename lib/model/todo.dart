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
      ToDo(id: '01', todoText: 'Task01', isDone: true),
      ToDo(id: '02', todoText: 'Task02', isDone: false),
      ToDo(id: '03', todoText: 'Task03'),
      ToDo(id: '04', todoText: 'Task04'),
      ToDo(id: '05', todoText: 'Task05'),
    ];
  }
}
