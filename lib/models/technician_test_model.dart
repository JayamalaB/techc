class TechnicianTest {
  final String id;
  final String patientName;
  final String testType;
  final String time;
  final String? address;
  final String status; // assigned, completed, pending
  final String priority; // normal, urgent
  final String? result;
  final DateTime createdAt;
  final String? patientPhone;
  final String? notes;

  TechnicianTest({
    required this.id,
    required this.patientName,
    required this.testType,
    required this.time,
    this.address,
    required this.status,
    required this.priority,
    this.result,
    required this.createdAt,
    this.patientPhone,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'testType': testType,
      'time': time,
      'address': address,
      'status': status,
      'priority': priority,
      'result': result,
      'createdAt': createdAt.toIso8601String(),
      'patientPhone': patientPhone,
      'notes': notes,
    };
  }

  factory TechnicianTest.fromJson(Map<String, dynamic> json) {
    return TechnicianTest(
      id: json['id'],
      patientName: json['patientName'],
      testType: json['testType'],
      time: json['time'],
      address: json['address'],
      status: json['status'],
      priority: json['priority'],
      result: json['result'],
      createdAt: DateTime.parse(json['createdAt']),
      patientPhone: json['patientPhone'],
      notes: json['notes'],
    );
  }

  TechnicianTest copyWith({
    String? status,
    String? result,
    String? time,
    String? notes,
  }) {
    return TechnicianTest(
      id: id,
      patientName: patientName,
      testType: testType,
      time: time ?? this.time,
      address: address,
      status: status ?? this.status,
      priority: priority,
      result: result ?? this.result,
      createdAt: createdAt,
      patientPhone: patientPhone,
      notes: notes ?? this.notes,
    );
  }
}