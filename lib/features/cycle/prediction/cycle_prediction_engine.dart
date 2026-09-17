import '../models/cycle_prediction.dart';

abstract interface class CyclePredictionEngine {
  String get algorithmVersion;

  CycleForecast? predict(CycleHistory history, CyclePredictionContext context);
}
