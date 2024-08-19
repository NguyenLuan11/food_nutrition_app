// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:collection/collection.dart';

class BMIPoint {
  final double x;
  final double y;

  BMIPoint({required this.x, required this.y});
}

List<BMIPoint> bmiPoints(List<double> data) {
  return data
      .mapIndexed((index, element) => BMIPoint(x: index.toDouble(), y: element))
      .toList();
}
