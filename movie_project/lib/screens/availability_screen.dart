import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';

class AvailabilityScreen extends StatefulWidget {
  final Movie movie;

  const AvailabilityScreen({super.key, required this.movie});

  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  int selectedSeats = 0;
  String? selectedSlotId;

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    bool isfull = false;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 167, 167),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 77, 75, 75),
        title: Text('Check Availability & Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.movie.title,
              style: GoogleFonts.zillaSlab(
                color: Color.fromARGB(255, 224, 226, 234),
                // Using Google Fonts
                fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                focusColor: Colors.white,
                dropdownColor: Colors.white,
                autofocus: true,
                borderRadius: BorderRadius.circular(10),
                isDense: true,
                padding: EdgeInsets.all(10),
                hint: Text('Select a Time Slot'),
                value: selectedSlotId,
                onChanged: (newValue) {
                  setState(() {
                    selectedSlotId = newValue;
                  });
                  movieProvider.checkAvailability(widget.movie.id, newValue!);
                },
                items: widget.movie.timeSlots.map((slot) {
                  DateTime slotTime = DateTime.parse(slot.time);

                  // Format the time: extract date, hour, and minutes
                  String formattedDate =
                      DateFormat('yMMMd').format(slotTime); //  Oct 22, 2024
                  String formattedTime = DateFormat('jm').format(slotTime);
                  return DropdownMenuItem(
                    child: Text('${formattedDate} - ${formattedTime}'),
                    value: slot.id,
                  );
                }).toList(),
              ),
            ),
            if (selectedSlotId != null)
              Text('Remaining Capacity: ${movieProvider.remainingCapacity}'),
            if (selectedSlotId != null && !isfull)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Number of Seats',
                          prefix: Icon(Icons.event_seat)),
                      onChanged: (value) {
                        selectedSeats = int.parse(value);
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      backgroundColor:
                          MaterialStateProperty.all(Colors.brown.shade400),
                    ),
                    child: Text('Reserve Seats',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (selectedSlotId != null && selectedSeats > 0) {
                        await movieProvider.reserveSeats(
                          widget.movie.id,
                          selectedSlotId!,
                          selectedSeats,
                        );

                        if (movieProvider.errorMessage.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(movieProvider.errorMessage)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reservation successful!')),
                          );
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please enter a valid number')),
                        );
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
