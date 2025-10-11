import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_queue/src/auth/presentation/widgets/auth_form_view.dart';
import 'package:online_queue/src/widgets/app_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Добро пожаловать!')),
            );
            context.goNamed('subjects');
          } else if (state is AuthFormState && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return AppScaffold(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: switch (state) {
                  AuthInitial() => _buildLoading(context),
                  AuthLoading() => _buildLoading(context),
                  AuthFormState() => const AuthFormView(),
                  AuthFailure() => _buildError((state as AuthFailure).message),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SpinKitDualRing(
        color: Colors.orangeAccent,
        size: size.height * 0.12,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ),
    );
  }
}
