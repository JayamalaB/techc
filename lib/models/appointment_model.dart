import 'test_model.dart';

class AppointmentModel {
  final String id;
  final List<TestModel> tests;
  final double totalAmount;
  final DateTime bookingDate;
  final String status;
  final String? technicianName;
  final String? technicianPhone;
  final String? estimatedTime;

  AppointmentModel({
    required this.id,
    required this.tests,
    required this.totalAmount,
    required this.bookingDate,
    required this.status,
    this.technicianName,
    this.technicianPhone,
    this.estimatedTime,
  });

  // Convert to Map for easier storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tests': tests.map((test) => test.toMap()).toList(),
      'totalAmount': totalAmount,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'technicianName': technicianName,
      'technicianPhone': technicianPhone,
      'estimatedTime': estimatedTime,
    };
  }

  // Create from Map
  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      tests: List<TestModel>.from(
          map['tests'].map((test) => TestModel.fromMap(test))),
      totalAmount: map['totalAmount'],
      bookingDate: DateTime.parse(map['bookingDate']),
      status: map['status'],
      technicianName: map['technicianName'],
      technicianPhone: map['technicianPhone'],
      estimatedTime: map['estimatedTime'],
    );
  }
}