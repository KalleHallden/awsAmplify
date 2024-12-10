
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
	      child: Container(
		      color: Colors.transparent, height: 200, width: 300,
		      child: Column(
			      children: [
				      Container(
					      child: Text("Login"),
					      ),
				      TextField(),
				      TextField(),
				      ElevatedButton(
					      child: Text("Login"),
					      onPressed: () {
						      print("Pressed");

					      }
				      )]

			      ),

		      ),
      ),
    );
  }
}
