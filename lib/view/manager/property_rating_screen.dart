import 'package:flutter/material.dart';

class PropertyRatingScreen extends StatefulWidget {
  const PropertyRatingScreen({super.key});

  @override
  State<PropertyRatingScreen> createState() => _PropertyRatingScreenState();
}

class _PropertyRatingScreenState extends State<PropertyRatingScreen> {
  final TextEditingController propertyController = TextEditingController();

  final TextEditingController commentController = TextEditingController();

  double selectedRating = 5.0;

  List<Map<String, dynamic>> ratings = [
    {"property": "Block A", "rating": 4.8, "comment": "Excellent"},
    {"property": "Block B", "rating": 4.5, "comment": "Very Good"},
    {"property": "Block C", "rating": 4.1, "comment": "Good"},
    {"property": "Block D", "rating": 3.7, "comment": "Average"},
  ];

  @override
  Widget build(BuildContext context) {
    double overallRating =
        ratings.fold<double>(0, (sum, item) => sum + item["rating"]) /
        ratings.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Satisfaction"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    TextField(
                      controller: propertyController,

                      decoration: const InputDecoration(
                        labelText: "Property Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButton<double>(
                      value: selectedRating,
                      isExpanded: true,

                      items: [1, 2, 3, 4, 5]
                          .map(
                            (rating) => DropdownMenuItem(
                              value: rating.toDouble(),
                              child: Text("$rating Star"),
                            ),
                          )
                          .toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedRating = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: commentController,

                      decoration: const InputDecoration(
                        labelText: "Comment",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          if (propertyController.text.isNotEmpty) {
                            setState(() {
                              ratings.add({
                                "property": propertyController.text,
                                "rating": selectedRating,
                                "comment": commentController.text,
                              });
                            });

                            propertyController.clear();
                            commentController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Rating added successfully"),
                              ),
                            );
                          }
                        },

                        child: const Text("Submit Rating"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...ratings.map(
              (rating) => buildRatingCard(
                rating["property"],
                rating["rating"],
                rating["comment"],
                Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      "Overall Rating",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${overallRating.toStringAsFixed(1)} / 5.0",
                      style: const TextStyle(
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
    String comment,
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

        subtitle: Text(comment),

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
