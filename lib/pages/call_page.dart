import 'package:call_app/pages/join_call_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  // List of options for "Would you rather"
  final List<String> options = [
    "go skiing or snorkelling?",
    "eat pizza or burgers?",
    "travel to the mountains or the beach?",
    "read a book or watch a movie?",
    "stay in or go out?"
  ];
  int currentIndex = 0;

  void _nextOption() {
    setState(() {
      currentIndex = (currentIndex + 1) % options.length;
    });
  }

  void _previousOption() {
    setState(() {
      currentIndex = (currentIndex - 1 + options.length) % options.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/profile_pic.jpg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // 2. Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.3), // Slight overlay for better contrast
              ),
            ),
          ),
          // 3. Center "HELLO" Text
          Align(
            alignment: Alignment.center,
	    child: JoinChannelAudio(channelID: "test"),
          ),
          // 4. Top-left Corner Text
          Positioned(
            top: 40, // Adjust for padding
            left: 20,
            child: Text(
              "Kalle",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
	  Positioned(
            top: 40, // Adjust for padding
            right: 20,
            child: ElevatedButton(
              child: Text("Leave", style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
	      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Background color
    ),
	      onPressed: () {
		      Navigator.pop(context);
	      }),
          ),
          // 5. Bottom Center Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Would you rather",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Arrow
                          IconButton(
                            icon: Icon(Icons.arrow_left), // Ensure this icon exists
                            onPressed: _previousOption,
                          ),
                          // Center Text
                          Expanded(
                            child: Text(
                              options[currentIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          // Right Arrow
                          IconButton(
                            icon: Icon(Icons.arrow_right), // Ensure this icon exists
                            onPressed: _nextOption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

