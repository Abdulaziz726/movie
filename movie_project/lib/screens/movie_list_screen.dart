import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import 'availability_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 167, 167),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 77, 75, 75),
        title: Text('Movies'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<MovieProvider>(context, listen: false).fetchMovies(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Error fetching movies'));
          } else {
            return Consumer<MovieProvider>(
              builder: (ctx, movieProvider, child) {
                return ListView.builder(
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (ctx, index) {
                    final movie = movieProvider.movies[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Color.fromARGB(255, 64, 81, 94),
                        hoverColor: Colors.grey[900],
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        title: Text(
                          movie.title,
                          style: GoogleFonts.zillaSlab(
                            color: Color.fromARGB(255, 199, 203, 219),
                            // Using Google Fonts
                            fontSize:
                                Theme.of(context).textTheme.headline6!.fontSize,
                          ),
                        ),
                        subtitleTextStyle: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .fontSize),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.values[2],
                            children: movie.timeSlots.map((slot) {
                              DateTime slotTime = DateTime.parse(slot.time);

                              // Format the time: extract date, hour, and minutes
                              String formattedDate = DateFormat('yMMMd')
                                  .format(slotTime); //  Oct 22, 2024
                              String formattedTime =
                                  DateFormat('jm').format(slotTime);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.values[5],
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(
                                      width: 90, child: Text(formattedDate)),
                                  Icon(Icons.access_time),
                                  SizedBox(
                                      width: 70, child: Text(formattedTime)),
                                  Icon(Icons.chair),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      ' ${slot.booked}/${slot.capacity} ',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  AvailabilityScreen(movie: movie),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
