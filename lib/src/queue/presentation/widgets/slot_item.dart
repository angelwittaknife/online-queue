import 'package:flutter/material.dart';

class SlotItem extends StatelessWidget {
  final int slotNumber;
  final VoidCallback? onTap;
  final double elevation;
  final bool dense;

  const SlotItem({
    super.key,
    required this.slotNumber,
    this.onTap,
    this.elevation = 2,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12.0);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        );

    return Card(
      color: Colors.white10,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 6 : 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    radius: 18,
                    child: Text(
                      slotNumber.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Свободное место', style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text('Нажмите, чтобы занять', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.add_circle_outline, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
