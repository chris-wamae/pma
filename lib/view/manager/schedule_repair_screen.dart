import 'package:flutter/material.dart';

class ScheduleRepairScreen extends StatefulWidget {
  const ScheduleRepairScreen({super.key});

  @override
  State<ScheduleRepairScreen> createState() => _ScheduleRepairScreenState();
}

class _ScheduleRepairScreenState extends State<ScheduleRepairScreen> {
  String selectedRequest = "Leaking Pipe";
  String selectedWorker = "John Tan";

  String selectedDate = "25 May 2026";
  String selectedTime = "10:00 AM";

  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Repair"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            const Text(
              "Select Request",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedRequest,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: const [
                DropdownMenuItem(
                  value: "Leaking Pipe",
                  child: Text("Leaking Pipe"),
                ),

                DropdownMenuItem(
                  value: "Broken Aircond",
                  child: Text("Broken Aircond"),
                ),

                DropdownMenuItem(
                  value: "Light Not Working",
                  child: Text("Light Not Working"),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedRequest = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Assign Worker",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedWorker,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              items: const [
                DropdownMenuItem(value: "John Tan", child: Text("John Tan")),

                DropdownMenuItem(value: "Ahmed Ali", child: Text("Ahmed Ali")),

                DropdownMenuItem(value: "Mei Ling", child: Text("Mei Ling")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedWorker = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,

                    child: ListTile(
                      leading: const Icon(Icons.calendar_month),

                      title: const Text("Date"),

                      subtitle: Text(selectedDate),

                      trailing: const Icon(Icons.edit_calendar),

                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2025),
                          lastDate: DateTime(2030),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Time"),
                subtitle: Text(selectedTime),
                trailing: const Icon(Icons.schedule),

                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime.format(context);
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Notes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: notesController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: "Enter repair instructions...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Repair Scheduled Successfully"),
                    ),
                  );
                },

                icon: const Icon(Icons.check),

                label: const Text("Schedule Repair"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
