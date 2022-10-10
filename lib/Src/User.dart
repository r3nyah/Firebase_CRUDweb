import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String id;
  final String name;
  final int age;
  final String hobby;

  User({
   this.id = '',
   required this.age,
   required this.hobby,
   required this.name,
});

  Map<String,dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'age' : age,
    'hobby': hobby,
  };

  static User fromJson(Map<String,dynamic>json)=>User(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    hobby: json['hobby'],
  );
}