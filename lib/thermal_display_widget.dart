import 'package:flutter/material.dart';

class ThermalDisplayWidget extends StatelessWidget {
  final List<double> data;
  final int width;
  final int height;
  final double minTemp;
  final double maxTemp;

  const ThermalDisplayWidget({
    Key? key,
    required this.data,
    required this.width,
    required this.height,
    required this.minTemp,
    required this.maxTemp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Thermal Image (${width}x${height})',
            style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8),
        Expanded(
          child: AspectRatio(
            aspectRatio: width / height,
            child: CustomPaint(
              painter: ThermalPainter(
                data: data,
                width: width,
                height: height,
                minTemp: minTemp,
                maxTemp: maxTemp,
              ),
              size: Size.infinite,
            ),
          ),
        ),
        SizedBox(height: 8),
        // Color scale
        Container(
          height: 20,
          child: Row(
            children: [
              Text('${minTemp.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.cyan,
                        Colors.green,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                      ],
                    ),
                  ),
                ),
              ),
              Text('${maxTemp.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class ThermalPainter extends CustomPainter {
  final List<double> data;
  final int width;
  final int height;
  final double minTemp;
  final double maxTemp;

  ThermalPainter({
    required this.data,
    required this.width,
    required this.height,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / width;
    final cellHeight = size.height / height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = y * width + x;
        if (index < data.length) {
          final temp = data[index];
          final normalizedTemp = (temp - minTemp) / (maxTemp - minTemp);
          final color = _getColorForTemperature(normalizedTemp);

          final paint = Paint()..color = color;
          final rect = Rect.fromLTWH(
            x * cellWidth,
            y * cellHeight,
            cellWidth,
            cellHeight,
          );

          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  Color _getColorForTemperature(double normalizedTemp) {
    // Clamp the value between 0 and 1
    normalizedTemp = normalizedTemp.clamp(0.0, 1.0);

    // Define color stops for thermal visualization
    const colors = [
      Color(0xFF0000FF), // Blue (cold)
      Color(0xFF00FFFF), // Cyan
      Color(0xFF00FF00), // Green
      Color(0xFFFFFF00), // Yellow
      Color(0xFFFF8000), // Orange
      Color(0xFFFF0000), // Red (hot)
    ];

    final segmentCount = colors.length - 1;
    final segment = (normalizedTemp * segmentCount).floor();
    final segmentProgress = (normalizedTemp * segmentCount) - segment;

    if (segment >= segmentCount) {
      return colors.last;
    }

    final startColor = colors[segment];
    final endColor = colors[segment + 1];

    return Color.lerp(startColor, endColor, segmentProgress) ?? colors[0];
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}