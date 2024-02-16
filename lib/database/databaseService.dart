import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudoperation/model/Todo.dart';
import 'package:firebase_core/firebase_core.dart';

const String userCollection="users";
class DatabaseService{
  final firestore=FirebaseFirestore.instance;
  late final CollectionReference todoRef;

  DatabaseService(){
    todoRef=firestore.collection(userCollection).withConverter<Todo>(
        fromFirestore: (snapshot, options) =>Todo.fromJson(snapshot.data()!) ,
        toFirestore: (todo, options) => todo.toJson(),
    );
  }
  void addTodo(Todo todo)async{
    await todoRef.add(todo);
    await todoRef;
  }
  Stream<QuerySnapshot> getTodo(){
    return  todoRef.snapshots();
  }
  // Update the note
  Future<void> updateTodo(String docId,Todo todo) {
    return todoRef.doc(docId).update(todo.toJson());
  }
  // Delete note using given docId
  Future<void> deleteNote(String docId) {
    return todoRef.doc(docId).delete();
  }

}