import 'package:aws_amplify/ui_elements/login_form.dart';
import 'package:aws_amplify/ui_elements/login_textfield.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
	LoginTextField usernameField = LoginTextField(labelText: "username");
	LoginTextField passwordField = LoginTextField(labelText: "password");
	LoginTextField repeatPasswordField = LoginTextField(labelText: "repeat password");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
	      child: Container(
		      color: Colors.transparent, height: 400, width: 300,
		      child: Column(
			      children: [
				      Container(
					      child: Text("Sign up"),
					      ),
				      // username
				      usernameField,
				      // password
				      passwordField,
				      // repeat password
				      repeatPasswordField,
				      ElevatedButton(
					      child: Text("Create account"),
					      onPressed: () {
						      print("Pressed");

					      }
				      ),
				      Row(children: [
				      Text("Already have an account?"),
				      TextButton(onPressed: () {}, child: Text("Log in")
				      )],),

			      ]

			      ),

		      ),
      ),
    );
  }
}
