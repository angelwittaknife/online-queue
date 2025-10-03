import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/labs/data/models/lab_model.dart';
import 'package:online_queue/src/labs/data/models/subject_model.dart';

class LabRemoteDatasource {
  final CollectionReference<Map<String, dynamic>> _labsColl = sl<FirebaseFirestore>().collection('labs');
  final CollectionReference<Map<String, dynamic>> _subjectsColl= sl<FirebaseFirestore>().collection('subjects');





    Future<Either<Failure, List<LabModel>>> getLabsBySubject(String subject) async {
    try {
      final query = await _labsColl.where('subject',isEqualTo: subject).get();
      final labs = query.docs
          .map((d) => LabModel.fromMap(d.id, d.data()))
          .toList(growable: false);
      return Right(labs);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<LabModel>>> getAllLabs() async {
    try {
      final query = await _labsColl.orderBy('deadline').get();
      final labs = query.docs
          .map((d) => LabModel.fromMap(d.id, d.data()))
          .toList(growable: false);
      return Right(labs);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
   Future<Either<Failure, List<SubjectModel>>> getAllSubjects() async {
    try {
      final query = await _subjectsColl.orderBy('name').get();
      final subjects = query.docs
          .map((d) => SubjectModel.fromMap(d.id, d.data()))
          .toList(growable: false);
      return Right(subjects);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LabModel>> getLabById(String id) async {
    try {
      final doc = await _labsColl.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return Left(NotFoundFailure('Lab not found: $id'));
      }
      final model = LabModel.fromMap(doc.id, doc.data()!);
      return Right(model);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> deleteLab(String id) async {
    try {
      await _labsColl.doc(id).delete();
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> addLab(LabModel lab, {bool useCustomId = false}) async {
    try {
      if (useCustomId && lab.id.isNotEmpty) {
        await _labsColl.doc(lab.id).set(lab.toMap());
      } else {
      }
      return Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
