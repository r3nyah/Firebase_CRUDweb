import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Src/User.dart';
import 'Src/UserPage.dart';
import 'Src/UserEdit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDE4Di6xXb7TILechjB49q94sPbOEztNKc",
        appId: "1:694070348483:web:d38bf78a8d5779bd48b076",
        messagingSenderId: "694070348483",
        projectId: "website-16c0d"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'All Users',
          ),
        ),
        body: StreamBuilder<List<User>>(
            stream: readUser(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Text('Something went wrong! $snapshot.error');
              }else if(snapshot.hasData){
                final users = snapshot.data!;

                return ListView(
                  children: users.map(buildUser).toList(),
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPage(),
                ));
              },
            ),
            SizedBox(height: 10,),
            FloatingActionButton(
              child: Icon(
                  Icons.edit
              ),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserEdit(),
                ));
              },
            ),
            SizedBox(height: 10,),
            /*FloatingActionButton(
            child: Icon(
              Icons.delete
            ),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDelete(),
              ));
            },
          )*/
            /*
          docUser.update({
          'name' : FieldValue.delete(),
          });
           */
          ],
        ),
      ),
    );
  }

  Widget buildUser(User user)=>ListTile(
    leading: CircleAvatar(child: Text('${user.age}'),),
    title: Text(user.name),
    subtitle: Text(user.hobby),
  );

  Stream<List<User>> readUser()=>FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshots)=>snapshots.docs.map((doc)=>User.fromJson(doc.data())).toList()
  );

  Future createUser({required String name}) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
      id: docUser.id,
      name: name,
      age: 17,
      hobby: 'Playing Game',
    );
    final json = user.toJson();

    await docUser.set(json);
  }
}