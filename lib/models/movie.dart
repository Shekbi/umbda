class Movie {
  final String id;
  final String rank;
  final String title;
  final String fullTitle;
  final String year;
  final String image;
  final String crew;
  final String imDbRating;
  final String imDbRatingCount;

  Movie({
    required this.id,
    required this.rank,
    required this.title,
    required this.fullTitle,
    required this.year,
    required this.image,
    required this.crew,
    required this.imDbRating,
    required this.imDbRatingCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      rank: json['rank'],
      title: json['title'],
      fullTitle: json['fullTitle'],
      year: json['year'],
      image: json['image'],
      crew: json['crew'],
      imDbRating: json['imDbRating'],
      imDbRatingCount: json['imDbRatingCount'],
    );
  }
}

class MovieList {
  final List<Movie> items;
  final String errorMessage;

  MovieList({required this.items, required this.errorMessage});

  factory MovieList.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Movie> movieList = list.map((i) => Movie.fromJson(i)).toList();
    return MovieList(
      items: movieList,
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
