import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:umdb/cubits/movie_list_ui_state.dart';
import 'package:umdb/cubits/popular_movie_cubit.dart';
import 'package:umdb/models/popular_movie_response.dart';

import '../models/popular_movie_hive.dart';

class PopularMovieListCubit extends StatefulWidget {
  const PopularMovieListCubit({super.key});

  @override
  State<PopularMovieListCubit> createState() => _PopularMovieListCubitState();
}

class _PopularMovieListCubitState extends State<PopularMovieListCubit> {
  late Box<PopularMovieHive> _movieBox;
  late List<PopularMovieHive> _favoriteMovieHiveList;

  @override
  void initState() {
    super.initState();
    context.read<PopularMovieCubit>().getPopularMovies();
    _movieBox = Hive.box('popular-movies');
    fetchFavouriteMovies();
  }

  void _saveMovie(PopularMovieHive movie) {
    _movieBox.add(movie);
    fetchFavouriteMovies();
    print('Favourite list = $_favoriteMovieHiveList');
    setState(() {});
  }

  void _deleteMovie(PopularMovieHive movie) {
    movie.delete();
    fetchFavouriteMovies();
    setState(() {});
  }

  void fetchFavouriteMovies() async {
    _favoriteMovieHiveList = _movieBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the background color to black for dark theme
      child: BlocBuilder<PopularMovieCubit, UiState>(
        builder: (context, state) {
          return switch (state) {
            Initial() => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            Loading() => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            Success() => ListView.builder(
                itemCount: state.movieList.length,
                itemBuilder: (context, index) {
                  final movie = state.movieList[index];
                  var isFavourite = _favoriteMovieHiveList
                      .any((favMovie) => favMovie.title == movie.title);
                  late PopularMovieHive? favoriteMovieHive;
                  if (isFavourite) {
                    favoriteMovieHive = _favoriteMovieHiveList.firstWhere(
                        (favMovie) => favMovie.title == movie.title);
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        movie.image ?? '',
                      ),
                      onBackgroundImageError: (exception, stackTrace) {
                        debugPrint('Image load error: $exception');
                      },
                      child: movie.image == null || movie.image!.isEmpty
                          ? Icon(Icons.error, color: Colors.white)
                          : null,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title ?? "No title",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavourite ? Colors.red : Colors.white,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      movie.year ?? "1999",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      final movieHive = PopularMovieHive(
                          title: movie.title, year: movie.year);
                      isFavourite
                          ? _deleteMovie(favoriteMovieHive!)
                          : _saveMovie(movieHive);
                    },
                    tileColor: isFavourite
                        ? Colors.greenAccent.withOpacity(0.2)
                        : Colors.black,
                  );
                },
              ),
            Error() => const Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          };
        },
      ),
    );
  }
}
