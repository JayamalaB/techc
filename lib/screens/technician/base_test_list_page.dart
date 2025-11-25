import 'package:flutter/material.dart';
import '../../models/technician_test_model.dart';
import '../../services/local_storage_service.dart';

class BaseTestListPage extends StatefulWidget {
  final String pageTitle;
  final String statusFilter;

  const BaseTestListPage({
    Key? key,
    required this.pageTitle,
    required this.statusFilter,
  }) : super(key: key);

  @override
  State<BaseTestListPage> createState() => _BaseTestListPageState();
}

class _BaseTestListPageState extends State<BaseTestListPage> {
  List<TechnicianTest> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    setState(() {
      _isLoading = true;
    });
    
    final tests = await LocalStorageService.loadTechnicianTests();
    setState(() {
      _tests = tests;
      _isLoading = false;
    });
  }

  List<TechnicianTest> get _filteredTests {
    if (widget.statusFilter == 'urgent') {
      return _tests.where((test) => test.priority == 'urgent').toList();
    }
    return _tests.where((test) => test.status == widget.statusFilter).toList();
  }

  Future<void> _updateTestStatus(String testId, String newStatus, {String? result}) async {
    setState(() {
      _tests = _tests.map((test) {
        if (test.id == testId) {
          return test.copyWith(status: newStatus, result: result);
        }
        return test;
      }).toList();
    });

    await LocalStorageService.saveTechnicianTests(_tests);
  }

  void _showTestDetails(TechnicianTest test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test Details - ${test.testType}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Test ID:', test.id),
              _buildDetailRow('Patient:', test.patientName),
              _buildDetailRow('Test Type:', test.testType),
              _buildDetailRow('Time:', test.time),
              if (test.patientPhone != null) _buildDetailRow('Phone:', test.patientPhone!),
              if (test.address != null) _buildDetailRow('Address:', test.address!),
              if (test.result != null) _buildDetailRow('Result:', test.result!),
              if (test.notes != null) _buildDetailRow('Notes:', test.notes!),
              _buildDetailRow('Status:', test.status),
              _buildDetailRow('Priority:', test.priority),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTestCard(TechnicianTest test) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info;
    
    switch (test.status) {
      case 'assigned':
        statusColor = Colors.blue;
        statusIcon = Icons.assignment;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    test.testType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        test.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Patient: ${test.patientName}'),
            const SizedBox(height: 4),
            Text('Time: ${test.time}'),
            if (test.address != null) ...[
              const SizedBox(height: 4),
              Text('Address: ${test.address}'),
            ],
            if (test.priority == 'urgent') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showTestDetails(test),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                if (test.status == 'assigned') 
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _markTestAsCompleted(test),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467946),
                      ),
                      child: const Text(
                        'Mark Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _markTestAsCompleted(TechnicianTest test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Test as Completed'),
        content: const Text('Are you sure you want to mark this test as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateTestStatus(test.id, 'completed', result: 'Completed - Awaiting Results');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${test.testType} marked as completed'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Color(0xFF467946),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredTests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ${widget.pageTitle.toLowerCase()} found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        '${_filteredTests.length} ${widget.pageTitle.toLowerCase()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._filteredTests.map((test) => _buildTestCard(test)),
                    ],
                  ),
                ),
    );
  }
}