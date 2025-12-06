import '../models/appointment_model.dart';
import '../models/test_model.dart';

class AppointmentService {
  static List<AppointmentModel> _appointments = [];

  static List<AppointmentModel> getAppointments() {
    return _appointments;
  }

  static void addAppointment(List<TestModel> tests, double totalAmount) {
    final appointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tests: tests,
      totalAmount: totalAmount,
      bookingDate: DateTime.now(),
      status: _getInitialStatus(),
      technicianName: _getRandomTechnician(),
      technicianPhone: _getRandomPhone(),
      estimatedTime: '30-45 minutes',
    );

    _appointments.insert(0, appointment); // Add to beginning for latest first
  }

  static String _getInitialStatus() {
    // Random status for demo
    final statuses = ['Scheduled', 'Technician Assigned', 'Sample Collection'];
    return statuses[DateTime.now().second % statuses.length];
  }

  static String _getRandomTechnician() {
    final technicians = ['John Smith', 'Sarah Johnson', 'Mike Davis', 'Emily Wilson'];
    return technicians[DateTime.now().minute % technicians.length];
  }

  static String _getRandomPhone() {
    final phones = ['+1 (555) 123-4567', '+1 (555) 987-6543', '+1 (555) 456-7890'];
    return phones[DateTime.now().second % phones.length];
  }

  static void updateAppointmentStatus(String appointmentId, String newStatus) {
    final index = _appointments.indexWhere((appt) => appt.id == appointmentId);
    if (index != -1) {
      final updatedAppointment = AppointmentModel(
        id: _appointments[index].id,
        tests: _appointments[index].tests,
        totalAmount: _appointments[index].totalAmount,
        bookingDate: _appointments[index].bookingDate,
        status: newStatus,
        technicianName: _appointments[index].technicianName,
        technicianPhone: _appointments[index].technicianPhone,
        estimatedTime: _appointments[index].estimatedTime,
      );
      _appointments[index] = updatedAppointment;
    }
  }
}