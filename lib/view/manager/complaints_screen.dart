import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String selectedFilter = "All";

  List<Map<String, dynamic>> complaints = [
    {
      "title": "Noise Complaint",
      "location": "Unit B-2-4",
      "date": "12 May 2025",
      "status": "Open",
    },
    {
      "title": "Poor Cleanliness",
      "location": "Unit C-1-2",
      "date": "11 May 2025",
      "status": "Open",
    },
    {
      "title": "Parking Issue",
      "location": "Block D",
      "date": "10 May 2025",
      "status": "Resolved",
    },
  ];

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Complaint Report", style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 20),

              ...complaints.map(
                (complaint) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(
                    "${complaint["title"]} - ${complaint["status"]}",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  int get totalComplaints => complaints.length;

  int get openComplaints =>
      complaints.where((c) => c["status"] == "Open").length;

  int get resolvedComplaints =>
      complaints.where((c) => c["status"] == "Resolved").length;

  bool shouldShow(String status) {
    if (selectedFilter == "All") {
      return true;
    }

    return selectedFilter == status;
  }

  Color getStatusColor(String status) {
    return status == "Resolved" ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Column(
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("$totalComplaints"),
                      ],
                    ),

                    Column(
                      children: [
                        const Text(
                          "Open",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("$openComplaints"),
                      ],
                    ),

                    Column(
                      children: [
                        const Text(
                          "Resolved",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("$resolvedComplaints"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: filterButton("All")),

                const SizedBox(width: 8),

                Expanded(child: filterButton("Open")),

                const SizedBox(width: 8),

                Expanded(child: filterButton("Resolved")),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,

                itemBuilder: (context, index) {
                  final complaint = complaints[index];

                  if (!shouldShow(complaint["status"])) {
                    return const SizedBox();
                  }

                  return complaintCard(complaint, index);
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () async {
                  await generatePdf();
                },

                icon: const Icon(Icons.description),

                label: const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = text;
        });
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == text
            ? Colors.blue
            : Colors.grey.shade300,
      ),

      child: Text(text),
    );
  }

  Widget complaintCard(Map<String, dynamic> complaint, int index) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: const Icon(Icons.report_problem),

        title: Text(
          complaint["title"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text("${complaint["location"]} • ${complaint["date"]}"),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              complaint["status"],
              style: TextStyle(
                color: getStatusColor(complaint["status"]),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            if (complaint["status"] == "Open")
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,

                    builder: (_) => AlertDialog(
                      title: const Text("Resolve Complaint"),

                      content: const Text("Mark this complaint as resolved?"),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text("Cancel"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              complaints[index]["status"] = "Resolved";
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Complaint resolved successfully",
                                ),
                              ),
                            );
                          },

                          child: const Text("Confirm"),
                        ),
                      ],
                    ),
                  );
                },

                child: const Text(
                  "Resolve",
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}// GestureDetector