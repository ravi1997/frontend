import 'package:flutter/material.dart';
import 'package:frontend/app/theme/tokens.dart';

class PaddedScrollTab extends StatelessWidget {
  final Widget child;

  const PaddedScrollTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spaceL),
      child: child,
    );
  }
}
