import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String selectedFilter = "All";
  Future<void> generatePdf() async {
    final pdf = pw.Document();

    final snapshot = await FirebaseFirestore.instance
        .collection("complaints")
        .get();

    final docs = snapshot.docs;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Complaint Report", style: pw.TextStyle(fontSize: 24)),

              pw.SizedBox(height: 20),

              ...docs.map((doc) {
                final data = doc.data();

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Type: ${data["type"] ?? ""}"),

                      pw.Text("Description: ${data["description"] ?? ""}"),

                      pw.Text("Status: ${data["status"] ?? ""}"),

                      pw.Divider(),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  int totalComplaints = 0;

  int openComplaints = 0;

  int resolvedComplaints = 0;

  bool shouldShow(String status) {
    if (selectedFilter == "All") {
      return true;
    }

    return selectedFilter == status;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
        return Colors.green;

      case "open":
        return Colors.orange;

      default:
        return Colors.grey;
    }
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('complaints')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  totalComplaints = docs.length;

                  openComplaints = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return (data["status"] ?? "open") == "open";
                  }).length;

                  resolvedComplaints = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return (data["status"] ?? "") == "resolved";
                  }).length;

                  final filteredDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final status = (data["status"] ?? "open")
                        .toString()
                        .toLowerCase();

                    if (selectedFilter == "All") {
                      return true;
                    }

                    if (selectedFilter == "Open") {
                      return status == "open";
                    }

                    if (selectedFilter == "Resolved") {
                      return status == "resolved";
                    }

                    return true;
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];

                      final complaint = doc.data() as Map<String, dynamic>;

                      final Timestamp? timestamp =
                          complaint["timestamp"] as Timestamp?;

                      complaint["docId"] = doc.id;

                      complaint["title"] = complaint["type"] ?? "No Title";

                      complaint["location"] =
                          complaint["description"] ?? "No Description";

                      complaint["date"] = timestamp != null
                          ? DateFormat(
                              "dd MMM yyyy HH:mm",
                            ).format(timestamp.toDate())
                          : "No Date";

                      complaint["status"] = complaint["status"] ?? "open";

                      return complaintCard(complaint, index);
                    },
                  );
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
        onTap: () {
          showDialog(
            context: context,

            builder: (_) => AlertDialog(
              title: Text(complaint["title"]),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Location: ${complaint["location"] ?? "Unknown"}"),

                  const SizedBox(height: 8),

                  Text("Date: ${complaint["date"] ?? "No Date"}"),

                  const SizedBox(height: 8),

                  Text(
                    "Status: ${complaint["status"] == "resolved" ? "Resolved" : "Open"}",
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Close"),
                ),
              ],
            ),
          );
        },

        leading: const Icon(Icons.report_problem),

        title: Text(
          complaint["title"] ?? "No Title",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(
          "${complaint["location"] ?? "Unknown"} • ${complaint["date"] ?? "No Date"}",
        ),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              complaint["status"] ?? "Open",
              style: TextStyle(
                color: getStatusColor(complaint["status"] ?? "Open"),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            if ((complaint["status"] ?? "open") == "open")
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
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("complaints")
                                .doc(complaint["docId"])
                                .update({"status": "resolved"});

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