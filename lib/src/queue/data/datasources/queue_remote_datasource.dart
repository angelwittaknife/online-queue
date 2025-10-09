import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/queue/data/models/queue_model.dart';

class QueueRemoteDatasource {
  Stream<Either<Failure, List<QueueModel>>> getQueueStreamById(String id) {
    final queueRef = sl<FirebaseFirestore>()
        .collection('labs')
        .doc(id)
        .collection('queue')
        .orderBy('numInQueue');

    return queueRef.snapshots().transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          final queue = snapshot.docs
              .map((d) => QueueModel.fromMap(d.id, d.data()))
              .toList(growable: false);
          sink.add(Right(queue));
        },
        handleError: (error, stackTrace, sink) {
          if (error is FirebaseException) {
            sink.add(Left(ServerFailure(error.message ?? 'Firestore error')));
          } else {
            sink.add(Left(ServerFailure(error.toString())));
          }
        },
      ),
    );
  }

  /// Добавляет очередь в указанный слот (numInQueue). Использует транзакцию,
  /// чтобы избежать гонки за один и тот же слот. Возвращает Right(true) при успехе.
  Future<Either<Failure, bool>> addQueue(QueueModel queue, String labId) async {
    try {
      final firestore = sl<FirebaseFirestore>();
      final user = sl<FirebaseAuth>().currentUser;

      if (user == null) return Left(ServerFailure('User not authenticated'));
      if (queue.userId != user.uid) return Left(ServerFailure('UID mismatch'));

      final docRef = firestore
          .collection('labs')
          .doc(labId)
          .collection('queue')
          .doc(queue.numInQueue.toString());

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (snapshot.exists) throw ServerFailure('Slot already occupied');

        final data = {
          'studentId': queue.userId,
          'nickname': queue.nickname,
          'joinedAt': Timestamp.now(), // 👈 безопасный timestamp
          'status': 'active', // 👈 подходит под твои правила
          'numInQueue': queue.numInQueue,
        };

        transaction.set(docRef, data);
      });

      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } on ServerFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
