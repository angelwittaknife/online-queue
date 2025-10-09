import 'package:dartz/dartz.dart';
import 'package:online_queue/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  const UseCase();
  Type call({Params? param});
}
