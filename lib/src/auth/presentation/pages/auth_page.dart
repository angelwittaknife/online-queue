import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_queue/core/environment/service_locator.dart';
import 'package:online_queue/src/auth/domain/entities/student_entity.dart';
import 'package:online_queue/src/auth/presentation/bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _newNickController = TextEditingController();

  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _newNickController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack(context, 'Введите email и пароль');
      return;
    }

    if (_isRegister) {
      final nickname = _nicknameController.text.trim();
      if (nickname.isEmpty) {
        _showSnack(context, 'Введите имя');
        return;
      }
      bloc.add(RegisterRequested(StudentEntity(uid: '', nickname: nickname, email: email)));
    } else {
      bloc.add(SignInRequested(email: email, password: password));
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isRegister ? 'Регистрация' : 'Вход'),
          actions: [
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              tooltip: 'Переключить режим',
              onPressed: () => setState(() => _isRegister = !_isRegister),
            ),
          ],
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              _showSnack(context, state.message);
            } else if (state is Authenticated) {
              _showSnack(context, 'Добро пожаловать!');
              context.goNamed('subjects');
            } else if (state is Unauthenticated) {
              _showSnack(context, 'Вы вышли из системы');
            } else if (state is NicknameUpdateSuccess) {
              _showSnack(context, 'Имя обновлено: ${state.nickname}');
            } else if (state is ProfileLoadSuccess) {
              final s = state.student;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Профиль'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Имя: ${s.nickname}'),
                      Text('Email: ${s.email}'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_isRegister)
                        _buildTextField(_nicknameController, 'Имя пользователя'),
                      const SizedBox(height: 12),
                      _buildTextField(_emailController, 'Email', type: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      _buildTextField(_passwordController, 'Пароль', obscure: true),
                      const SizedBox(height: 20),

                      _buildSubmitButton(context, isLoading),
                      const SizedBox(height: 12),

                      _buildSignOutButton(context, isLoading),
                      const SizedBox(height: 16),

                      const Divider(),
                      _buildProfileActions(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    TextInputType? type,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool loading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : () => _submit(context),
        child: loading
            ? const SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(_isRegister ? 'Зарегистрироваться' : 'Войти'),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, bool loading) {
    return OutlinedButton.icon(
      onPressed: loading ? null : () => context.read<AuthBloc>().add(const SignOutRequested()),
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Выйти'),
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => context.read<AuthBloc>().add(const CheckCurrentUidRequested()),
          child: const Text('Проверить текущий UID'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _newNickController,
          decoration: const InputDecoration(labelText: 'Новое имя', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final state = context.read<AuthBloc>().state;
            if (state is! Authenticated) {
              _showSnack(context, 'Сначала войдите в систему');
              return;
            }
            final newNick = _newNickController.text.trim();
            if (newNick.isEmpty) {
              _showSnack(context, 'Введите новое имя');
              return;
            }
            context.read<AuthBloc>().add(UpdateNicknameRequested(uid: state.uid, newNickname: newNick));
            _newNickController.clear();
          },
          child: const Text('Обновить имя'),
        ),
      ],
    );
  }
}
