import 'package:flutter/material.dart';
import 'package:nss_tracker/services/firebase/firebase.dart';
import 'package:nss_tracker/views/main_view.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "NSS Tracker",
                style: Theme.of(context).textTheme.headline4?.apply(
                    fontWeightDelta: 1,
                    color: Theme.of(context).textTheme.headline6?.color),
              ),
              Text(
                "Get Started and track your Progress",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.apply(fontWeightDelta: 1),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Username"),
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                controller: _passwordController,
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final user = await firebaseAuthServices.signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim());
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainView()));
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Error while Sign In"),
                              content: Text(
                                  "Looks like the signi in flow encountered some issue, please try again"),
                              actions: [
                                OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"))
                              ],
                            ));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sign In".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.lightGreenAccent.shade700),
                  elevation: MaterialStateProperty.all<double>(5.0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
