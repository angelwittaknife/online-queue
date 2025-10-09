import 'package:flutter/material.dart';
import 'package:online_queue/src/queue/domain/entities/queue_entity.dart';

class QueueItem extends StatelessWidget {
  final QueueEntity item;
  final VoidCallback? onTap;
  final double elevation;
  final bool dense;

  const QueueItem({
    super.key,
    required this.item,
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
    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.white70);

    return Card(
      color: Colors.white10,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 6 : 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: dense ? 10 : 14,
          ),
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
                      item.numInQueue.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nickname,
                      style: titleStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.perm_identity,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'ID: ${item.userId}',
                            style: subtitleStyle?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Trailing (optional status / chevron)
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
