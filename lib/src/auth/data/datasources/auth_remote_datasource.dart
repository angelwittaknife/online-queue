import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_queue/core/errors/failures.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/data/models/student_model.dart';
import 'package:online_queue/core/router/router.dart'; // чтобы вызывать notifyListeners

class AuthRemoteDatasource {
  final FirebaseAuth _auth = sl<FirebaseAuth>();
  final FirebaseFirestore _firestore = sl<FirebaseFirestore>();

  Future<Either<Failure, String>> register(StudentModel student) async {
    try {
      if (student.email.isEmpty ||
          student.password == null ||
          student.password!.isEmpty) {
        return Left(ServerFailure('Email and password are required'));
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: student.email,
        password: student.password!,
      );

      final user = credential.user;
      if (user == null) {
        return Left(ServerFailure('Failed to create user'));
      }

      final nickname = student.nickname?.trim().isEmpty ?? true
          ? student.email.split('@').first
          : student.nickname!.trim();

      await user.updateDisplayName(nickname);
      await user.reload();

      final uid = user.uid;

      await _firestore.collection('users').doc(uid).set({
        'nickname': nickname,
        'email': student.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // уведомляем роутер, что авторизация изменилась
      authChangeNotifier.notifyListeners();

      return Right(uid);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase Auth error'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) return Left(ServerFailure('SignIn failed'));

      // уведомляем GoRouter о входе
      authChangeNotifier.notifyListeners();

      return Right(user.uid);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase Auth error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, StudentModel>> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return Left(ServerFailure('Profile not found'));
      final data = doc.data()!;
      final nickname = data['nickname'] as String? ?? '';
      final email = data['email'] as String? ?? '';
      return Right(StudentModel(nickname, email, null));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> updateNickname(
    String uid,
    String newNickname,
  ) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.uid != uid) {
        return Left(ServerFailure('Not authenticated'));
      }

      await currentUser.updateDisplayName(newNickname);
      await currentUser.reload();

      await _firestore.collection('users').doc(uid).update({
        'nickname': newNickname,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase Auth error'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firestore error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> signOut() async {
    try {
      await _auth.signOut();

      // уведомляем GoRouter о выходе
      authChangeNotifier.notifyListeners();

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getCurrentUid() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('No authenticated user'));
      }
      return Right(user.uid);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
