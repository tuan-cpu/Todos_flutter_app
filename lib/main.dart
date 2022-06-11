import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDtoPLR31zN1z7KdpZBcBJB8Ruq01NZ0Bc",
        appId: "com.example.flutter_project",
        messagingSenderId: "168459137287",
        projectId: "todo-app-5e3a4"
    )
  ); //call it before runApp()

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,userSnapshot){
        if(userSnapshot.hasData){
          return const MainPage();
        }else{
          return const AuthPage();
        }
      },),
    );
  }
}
