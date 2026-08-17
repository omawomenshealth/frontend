import '../../domain/cycle/models/cycle_prediction.dart';
import '../services/local_storage_service.dart';

/// Tahmin snapshot'ını şifreli yerel store'da tutar. Snapshot türetilmiş veri
/// olduğu için PostgreSQL bulut yedeğine eklenmez ve hash uyuşmazsa atılır.
final class CycleForecastSnapshotStore {
  final LocalStorageService _storage;

  const CycleForecastSnapshotStore(this._storage);

  CycleForecast? load() {
    final raw = _storage.loadCycleForecastSnapshot();
    if (raw == null) return null;
    try {
      return CycleForecast.fromJsonString(raw);
    } catch (_) {
      return null;
    }
  }

  Future<bool> save(CycleForecast forecast) =>
      _storage.saveCycleForecastSnapshot(forecast.toJsonString());

  Future<bool> clear() => _storage.clearCycleForecastSnapshot();
}
