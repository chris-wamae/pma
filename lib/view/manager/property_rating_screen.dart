import 'package:flutter/material.dart';

class PropertyRatingScreen extends StatelessWidget {
  const PropertyRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Satisfaction"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            buildRatingCard("Block A", 4.8, "Excellent", Colors.green),

            buildRatingCard("Block B", 4.5, "Very Good", Colors.blue),

            buildRatingCard("Block C", 4.1, "Good", Colors.orange),

            buildRatingCard("Block D", 3.7, "Average", Colors.red),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: const [
                    Text(
                      "Overall Rating",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "4.3 / 5.0",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRatingCard(
    String property,
    double rating,
    String level,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: const Icon(Icons.apartment),

        title: Text(
          property,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text(level),

        trailing: Text(
          "$rating ★",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
