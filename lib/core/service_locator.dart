
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

 
}
