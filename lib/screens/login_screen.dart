import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_provider.dart';
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
          child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 30,
              ),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: const _LoginForm(),
              ),
            ],
          )),
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Create new account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 250,
          ),
        ],
      )),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john@pepe.com',
                  labelText: 'Email',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Email format is not correct';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.pass = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Password must be 6 or longer';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      loginForm.isLoading = true;

                      if (!loginForm.isValidForm()) return;

                      await Future.delayed(const Duration(seconds: 2));
                      loginForm.isLoading = false;
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, 'home');
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Wait' : 'Login'),
              ),
            )
          ],
        ));
  }
}
