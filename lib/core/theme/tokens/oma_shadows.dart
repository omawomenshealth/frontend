import 'package:flutter/material.dart';

abstract final class OmaShadows {
  static const subtle = <BoxShadow>[
    BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
  ];

  static const soft = <BoxShadow>[
    BoxShadow(color: Color(0x14503F2E), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(color: Color(0x22503F2E), blurRadius: 28, offset: Offset(0, 12)),
  ];
}
