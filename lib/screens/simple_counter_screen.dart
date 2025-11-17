import 'package:flutter/material.dart';

class SimpleCounterScreen extends StatefulWidget {
  const SimpleCounterScreen({super.key});

  @override
  State<SimpleCounterScreen> createState() => _SimpleCounterScreenState();
}

class _SimpleCounterScreenState extends State<SimpleCounterScreen> {
  int _playerScore = 0;
  int _opponentScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Counter 1v1')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Adversaire',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    '$_opponentScore',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            if (_opponentScore > 0) _opponentScore--;
                          });
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            _opponentScore++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.white),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Vous',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    '$_playerScore',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            if (_playerScore > 0) _playerScore--;
                          });
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {
                          setState(() {
                            _playerScore++;
                          });
                        },
                      ),
                    ],
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
