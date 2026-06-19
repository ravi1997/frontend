import 'package:flutter/material.dart';

class DashboardBuilderPage extends StatelessWidget {
  final String? dashboardId;
  final String? organizationId;

  const DashboardBuilderPage({
    super.key,
    this.dashboardId,
    this.organizationId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard Builder')),
    );
  }
}
