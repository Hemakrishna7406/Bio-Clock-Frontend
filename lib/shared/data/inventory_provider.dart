import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_settings_provider.dart';

/// Produce item model used across the app.
class ProduceItem {
  final String id;
  final String name;
  final int rul; // remaining useful life in minutes (previously hours)
  final String status; // fresh, ripening, soon_rotten, rotten
  final IconData icon;
  final Color iconColor;
  final String storage; // freezer, fridge, room
  final DateTime addedAt;

  const ProduceItem({
    required this.id,
    required this.name,
    required this.rul,
    required this.status,
    required this.icon,
    required this.iconColor,
    this.storage = 'fridge',
    required this.addedAt,
  });

  ProduceItem copyWith({
    String? name,
    int? rul,
    String? status,
    IconData? icon,
    Color? iconColor,
    String? storage,
  }) {
    return ProduceItem(
      id: id,
      name: name ?? this.name,
      rul: rul ?? this.rul,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      storage: storage ?? this.storage,
      addedAt: addedAt,
    );
  }
}

/// Demo produce data — only items from the 61-class produce set.
final List<ProduceItem> demoProduce = [
  ProduceItem(
    id: 'd1',
    name: 'Fresh Spinach',
    rul: 48 * 60,
    status: 'fresh',
    icon: Icons.grass,
    iconColor: const Color(0xFF22C55E),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  ProduceItem(
    id: 'd2',
    name: 'Tomatoes',
    rul: 18 * 60,
    status: 'ripening',
    icon: Icons.circle,
    iconColor: const Color(0xFFEF4444),
    storage: 'room',
    addedAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  ProduceItem(
    id: 'd3',
    name: 'Bananas',
    rul: 32 * 60,
    status: 'ripening',
    icon: Icons.spa,
    iconColor: const Color(0xFFF59E0B),
    storage: 'room',
    addedAt: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  ProduceItem(
    id: 'd4',
    name: 'Avocado',
    rul: 40 * 60,
    status: 'fresh',
    icon: Icons.eco,
    iconColor: const Color(0xFF22C55E),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ProduceItem(
    id: 'd5',
    name: 'Carrots',
    rul: 80 * 60,
    status: 'fresh',
    icon: Icons.restaurant,
    iconColor: const Color(0xFFF97316),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  ProduceItem(
    id: 'd6',
    name: 'Bell Pepper',
    rul: 60 * 60,
    status: 'fresh',
    icon: Icons.local_florist,
    iconColor: const Color(0xFFEF4444),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  ProduceItem(
    id: 'd7',
    name: 'Cucumber',
    rul: 36 * 60,
    status: 'fresh',
    icon: Icons.grass,
    iconColor: const Color(0xFF22C55E),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  ProduceItem(
    id: 'd8',
    name: 'Mango',
    rul: 10 * 60,
    status: 'soon_rotten',
    icon: Icons.spa,
    iconColor: const Color(0xFFF59E0B),
    storage: 'room',
    addedAt: DateTime.now().subtract(const Duration(hours: 48)),
  ),
  ProduceItem(
    id: 'd9',
    name: 'Apple',
    rul: 72 * 60,
    status: 'fresh',
    icon: Icons.apple,
    iconColor: const Color(0xFFEF4444),
    storage: 'fridge',
    addedAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  ProduceItem(
    id: 'd10',
    name: 'Potato',
    rul: 120 * 60,
    status: 'fresh',
    icon: Icons.circle,
    iconColor: const Color(0xFFA16207),
    storage: 'room',
    addedAt: DateTime.now().subtract(const Duration(hours: 24)),
  ),
];

class InventoryNotifier extends StateNotifier<List<ProduceItem>> {
  final Ref _ref;

  InventoryNotifier(this._ref) : super([]) {
    // Listen for demo mode changes
    _ref.listen<AppSettings>(appSettingsProvider, (prev, next) {
      if (prev?.demoMode != next.demoMode) {
        if (next.demoMode) {
          state = [...demoProduce];
        } else {
          // Keep only user-scanned items (non-demo IDs don't start with 'd')
          state = state.where((i) => !i.id.startsWith('d')).toList();
        }
      }
    });

    // Initialize with demo data if demo mode is on
    final settings = _ref.read(appSettingsProvider);
    if (settings.demoMode) {
      state = [...demoProduce];
    }
  }

  void addItem(ProduceItem item) {
    state = [item, ...state];
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  void updateStorage(String id, String newStorage) {
    state = state.map((item) {
      if (item.id != id) return item;

      final factors = {'room': 1.0, 'fridge': 2.0, 'freezer': 5.0};
      final oldFactor = factors[item.storage] ?? 1.0;
      final newFactor = factors[newStorage] ?? 1.0;

      final newRul = (item.rul / oldFactor * newFactor).round();
      final newStatus = _statusFromRul(newRul);

      return item.copyWith(
        storage: newStorage,
        rul: newRul,
        status: newStatus,
      );
    }).toList();
  }

  void batchPredict() {
    // Simulate batch prediction — update RUL and status for all items
    state = state.map((item) {
      final newRul = (item.rul * 0.95).round(); // slight decay
      final newStatus = _statusFromRul(newRul);
      return item.copyWith(rul: newRul, status: newStatus);
    }).toList();
  }

  void clearAll() {
    state = [];
  }

  String _statusFromRul(int rulMinutes) {
    if (rulMinutes > 36 * 60) return 'fresh';
    if (rulMinutes > 18 * 60) return 'ripening';
    if (rulMinutes > 6 * 60) return 'soon_rotten';
    return 'rotten';
  }
}

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<ProduceItem>>((ref) {
  return InventoryNotifier(ref);
});
