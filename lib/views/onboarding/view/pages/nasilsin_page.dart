import 'package:flutter/material.dart';

import '../widgets/index.dart';

class NasilsinPage extends StatefulWidget {
  const NasilsinPage({super.key});

  @override
  State<NasilsinPage> createState() => _NasilsinPageState();
}

class _NasilsinPageState extends State<NasilsinPage> {
  Set<String> _moods = <String>{};

  static const _moodOptions = [
    'İyiyim',
    'Yorgunum',
    'Kaygılıyım',
    'Ağrılıyım',
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingDeckCard(
      eyebrow: 'Nasılsın',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const OnboardingFieldLabel('Bugünlerde kendini nasıl hissediyorsun?'),
          const SizedBox(height: 12),
          OnboardingMultiSelect(
            options: _moodOptions,
            selectedValues: _moods,
            onChanged: (next) => setState(() => _moods = next),
            maxSelection: 3,
          ),
          const SizedBox(height: 10),
          const Text(
            'Birden fazla seçebilirsin. Detayları bir sonraki adımda ekleyeceğiz.',
            style: TextStyle(
              color: Color(0xFF7A756C),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}