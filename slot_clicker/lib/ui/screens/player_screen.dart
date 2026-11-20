import 'package:flutter/material.dart';
import 'slotdatabase.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final nameController = TextEditingController();

  void startGame() async {
    final name = nameController.text.trim();

    if (name.isEmpty) return;

    final playerId = await SlotDatabase.instance.addPlayer(name);

    if (!mounted) return;

    if (playerId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name already exists!')),
      );
      return;
    }

    Navigator.pop(context, playerId);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Name')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Player Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startGame,
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
