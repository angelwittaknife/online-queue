import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:online_queue/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:online_queue/src/auth/data/repository/auth_repository.dart';
import 'package:online_queue/src/auth/domain/repositories/auth_repository.dart';
import 'package:online_queue/src/auth/domain/usecases/get_current_uid_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/get_profile_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/register_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/sign_in_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/sign_out_usecase.dart';
import 'package:online_queue/src/auth/domain/usecases/update_nickname_usecase.dart';
import 'package:online_queue/src/auth/presentation/bloc/auth_bloc.dart';
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
import 'package:online_queue/src/queue/domain/usecases/add_queue_usecase.dart';
import 'package:online_queue/src/queue/domain/usecases/get_queue_bylab.dart';

final sl = GetIt.instance;

void init() {
  sl
    //firebase
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    //repositories
    ..registerLazySingleton<LabRepository>(() => LabRepositoryImpl())
    ..registerLazySingleton<QueueRepository>(() => QueueRepositoryImpl())
    ..registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl())
    //LabUsecases
    ..registerLazySingleton<GetLabsUsecase>(() => GetLabsUsecase(sl()))
    ..registerLazySingleton<CreateLabUsecase>(() => CreateLabUsecase(sl()))
    ..registerLazySingleton<GetLabsBySubjectUsecase>(
      () => GetLabsBySubjectUsecase(sl()),
    )
    ..registerLazySingleton<CloseLabUsecase>(() => CloseLabUsecase(sl()))
    ..registerLazySingleton<GetLabUsecase>(() => GetLabUsecase(sl()))
    ..registerLazySingleton<GetSubjectsUsecase>(() => GetSubjectsUsecase(sl()))
    //QueueUsecases
    ..registerLazySingleton<AddQueueUsecase>(() => AddQueueUsecase(sl()))
    ..registerLazySingleton<GetQueueByLabUsecase>(
      () => GetQueueByLabUsecase(sl()),
    )
    //AuthUsecases
    ..registerLazySingleton<GetCurrentUidUsecase>(()=>GetCurrentUidUsecase(sl()))
    ..registerLazySingleton<GetProfileUsecase>(()=>GetProfileUsecase(sl()))
    ..registerLazySingleton<RegisterUsecase>(()=>RegisterUsecase(sl()))
    ..registerLazySingleton<SignOutUsecase>(()=>SignOutUsecase(sl()))
    ..registerLazySingleton<SignInUsecase>(()=>SignInUsecase(sl()))
    ..registerLazySingleton<UpdateNicknameUsecase>(()=>UpdateNicknameUsecase(sl()))

    

    //Bloc`s
    ..registerLazySingleton<AuthBloc>(()=>AuthBloc())
    //Datasource
    ..registerLazySingleton<AuthRemoteDatasource>(()=>AuthRemoteDatasource())
    ..registerLazySingleton<QueueRemoteDatasource>(
      () => QueueRemoteDatasource(),
    )
    ..registerLazySingleton<LabRemoteDatasource>(() => LabRemoteDatasource());
}
