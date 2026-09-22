import '../../utils/period_calculator.dart';

class OmaPhasePresentation {
  const OmaPhasePresentation({required this.number, required this.flowerAsset});

  final String number;
  final String flowerAsset;

  static OmaPhasePresentation forPhase(CyclePhase phase) => switch (phase) {
    CyclePhase.menstrual => const OmaPhasePresentation(
      number: '01',
      flowerAsset: 'assets/images/decorative/blooms/oma-red-blossom.png',
    ),
    CyclePhase.follicular => const OmaPhasePresentation(
      number: '02',
      flowerAsset: 'assets/images/decorative/blooms/oma-orchid.png',
    ),
    CyclePhase.ovulation => const OmaPhasePresentation(
      number: '03',
      flowerAsset: 'assets/images/decorative/blooms/oma-anemone.png',
    ),
    CyclePhase.luteal => const OmaPhasePresentation(
      number: '04',
      flowerAsset: 'assets/images/decorative/blooms/oma-daisy-warm.png',
    ),
  };
}
