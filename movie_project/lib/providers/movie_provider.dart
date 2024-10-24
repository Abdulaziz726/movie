import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  int remainingCapacity = 0;
  String errorMessage = '';

  List<Movie> get movies => _movies;

  Future<void> fetchMovies() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/movies'));
      if (response.statusCode == 200) {
        List<Movie> loadedMovies = [];
        var extractedData = json.decode(response.body) as List;
        for (var movieData in extractedData) {
          loadedMovies.add(Movie.fromJson(movieData));
        }
        _movies = loadedMovies;
        notifyListeners();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> checkAvailability(String movieId, String slotId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/movies/$movieId/slots/$slotId/availability'),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        remainingCapacity = data['remainingCapacity'];
      } else {
        throw Exception('Failed to check availability');
      }
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> reserveSeats(String movieId, String slotId, int seats) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/movies/$movieId/slots/$slotId/reserve'),
        body: json.encode({'numberOfSeats': seats}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        await fetchMovies(); // Refresh the movie list after reservation
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        throw Exception(
            responseBody['message'] ?? 'Reservation failed. Please try again.');
      }
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }
}
