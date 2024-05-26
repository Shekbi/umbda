import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umdb/models/popular_movie_response.dart';

class PopularMovieListJson extends StatefulWidget {
  const PopularMovieListJson({super.key});

  @override
  State<PopularMovieListJson> createState() => _PopularMovieListJsonState();
}

class _PopularMovieListJsonState extends State<PopularMovieListJson> {
  late List<PopularMovie> _popularMovieList = [];

  @override
  void initState() {
    super.initState();
    getPopularMovies();
  }

  void getPopularMovies() async {
    _popularMovieList = await fetchDataFromJson();
    setState(() {});
  }

  Future<List<PopularMovie>> fetchDataFromJson() async {
    final jsonString =
        await rootBundle.loadString('assets/popular_movies.json');
    final popularMoviesResponse = jsonDecode(jsonString);
    final movieList = (popularMoviesResponse['items'] as List<dynamic>)
        .map((movieJson) => PopularMovie.fromJson(movieJson));
    return movieList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the background color to black for dark theme
      child: ListView.builder(
        itemCount: _popularMovieList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 20, // Adjust the radius as needed
              backgroundImage: NetworkImage(
                _popularMovieList[index].image ?? '',
              ),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle the error
                debugPrint('Image load error: $exception');
              },
              child: _popularMovieList[index].image == null ||
                      _popularMovieList[index].image!.isEmpty
                  ? Icon(Icons.error,
                      color: Colors.white) // Placeholder in case of error
                  : null,
            ),
            title: Text(
              _popularMovieList[index].title ?? "No title",
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _popularMovieList[index].year ?? "1999",
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
