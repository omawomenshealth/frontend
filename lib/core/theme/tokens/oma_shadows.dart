import 'package:flutter/material.dart';

abstract final class OmaShadows {
  static const soft = <BoxShadow>[
    BoxShadow(color: Color(0x14503F2E), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const lift = <BoxShadow>[
    BoxShadow(color: Color(0x22503F2E), blurRadius: 28, offset: Offset(0, 12)),
  ];
}
