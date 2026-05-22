import 'package:flutter/material.dart';

class PropertyRatingScreen extends StatelessWidget {
  const PropertyRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Satisfaction Rating"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      "Overall Rating",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "★★★★☆",
                      style: TextStyle(fontSize: 40, color: Colors.amber),
                    ),

                    const Text(
                      "4.5 / 5.0",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ratingCard("Maintenance Service", 4.7),

            ratingCard("Security", 4.5),

            ratingCard("Cleanliness", 4.4),

            ratingCard("Facilities", 4.3),
          ],
        ),
      ),
    );
  }

  Widget ratingCard(String title, double rating) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),

        title: Text(title),

        trailing: Text(
          rating.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
