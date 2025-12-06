import 'package:flutter/material.dart';
import '../utils/csv_helper.dart';

class ViewReportsPage extends StatelessWidget {
  const ViewReportsPage({Key? key}) : super(key: key);

  final List<Map<String, String>> reportData = const [
    {
      "test": "Blood Test",
      "date": "2025-02-01",
      "result": "Normal",
    },
    {
      "test": "X-Ray",
      "date": "2025-02-03",
      "result": "Clear",
    },
    {
      "test": "ECG",
      "date": "2025-02-05",
      "result": "Normal",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reports"),
        backgroundColor: Color(0xFF467946),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              List<List<dynamic>> csvRows = [
                ["Test Name", "Date", "Result"],
                ...reportData.map((r) => [r["test"], r["date"], r["result"]]),
              ];

              await CSVHelper.saveCSV(
                rows: csvRows,
                fileName: "my_reports.csv",
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("CSV Downloaded Successfully")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Your Lab Reports",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reportData.length,
                itemBuilder: (context, index) {
                  final item = reportData[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      title: Text(
                        item["test"]!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Date: ${item['date']}\nResult: ${item['result']}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                "Download CSV Report",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () async {
                List<List<dynamic>> csvRows = [
                  ["Test Name", "Date", "Result"],
                  ...reportData.map((r) => [r["test"], r["date"], r["result"]]),
                ];

                await CSVHelper.saveCSV(
                  rows: csvRows,
                  fileName: "my_reports.csv",
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("CSV Downloaded Successfully")),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
