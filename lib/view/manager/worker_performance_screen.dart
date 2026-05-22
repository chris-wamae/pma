import 'package:flutter/material.dart';

class WorkerPerformanceScreen extends StatelessWidget {
  const WorkerPerformanceScreen({super.key});

  final List<Map<String, dynamic>> workers = const [
    {"name": "John Tan", "jobs": 15, "rating": 4.8, "performance": 90},
    {"name": "Ahmed Ali", "jobs": 12, "rating": 4.6, "performance": 85},
    {"name": "Mei Ling", "jobs": 9, "rating": 4.5, "performance": 75},
    {"name": "Ravi Kumar", "jobs": 8, "rating": 4.7, "performance": 80},
  ];

  Color getPerformanceColor(int performance) {
    if (performance >= 85) {
      return Colors.green;
    } else if (performance >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalWorkers = workers.length;

    final int totalJobs = workers.fold(
      0,
      (sum, worker) => sum + (worker["jobs"] as int),
    );

    final double averageRating =
        workers.fold(0.0, (sum, worker) => sum + (worker["rating"] as double)) /
        workers.length;

    final topWorker = workers.reduce(
      (a, b) => a["performance"] > b["performance"] ? a : b,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Performance"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              elevation: 4,

              color: Colors.amber.shade100,

              child: ListTile(
                leading: const Icon(
                  Icons.emoji_events,
                  size: 40,
                  color: Colors.orange,
                ),

                title: Text(
                  topWorker["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text("Top Performer • ${topWorker["performance"]}%"),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: summaryCard("$totalWorkers", "Workers")),

                const SizedBox(width: 10),

                Expanded(child: summaryCard("$totalJobs", "Jobs Done")),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    averageRating.toStringAsFixed(1),
                    "Avg Rating",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: summaryCard(
                    "${topWorker["performance"]}%",
                    "Best Score",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: workers.length,

                itemBuilder: (context, index) {
                  final worker = workers[index];

                  return workerCard(
                    worker["name"],
                    worker["jobs"],
                    worker["rating"],
                    worker["performance"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryCard(String number, String title) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }

  Widget workerCard(
    String name,
    int jobsCompleted,
    double rating,
    int performance,
  ) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            const CircleAvatar(radius: 25, child: Icon(Icons.person)),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text("Jobs Completed: $jobsCompleted"),

                  Text("Rating: $rating ★"),

                  const SizedBox(height: 5),

                  const Text(
                    "Available",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            CircleAvatar(
              radius: 28,

              backgroundColor: getPerformanceColor(performance),

              child: Text(
                "$performance%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
