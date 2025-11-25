import 'package:flutter/material.dart';
import 'role_selection_page.dart';
import '../screens/technician/assigned_tests_page.dart';
import '../screens/technician/completed_tests_page.dart';
import '../screens/technician/pending_tests_page.dart';
import '../screens/technician/urgent_tests_page.dart';
import '../services/local_storage_service.dart';
import '../models/technician_test_model.dart';

class TechnicianDashboard extends StatefulWidget {
  final String email;

  const TechnicianDashboard({Key? key, required this.email}) : super(key: key);

  @override
  State<TechnicianDashboard> createState() => _TechnicianDashboardState();
}

class _TechnicianDashboardState extends State<TechnicianDashboard> {
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

  int get assignedCount => _tests.where((test) => test.status == 'assigned').length;
  int get completedCount => _tests.where((test) => test.status == 'completed').length;
  int get pendingCount => _tests.where((test) => test.status == 'pending').length;
  int get urgentCount => _tests.where((test) => test.priority == 'urgent').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Dashboard'),
        backgroundColor: Color(0xFF467946),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RoleSelectionPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  
                  // Quick stats
                  _buildQuickStats(),
                  const SizedBox(height: 24),
                  
                  // Quick actions
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  
                  // Recent Assigned Tests
                  _buildRecentTests(),
                ],
              ),
            ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF467946),
              child: Icon(
                Icons.engineering,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Technician!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Overview",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Assigned Tests',
                assignedCount.toString(),
                Icons.assignment,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Completed',
                completedCount.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Pending',
                pendingCount.toString(),
                Icons.pending_actions,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Urgent',
                urgentCount.toString(),
                Icons.warning,
                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildActionCard('Assigned Tests', Icons.assignment, Colors.blue, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AssignedTestsPage()),
              );
            }),
            _buildActionCard('Completed Tests', Icons.check_circle, Colors.green, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompletedTestsPage()),
              );
            }),
            _buildActionCard('Pending Tests', Icons.pending_actions, Colors.orange, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PendingTestsPage()),
              );
            }),
            _buildActionCard('Urgent Tests', Icons.warning, Colors.red, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UrgentTestsPage()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTests() {
    final recentTests = _tests
        .where((test) => test.status == 'assigned')
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Assigned Tests',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...recentTests.map((test) => _buildTestCard(test)),
        if (recentTests.isEmpty)
          const Center(
            child: Text(
              'No assigned tests',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(TechnicianTest test) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: test.priority == 'urgent' ? Colors.red : Colors.blue,
          child: Icon(
            test.priority == 'urgent' ? Icons.warning : Icons.assignment,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(test.testType),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${test.patientName}'),
            if (test.priority == 'urgent')
              Text(
                'URGENT',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Text(test.time),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssignedTestsPage()),
          );
        },
      ),
    );
  }
}