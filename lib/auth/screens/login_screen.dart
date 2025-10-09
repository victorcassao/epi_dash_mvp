import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late final AuthController auth;

  @override
  void initState() {
    super.initState();
    auth = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Acesso ao sistema",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Usuário
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Informe o usuário'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Senha
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Informe a senha'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Botão de login
                    Obx(() {
                      final loading = auth.status.value == AuthStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              auth.login(
                                _usernameCtrl.text.trim(),
                                _passwordCtrl.text.trim(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: loading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text("Entrar"),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Botão para portal administrativo
                    TextButton.icon(
                      onPressed: () => Get.toNamed(AdminRoutes.adminLogin),
                      icon: const Icon(Icons.admin_panel_settings_outlined),
                      label: const Text("Acessar portal administrativo"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
