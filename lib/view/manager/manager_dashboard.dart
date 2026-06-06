import 'package:flutter/material.dart';
import 'package:pma/view/manager/maintenance_screen.dart';
import 'package:pma/view/manager/task_management_screen.dart';
import 'package:pma/view/manager/communication_screen.dart';
import 'package:pma/view/manager/worker_performance_screen.dart';
import 'package:pma/view/manager/schedule_repair_screen.dart';
import 'package:pma/view/manager/complaints_screen.dart';
import 'package:pma/view/manager/assign_worker_screen.dart';
import 'package:pma/view/manager/upload_files_screen.dart';
import 'package:pma/view/manager/request_classification_screen.dart';
import 'package:pma/view/manager/utility_bills_screen.dart';
import 'package:pma/view/manager/tenant_management_screen.dart';
import 'package:pma/view/manager/property_rating_screen.dart';
import 'package:pma/view/manager/priority_requests_screen.dart';
import 'package:pma/view/manager/rent_collection_screen.dart';
import 'package:pma/view/manager/request_details_screen.dart';
import 'package:pma/view/tenant/ChatListScreen.dart';
import 'package:pma/view/manager/manager_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int totalRequests = 0;
  int completedRequests = 0;
  int pendingRequests = 0;
  int inProgressRequests = 0;
  int openComplaints = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Dashboard"),

        actions: [
          IconButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManagerProfilePage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('maintenance_requests')
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          totalRequests = docs.length;

          pendingRequests = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data["status"] ?? "").toString().toLowerCase() == "pending";
          }).length;

          inProgressRequests = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data["status"] ?? "").toString().toLowerCase() ==
                "in progress";
          }).length;

          completedRequests = docs.where((doc) {
            FirebaseFirestore.instance
                .collection('complaints')
                .where('status', isEqualTo: 'pending');

            final data = doc.data() as Map<String, dynamic>;
            return (data["status"] ?? "").toString().toLowerCase() ==
                "completed";
          }).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: dashboardBox(
                        totalRequests.toString(),
                        "Total Requests",
                        Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: dashboardBox(
                        inProgressRequests.toString(),
                        "In Progress",
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: dashboardBox(
                        completedRequests.toString(),
                        "Completed",
                        Colors.green,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: dashboardBox(
                        pendingRequests.toString(),
                        "Pending",
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PriorityRequestsScreen(),
                      ),
                    );
                  },

                  child: Card(
                    elevation: 3,
                    color: pendingRequests == 0
                        ? Colors.green.shade50
                        : Colors.orange.shade50,

                    child: ListTile(
                      leading: const Icon(
                        Icons.warning_amber,
                        color: Colors.orange,
                      ),

                      title: const Text(
                        "Pending Alerts",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        "$pendingRequests pending requests require attention",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ComplaintsScreen(),
                      ),
                    );
                  },

                  child: Card(
                    elevation: 3,
                    color: Colors.red.shade50,

                    child: ListTile(
                      leading: const Icon(
                        Icons.report_problem,
                        color: Colors.red,
                      ),

                      title: const Text(
                        "Open Complaints",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: const Text("View complaints"),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Requests",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MaintenanceScreen(),
                          ),
                        );
                      },
                      child: const Text("View All"),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('maintenance_requests')
                      .orderBy('createdAt', descending: true)
                      .limit(3)
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final docs = snapshot.data!.docs;

                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final title = data["category"] ?? "Request";
                        final room = data["tenantName"] ?? "";
                        final status = data["status"] ?? "pending";

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RequestDetailsScreen(
                                  docId: doc.id,
                                  currentStatus: status,
                                ),
                              ),
                            );
                          },

                          child: requestCard(
                            title,
                            room,
                            status,
                            getStatusColor(status),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 25),
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: quickActionButton(
                        context,
                        "Assign Worker",
                        Icons.person_add,
                        const AssignWorkerScreen(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: quickActionButton(
                        context,
                        "Create Task",
                        Icons.assignment_add,
                        const TaskManagementScreen(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: quickActionButton(
                        context,
                        "Send Notice",
                        Icons.campaign,
                        const CommunicationScreen(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: quickActionButton(
                        context,
                        "Reports",
                        Icons.description,
                        const ComplaintsScreen(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Manager Functions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                functionCard(
                  context,
                  "Issues & Maintenance",
                  Icons.build,
                  const MaintenanceScreen(),
                ),

                functionCard(
                  context,
                  "Task Management",
                  Icons.assignment,
                  const TaskManagementScreen(),
                ),

                functionCard(
                  context,
                  "Communication",
                  Icons.campaign,
                  const CommunicationScreen(),
                ),

                functionCard(
                  context,
                  "Worker Performance",
                  Icons.people,
                  const WorkerPerformanceScreen(),
                ),

                functionCard(
                  context,
                  "Assign Worker",
                  Icons.person_add,
                  const AssignWorkerScreen(),
                ),

                functionCard(
                  context,
                  "Schedule Repair",
                  Icons.calendar_month,
                  const ScheduleRepairScreen(),
                ),

                functionCard(
                  context,
                  "Complaints & Reports",
                  Icons.report_problem,
                  const ComplaintsScreen(),
                ),

                functionCard(
                  context,
                  "Upload Files",
                  Icons.upload_file,
                  const UploadFilesScreen(),
                ),

                functionCard(
                  context,
                  "Request Classification",
                  Icons.category,
                  const RequestClassificationScreen(),
                ),

                functionCard(
                  context,
                  "Shared Utility Bills",
                  Icons.receipt_long,
                  const UtilityBillsScreen(),
                ),

                functionCard(
                  context,
                  "Tenant Management",
                  Icons.people_alt,
                  const TenantManagementScreen(),
                ),

                functionCard(
                  context,
                  "Property Satisfaction",
                  Icons.star,
                  const PropertyRatingScreen(),
                ),

                functionCard(
                  context,
                  "Rent Collection Status",
                  Icons.payments,
                  const RentCollectionScreen(),
                ),
              ],
            ),
          );
        },
      ), // SingleChildScrollView
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaintenanceScreen()),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskManagementScreen()),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatListScreen()),
              );
              break;

            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TenantManagementScreen(),
                ),
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Maintenance',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),

          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),

          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    ); // Scaffold
  }

  Widget dashboardBox(String number, String title, Color color) {
    return Container(
      height: 120,

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.red;

      case "in progress":
        return Colors.orange;

      case "completed":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  Widget requestCard(String title, String room, String status, Color color) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 10),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: const Icon(Icons.build),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(room),

        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget quickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return SizedBox(
      height: 90,

      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 28),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget functionCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget? screen,
  ) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 10),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        },
      ),
    );
  }
}
