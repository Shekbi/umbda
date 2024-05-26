import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umdb/cubits/top_rated_movie_list_ui_state.dart';

import '../cubits/top_rated_movie_cubit.dart';

class TopRatedMovieListCubit extends StatefulWidget {
  const TopRatedMovieListCubit({super.key});

  @override
  State<TopRatedMovieListCubit> createState() => _TopRatedMovieListCubitState();
}

class _TopRatedMovieListCubitState extends State<TopRatedMovieListCubit> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedMovieCubit>().fetchTopRatedMoviesFromUrl();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopRatedMovieCubit, TopRatedMovieListUiState>(
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
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20, // Adjusted the radius for better visibility
                    backgroundImage: NetworkImage(
                      movie.image.toString(),
                    ),
                  ),
                  title: Text(
                    movie.title ?? 'No Title',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    movie.year ?? 'No Title',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          Error() => const Center(
              child: Text(
                "Some error occurred!",
                style: TextStyle(color: Colors.white),
              ),
            ),
        };
      },
    );
  }
}
