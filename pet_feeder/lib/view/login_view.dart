import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_feeder/view/widgets/app_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            heightFactor: 2,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
            ),
          ),
          Align(
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
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const AppTextField(
                    label: 'Usuario',
                  ),
                  const AppTextField(
                    label: 'Contraseña',
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ingresar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
