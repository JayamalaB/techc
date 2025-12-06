import '../models/test_model.dart';

class TestService {
  static List<TestModel> getAvailableTests() {
    return [
      TestModel(
        id: '1',
        name: 'Complete Blood Count (CBC)',
        description: 'Measures overall health and detects disorders like anemia and infection',
        price: 25.99,
        duration: '24 hours',
        includes: [
          'Red blood cell count',
          'White blood cell count',
          'Hemoglobin levels',
          'Platelet count'
        ],
      ),
      TestModel(
        id: '2',
        name: 'Basic Metabolic Panel',
        description: 'Measures glucose, calcium, and electrolyte levels',
        price: 35.50,
        duration: '24-48 hours',
        includes: [
          'Glucose levels',
          'Calcium levels',
          'Sodium & Potassium',
          'Kidney function'
        ],
      ),
      TestModel(
        id: '3',
        name: 'Lipid Panel',
        description: 'Measures cholesterol and triglyceride levels for heart health',
        price: 29.99,
        duration: '24 hours',
        includes: [
          'Total cholesterol',
          'HDL cholesterol',
          'LDL cholesterol',
          'Triglycerides'
        ],
      ),
      TestModel(
        id: '4',
        name: 'Thyroid Function Test',
        description: 'Evaluates thyroid gland function and hormone levels',
        price: 45.00,
        duration: '48 hours',
        includes: [
          'TSH levels',
          'T3 & T4 hormones',
          'Thyroid antibody tests'
        ],
      ),
    ];
  }

  static List<TestModel> getComboTests() {
    return [
      TestModel(
        id: 'combo1',
        name: 'Basic Health Checkup',
        description: 'Comprehensive basic health screening package',
        price: 85.99,
        duration: '24-48 hours',
        includes: [
          'Complete Blood Count',
          'Basic Metabolic Panel',
          'Lipid Panel',
          'Vitamin D levels'
        ],
        isCombo: true,
      ),
      TestModel(
        id: 'combo2',
        name: 'Advanced Health Panel',
        description: 'Complete health assessment with advanced markers',
        price: 149.99,
        duration: '48-72 hours',
        includes: [
          'All Basic Health Checkup tests',
          'Liver Function Test',
          'Kidney Function Test',
          'Thyroid Function Test',
          'Diabetes Screening'
        ],
        isCombo: true,
      ),
    ];
  }
}