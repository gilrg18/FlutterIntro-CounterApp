// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          //SingleChildScrollView: permite hacer scroll si los
          //childs sobrepasan el tamano de la pantalla
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                      //create crea una instancia del loginformprovider que puede redibujar
                      //los widgets cuando sea necesario y solo vive dentro del scope del child
                      //_LoginForm()
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electronico',
                prefixIcon: Icons.alternate_email_sharp,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                //value es el valor del input
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Correo Invalido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Espere' : 'Ingresar',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //quitar teclado
                      FocusScope.of(context).unfocus();

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      await Future.delayed(const Duration(seconds: 3));

                      //Falta: validar si el login es correcto
                      loginForm.isLoading = false;

                      Navigator.pushReplacementNamed(context, 'home');
                      //pushReplacedmentNamed va a destruir el stack de las pantallas
                      //y va a dejar la nueva pantalla ahi, no puedes regresar a la pantalla de login
                    },
            )
          ],
        ),
      ),
    );
  }
}
