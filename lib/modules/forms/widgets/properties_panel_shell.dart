import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_colors.dart';

class PropertiesPanelShell extends StatelessWidget {
  final Widget header;
  final Widget body;

  const PropertiesPanelShell({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Column(
        children: [
          header,
          const Divider(color: AppColors.borderLight, height: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
