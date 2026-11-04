import '../models/slot_symbol.dart';

/// Add a new symbol = add one line here.

// SlotSymbol(id, emoji, weight(rare it is), payoutMultiplier)
const List<SlotSymbol> kSymbols = [
  SlotSymbol('fish', '🐠', 40, 2), // Common slot symbol (40), Low payout (2x)
  SlotSymbol('shell', '🐚', 30, 3),
  SlotSymbol('anchor', '⚓', 15, 5),
  SlotSymbol('pearl', '🦪', 10, 10),
  SlotSymbol('chest', '🧰', 4, 30),
  SlotSymbol('trident', '🔱', 1, 100), // Rare slot symbol (1), High payout (100x)
];

