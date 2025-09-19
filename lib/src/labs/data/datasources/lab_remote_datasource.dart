import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/service_locator.dart';
import 'package:online_queue/src/labs/data/models/lab_model.dart';

class LabRemoteDatasource {
  final firestore = sl<FirebaseFirestore>();
  Future<Either<Failure,List<LabModel>>> getAllLabs()
  {

  }
}
