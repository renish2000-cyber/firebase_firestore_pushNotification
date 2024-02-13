import 'dart:convert';

class Todo{
  String name;
  bool isDone;

  Todo(this.name, this.isDone);

   factory Todo.fromJson(Map<String,dynamic> json){
    return Todo(json["name"], json["isDone"]);
  }

  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "isDone":isDone,
    };
  }


}