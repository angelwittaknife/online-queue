import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/firebase_options.dart';
import 'package:online_queue/src/online_queue.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  init();
  runApp(const OnlineQueue());
}



