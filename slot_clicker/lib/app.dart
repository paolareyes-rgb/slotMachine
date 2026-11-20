import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/game_provider.dart';
import 'ui/screens/game_screen.dart';
// TODO: Make sure the files containing PlayerScreen, currentPlayerIdProvider,
// and saveServiceProvider are imported here (if not already in game_provider.dart).
// import 'ui/screens/player_screen.dart';

class SlotClickerApp extends ConsumerStatefulWidget {
  const SlotClickerApp({super.key});

  @override
  ConsumerState<SlotClickerApp> createState() => _SlotClickerAppState();
}

class _SlotClickerAppState extends ConsumerState<SlotClickerApp>
    with WidgetsBindingObserver {
  // Opens the player registration screen
  void openPlayerScreen() async {
    final id = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerScreen(),
      ),
    );

    if (id != null && mounted) {
      ref.read(currentPlayerIdProvider.notifier).state = id;
      ref.read(saveServiceProvider).savePlayerId(id);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Save whenever the app leaves the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(gameProvider.notifier).saveNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Slot Clicker',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      // Day (Light) Mode Theme
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      // Night (Dark) Mode Theme
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const GameScreen(),
    );
  }
}
