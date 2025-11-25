import 'package:flutter/material.dart';
import 'base_test_list_page.dart';

class CompletedTestsPage extends StatelessWidget {
  const CompletedTestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BaseTestListPage(
      pageTitle: 'Completed Tests',
      statusFilter: 'completed',
    );
  }
}