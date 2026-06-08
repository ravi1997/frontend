import 'package:flutter/material.dart';

class PaddedScrollTab extends StatelessWidget {
  final Widget child;

  const PaddedScrollTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
