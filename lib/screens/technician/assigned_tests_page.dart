import 'package:flutter/material.dart';
import 'base_test_list_page.dart';

class AssignedTestsPage extends StatelessWidget {
  const AssignedTestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTestListPage(
      pageTitle: 'Assigned Tests',
      statusFilter: 'assigned',
    );
  }
}