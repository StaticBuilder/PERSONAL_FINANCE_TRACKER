import 'package:bloc/bloc.dart';
import 'package:finance_tracker_app/app.dart';
//import 'package:finance_tracker_app/firebase_options.dart';
import 'package:finance_tracker_app/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
);
 Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}


