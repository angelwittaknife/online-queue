import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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
}

