import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.read<AuthBloc>().add(AuthSignInWithGoogleRequested()),
              icon: const Icon(Icons.login),
              label: const Text('Continuar con Google'),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _EmailForm(),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return Text(state.isAuthenticated
                  ? 'Sesión iniciada como: ${state.email ?? state.uid}'
                  : 'No autenticado');
            }),
          ],
        ),
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  @override
  State<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 8),
        TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => context.read<AuthBloc>().add(AuthSignInWithEmailRequested(_email.text, _pass.text)),
          child: const Text('Ingresar'),
        ),
      ],
    );
  }
}
