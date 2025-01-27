import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:call_app/pages/call_page.dart';
import 'package:flutter/material.dart';
import 'amplify_outputs.dart';
import 'package:call_app/pages/join_call_page.dart';
import 'package:call_app/pages/waveform.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(const MyApp());
  } on AmplifyException catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Error configuring Amplify: ${e.message}"),
          ),
        ),
      ),
    );
  }
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured Amplify');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
    rethrow; // Rethrow to catch in main()
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      // The Authenticator wraps the entire app
      child: MaterialApp(
        title: 'Call App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Integrate Authenticator's builder
        builder: Authenticator.builder(),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // Ensure the context here is under MaterialApp
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  CallPage(),
                  ),
                );
              },
              child: const Text("Call"),
            ),
            const SizedBox(height: 20),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}

