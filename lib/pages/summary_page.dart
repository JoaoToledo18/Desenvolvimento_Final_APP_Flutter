import 'package:flutter/material.dart';
import 'dart:math';
import '../models/expense.dart';

class SummaryScreen extends StatelessWidget {
  final double total;
  final List<Expense> expenses;

  const SummaryScreen({
    super.key,
    required this.total,
    required this.expenses,
  });

  Map<String, double> get categoryTotals {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.category] =
          (map[e.category] ?? 0) + e.value;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final totals = categoryTotals;
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total gasto: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 32),
            if (totals.isEmpty)
              const Text(
                'Nenhum gasto registrado.',
              )
            else ...[
              SizedBox(
                height: 220,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    totals,
                    colors,
                  ),
                  child:
                      const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 24),
              ...totals.entries
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final e = entry.value;
                final percent = total > 0
                    ? (e.value / total * 100)
                        .toStringAsFixed(1)
                    : '0.0';
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors[
                              index %
                                  colors.length],
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(e.key),
                      ),
                      Text(
                        'R\$ ${e.value.toStringAsFixed(2)} ($percent%)',
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  _PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final total =
        data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    final center =
        Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width, size.height) / 2;
    final paint = Paint()
      ..style = PaintingStyle.fill;

    double startAngle = -pi / 2;
    int i = 0;

    for (final entry in data.entries) {
      final sweep =
          (entry.value / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
      i++;
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) =>
      true;
}
