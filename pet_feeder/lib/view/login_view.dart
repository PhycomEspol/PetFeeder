import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/util/methods.dart';
import 'package:pet_feeder/view/widgets/app_text_field.dart';
import 'package:pet_feeder/view/widgets/background_scaffold.dart';

import '../config/util/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hideText = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BackgroundScaffold(
      background: backgroundLogin,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: size.width,
          height: size.height * 0.4,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              AppTextField(
                label: 'Correo electrónico',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              AppTextField(
                  label: 'Contraseña',
                  obscureText: hideText,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => login(context),
                  suffix: IconButton(
                    icon: Icon(
                      hideText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      hideText = !hideText;
                      setState(() {});
                    },
                  )),
              TextButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (_) {
                      var controller = TextEditingController();
                      return AlertDialog(
                        title: const Text('Registro'),
                        content: AppTextField(
                          label: 'Correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                          controller: controller,
                          onFieldSubmitted: (newEmail) {
                            sendPasswordReset(
                              newEmail,
                              'Se ha enviado un correo para restablecer su contraseña',
                            );
                            context.pop();
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: context.pop,
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              sendPasswordReset(
                                controller.text,
                                'Se ha enviado un correo para restablecer su contraseña',
                              );
                              context.pop();
                            },
                            child: const Text('Enviar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Recuperar Contraseña'),
              ),
              ElevatedButton(
                onPressed: () => login(context),
                child: const Text('Ingresar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(
        EmailAuthProvider.credential(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      if (context.mounted) {
        context.go(AppPages.home);
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message ?? 'Error desconocido');
    }
  }
}
