import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/technician_test_model.dart';

class LocalStorageService {
  static const String _technicianTestsKey = 'technician_assigned_tests';

  // Save technician tests to local storage
  static Future<void> saveTechnicianTests(List<TechnicianTest> tests) async {
    final prefs = await SharedPreferences.getInstance();
    final testsJson = tests.map((test) => test.toJson()).toList();
    await prefs.setString(_technicianTestsKey, json.encode(testsJson));
  }

  // Load technician tests from local storage
  static Future<List<TechnicianTest>> loadTechnicianTests() async {
    final prefs = await SharedPreferences.getInstance();
    final testsJsonString = prefs.getString(_technicianTestsKey);
    
    if (testsJsonString == null) {
      // Return default tests if no data exists
      return _getDefaultTechnicianTests();
    }
    
    try {
      final List<dynamic> testsJson = json.decode(testsJsonString);
      return testsJson.map((json) => TechnicianTest.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultTechnicianTests();
    }
  }

  // Get default technician test data
  static List<TechnicianTest> _getDefaultTechnicianTests() {
    return [
      TechnicianTest(
        id: 'T001',
        patientName: 'John Doe',
        testType: 'Blood Glucose',
        time: '10:00 AM',
        address: '123 Main St, City',
        status: 'assigned',
        priority: 'normal',
        patientPhone: '+1234567890',
        notes: 'Fasting blood test required',
        createdAt: DateTime.now(),
      ),
      TechnicianTest(
        id: 'T002',
        patientName: 'Sarah Smith',
        testType: 'Lipid Profile',
        time: '11:30 AM',
        address: '456 Oak Ave, Town',
        status: 'assigned',
        priority: 'urgent',
        patientPhone: '+1234567891',
        notes: 'Patient has high cholesterol history',
        createdAt: DateTime.now(),
      ),
      TechnicianTest(
        id: 'T003',
        patientName: 'Mike Johnson',
        testType: 'Liver Function Test',
        time: '2:00 PM',
        address: '789 Pine Rd, Village',
        status: 'assigned',
        priority: 'normal',
        patientPhone: '+1234567892',
        createdAt: DateTime.now(),
      ),
      TechnicianTest(
        id: 'T004',
        patientName: 'Emma Wilson',
        testType: 'Thyroid Panel',
        time: 'Completed: 9:00 AM',
        status: 'completed',
        priority: 'normal',
        result: 'Normal - TSH: 2.1 mIU/L',
        patientPhone: '+1234567893',
        notes: 'All parameters within normal range',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      TechnicianTest(
        id: 'T005',
        patientName: 'Robert Brown',
        testType: 'Complete Blood Count',
        time: 'Completed: 9:45 AM',
        status: 'completed',
        priority: 'normal',
        result: 'Abnormal - Low hemoglobin: 10.2 g/dL',
        patientPhone: '+1234567894',
        notes: 'Recommend follow-up with hematologist',
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
      ),
      TechnicianTest(
        id: 'T006',
        patientName: 'Lisa Taylor',
        testType: 'Vitamin D Test',
        time: 'Scheduled: 3:30 PM',
        status: 'pending',
        priority: 'normal',
        patientPhone: '+1234567895',
        createdAt: DateTime.now().add(Duration(hours: 2)),
      ),
      TechnicianTest(
        id: 'T007',
        patientName: 'David Lee',
        testType: 'HbA1c Test',
        time: 'Scheduled: 4:15 PM',
        status: 'pending',
        priority: 'normal',
        patientPhone: '+1234567896',
        notes: 'Diabetes monitoring',
        createdAt: DateTime.now().add(Duration(hours: 3)),
      ),
    ];
  }
}