import 'package:flutter/material.dart';

class WorkerPerformanceScreen extends StatelessWidget {
  const WorkerPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Performance"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: summaryCard("4", "Workers")),

                const SizedBox(width: 10),

                Expanded(child: summaryCard("44", "Jobs Done")),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  workerCard("John Tan", 15, 4.8, 90),

                  workerCard("Ahmed Ali", 12, 4.6, 85),

                  workerCard("Mei Ling", 9, 4.5, 75),

                  workerCard("Ravi Kumar", 8, 4.7, 80),
                ],
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

              child: Text(
                "$performance%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
