import 'package:flutter/material.dart';
import 'package:online_queue/src/labs/domain/entities/lab_entity.dart';

class LabItem extends StatelessWidget {
  final LabEntity lab;
  final VoidCallback? onTap;
  final bool dense;

  const LabItem({
    super.key,
    required this.lab,
    this.onTap,
    this.dense = false,
  });

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
  
    return '$d.$m.$y';
  }

  Color _statusColor(BuildContext context) {
    return lab.isOpen ? Colors.greenAccent.shade700 : Colors.redAccent.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.white70,
    );

    return Card(
      color: Colors.white10,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 6 : 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: dense ? 10 : 16,
          ),
          child: Row(
            children: [
              // Leading icon / status
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: lab.isOpen ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  lab.isOpen ? Icons.lock_open : Icons.lock,
                  color: _statusColor(context),
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and deadline row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            lab.title,
                            style: titleStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatDate(lab.deadline),
                              style: subtitleStyle?.copyWith(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(context).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                lab.isOpen ? 'Открыта' : 'Закрыта',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _statusColor(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Subject
                    Text(
                      lab.subject,
                      style: subtitleStyle?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      lab.description,
                      style: subtitleStyle,
                      maxLines: dense ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Trailing chevron
              Icon(
                Icons.chevron_right,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
