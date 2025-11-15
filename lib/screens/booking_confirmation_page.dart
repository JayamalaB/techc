import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../patient_dashboard.dart';
import '../services/appointment_service.dart'; // Add this import

class BookingConfirmationPage extends StatelessWidget {
  final List<TestModel> selectedTests;
  final double totalAmount;

  const BookingConfirmationPage({
    Key? key,
    required this.selectedTests,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Save appointment when this page is created
    AppointmentService.addAppointment(selectedTests, totalAmount);

    return Scaffold(
      // ... rest of the existing code remains the same ...
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),

              // Success Message
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Your blood test has been successfully booked',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Amount Paid: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),

              // Booking Details
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...selectedTests.map((test) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.medical_services, size: 20),
                        title: Text(test.name),
                        trailing: Text('\$${test.price.toStringAsFixed(2)}'),
                      )).toList(),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.access_time, size: 20),
                        title: const Text('Expected Results'),
                        trailing: Text(selectedTests
                            .map((test) => test.duration)
                            .reduce((a, b) => a.length > b.length ? a : b)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PatientDashboard(email: 'patient@gmail.com')),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF467946)
,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to appointments page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PatientDashboard(email: 'patient@gmail.com')),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Color(0xFF467946)
!),
                      ),
                      child: Text(
                        'View My Appointments',
                        style: TextStyle(
                          color: Color(0xFF467946)
,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}