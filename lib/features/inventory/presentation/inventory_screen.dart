import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/core/app_theme.dart';
import '../../../shared/core/time_utils.dart';
import '../../../shared/data/inventory_provider.dart';
import '../../../shared/ui/glass_card.dart';

/// Inventory screen — shows scanned produce with Batch Predict.
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  Color _statusColor(String status) => switch (status) {
        'fresh' => AppTheme.accentGreen,
        'ripening' => AppTheme.accentAmber,
        'soon_rotten' => const Color(0xFFF97316),
        'rotten' => AppTheme.accentRed,
        _ => AppTheme.accentCyan,
      };

  String _statusLabel(String s) => switch (s) {
        'fresh' => 'Fresh',
        'ripening' => 'Ripening',
        'soon_rotten' => 'Soon',
        'rotten' => 'Rotten',
        _ => '?',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final ext = context.ext;

    final freshCount = items.where((i) => i.status == 'fresh').length;
    final ripeningCount = items.where((i) => i.status == 'ripening').length;
    final criticalCount = items
        .where((i) => i.status == 'soon_rotten' || i.status == 'rotten')
        .length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.92),
        surfaceTintColor: Colors.transparent,
        title: const Text('Inventory',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        actions: [
          // Batch Predict button
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                ref.read(inventoryProvider.notifier).batchPredict();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Batch prediction updated!'),
                    backgroundColor: AppTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome,
                  size: 16, color: AppTheme.accentGreen),
              label: const Text('Batch Predict',
                  style: TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentGreen.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmpty(context)
          : Column(
              children: [
                // ── Stat chips ─────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      _statChip(
                          ext, '${items.length}', 'Total', ext.textSecondary),
                      const SizedBox(width: 8),
                      _statChip(
                          ext, '$freshCount', 'Fresh', AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      _statChip(ext, '$ripeningCount', 'Ripening',
                          AppTheme.accentAmber),
                      const SizedBox(width: 8),
                      _statChip(ext, '$criticalCount', 'Critical',
                          AppTheme.accentRed),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                ),

                // ── Item list ──────────
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final color = _statusColor(item.status);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: const Icon(Icons.delete_outline,
                                color: AppTheme.accentRed),
                          ),
                          onDismissed: (_) {
                            ref
                                .read(inventoryProvider.notifier)
                                .removeItem(item.id);
                          },
                          child: GestureDetector(
                            onTap: () => _showItemDetails(context, item),
                            child: GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: item.iconColor
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(item.icon,
                                          color: item.iconColor, size: 22),
                                    ),
                                    const SizedBox(width: 14),

                                    // Name + storage
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_storageEmoji(item.storage)} ${_storageName(item.storage)} · Added ${TimeUtils.timeAgo(item.addedAt)}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: ext.textMuted),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // RUL + status
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(TimeUtils.formatMinutes(item.rul),
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                color: color)),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color:
                                                color.withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _statusLabel(item.status),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                              delay: Duration(milliseconds: 80 * index),
                              duration: 400.ms)
                          .slideX(begin: 0.04);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String _storageEmoji(String s) => switch (s) {
        'freezer' => '🧊',
        'fridge' => '❄️',
        _ => '🧺',
      };

  String _storageName(String s) => switch (s) {
        'freezer' => 'Freezer',
        'fridge' => 'Fridge',
        _ => 'Room Temp',
      };

  String _environmentLabel(String s) => switch (s) {
        'freezer' => 'Long-lasting',
        'fridge' => 'Optimal',
        _ => 'Standard Mode',
      };
  Widget _statChip(AppThemeExtension ext, String value, String label, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: c)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 9, color: ext.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: context.ext.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No items yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.ext.textMuted)),
          const SizedBox(height: 8),
          Text('Scan produce to add it here',
              style: TextStyle(fontSize: 13, color: context.ext.textMuted)),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }

  void _showItemDetails(BuildContext context, ProduceItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            // Watch specific item from provider so the UI updates natively
            final items = ref.watch(inventoryProvider);
            final currentItem =
                items.firstWhere((i) => i.id == item.id, orElse: () => item);
            final color = _statusColor(currentItem.status);
            final ext = context.ext;

            return Container(
              height: MediaQuery.sizeOf(context).height * 0.85,
              decoration: BoxDecoration(
                color: ext.surfaceDim,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle + Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: ext.glassBorder, width: 1)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: ext.textSecondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Item Details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Content mapping React's detail panel
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Large Icon Area
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: item.iconColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: item.iconColor.withValues(alpha: 0.2)),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(currentItem.icon,
                                      size: 80, color: currentItem.iconColor),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: color.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      _statusLabel(currentItem.status),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: color),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title & ID
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentItem.name,
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${currentItem.id}',
                                      style: TextStyle(
                                          fontSize: 13, color: ext.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Stats Grid (2x2)
                          Row(
                            children: [
                              Expanded(
                                child: _detailStatCard(
                                  context,
                                  icon: Icons.timer_outlined,
                                  label: 'Remaining',
                                  value:
                                      TimeUtils.formatMinutes(currentItem.rul),
                                  valueColor: color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _detailStatCard(
                                  context,
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Added',
                                  value: TimeUtils.timeAgo(currentItem.addedAt),
                                  valueColor: ext.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _storageDropdownCard(
                                    context, ref, currentItem),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _detailStatCard(
                                  context,
                                  icon: Icons.thermostat_outlined,
                                  label: 'Environment',
                                  value: _environmentLabel(currentItem.storage),
                                  valueColor: ext.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Spoilage Timeline
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SPOILAGE TIMELINE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: ext.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ext.glassBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ext.glassBorder),
                            ),
                            child: Column(
                              children: [
                                _timelineStep(
                                  context,
                                  isCompleted: true,
                                  title: 'Item Scanned & Registered',
                                  subtitle:
                                      TimeUtils.timeAgo(currentItem.addedAt),
                                  color: AppTheme.accentCyan,
                                ),
                                const SizedBox(height: 16),
                                _timelineStep(
                                  context,
                                  isActive: currentItem.status == 'fresh' ||
                                      currentItem.status == 'ripening',
                                  isCompleted:
                                      currentItem.status == 'soon_rotten' ||
                                          currentItem.status == 'rotten',
                                  title: 'Freshness Modeling Active',
                                  subtitle:
                                      'Q10 rate calculated based on ${_storageName(currentItem.storage)}',
                                  color: AppTheme.accentGreen,
                                ),
                                const SizedBox(height: 16),
                                _timelineStep(
                                  context,
                                  isActive:
                                      currentItem.status == 'soon_rotten' ||
                                          currentItem.status == 'rotten',
                                  isCompleted: currentItem.status == 'rotten',
                                  title: 'Critical Expiration Notice',
                                  subtitle:
                                      'Estimated at ${TimeUtils.formatMinutes(currentItem.rul)} remaining',
                                  color: AppTheme.accentRed,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _storageDropdownCard(
      BuildContext context, WidgetRef ref, ProduceItem item) {
    final ext = context.ext;

    // Ensure the dropdown has some min height and matches the styling of _detailStatCard
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ext.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.kitchen_outlined, size: 16, color: ext.textMuted),
              const SizedBox(width: 8),
              Text('Storage',
                  style: TextStyle(fontSize: 12, color: ext.textMuted)),
            ],
          ),
          const SizedBox(
              height:
                  10), // Reduced from 12 slightly because dropdown is taller
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: item.storage,
                isExpanded: true,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_drop_down, color: ext.textSecondary),
                dropdownColor: Theme.of(context)
                    .scaffoldBackgroundColor, // solid color for menu
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ext.textSecondary,
                  overflow: TextOverflow.ellipsis,
                ),
                borderRadius: BorderRadius.circular(12),
                items: [
                  DropdownMenuItem(
                      value: 'room',
                      child: Text(
                          '${_storageEmoji("room")} ${_storageName("room")}')),
                  DropdownMenuItem(
                      value: 'fridge',
                      child: Text(
                          '${_storageEmoji("fridge")} ${_storageName("fridge")}')),
                  DropdownMenuItem(
                      value: 'freezer',
                      child: Text(
                          '${_storageEmoji("freezer")} ${_storageName("freezer")}')),
                ],
                onChanged: (newStorage) {
                  if (newStorage != null) {
                    ref
                        .read(inventoryProvider.notifier)
                        .updateStorage(item.id, newStorage);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailStatCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color valueColor}) {
    final ext = context.ext;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ext.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: ext.textMuted),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 12, color: ext.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _timelineStep(BuildContext context,
      {bool isCompleted = false,
      bool isActive = false,
      required String title,
      required String subtitle,
      required Color color}) {
    final ext = context.ext;
    final dotColor = isCompleted
        ? color
        : isActive
            ? color
            : ext.textMuted.withValues(alpha: 0.3);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4, right: 16),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: isActive
                ? Border.all(color: dotColor.withValues(alpha: 0.3), width: 4)
                : null,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted || isActive
                        ? Theme.of(context).colorScheme.onSurface
                        : ext.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 12,
                    color: isCompleted || isActive
                        ? ext.textSecondary
                        : ext.textMuted.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
