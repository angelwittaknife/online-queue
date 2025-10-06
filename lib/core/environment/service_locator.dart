
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:online_queue/src/labs/data/datasources/lab_remote_datasource.dart';
import 'package:online_queue/src/labs/data/repositories/lab_repository.dart';
import 'package:online_queue/src/labs/domain/repositories/lab_repository.dart';
import 'package:online_queue/src/labs/domain/usecases/close_lab_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/create_lab_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/get_lab_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/get_labs_by_subj_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/get_labs_usecase.dart';
import 'package:online_queue/src/labs/domain/usecases/get_subjects_usecase.dart';
import 'package:online_queue/src/queue/data/datasources/queue_remote_datasource.dart';
import 'package:online_queue/src/queue/data/repositories/queue_repository.dart';
import 'package:online_queue/src/queue/domain/repositories/queue_repository.dart';

final sl = GetIt.instance;

void init() {
sl
//firebase
..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)

//repositories
..registerLazySingleton<LabRepository>(()=>LabRepositoryImpl())
..registerLazySingleton<QueueRepository>(()=>QueueRepositoryImpl())
//LabUsecases
..registerLazySingleton<GetLabsUsecase>(()=>GetLabsUsecase(sl()))
..registerLazySingleton<CreateLabUsecase>(()=>CreateLabUsecase(sl()))
..registerLazySingleton<GetLabsBySubjectUsecase>(()=>GetLabsBySubjectUsecase(sl()))
..registerLazySingleton<CloseLabUsecase>(()=>CloseLabUsecase(sl()))
..registerLazySingleton<GetLabUsecase>(()=>GetLabUsecase(sl()))
..registerLazySingleton<GetSubjectsUsecase>(()=>GetSubjectsUsecase(sl()))

//Bloc`s

//Datasource
..registerLazySingleton<QueueRemoteDatasource>(()=>QueueRemoteDatasource())
..registerLazySingleton<LabRemoteDatasource>(()=>LabRemoteDatasource());



 
}
