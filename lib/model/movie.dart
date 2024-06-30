class Movie {
  final String backdropPath;
  final int id;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;

  Movie(
      {required this.backdropPath,
      required this.id,
      required this.overview,
      required this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.voteAverage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        backdropPath:
            (json['backdrop_path'] == null) ? 'null' : json['backdrop_path'],
        id: json['id'] as int,
        overview: json['overview'],
        posterPath:
            (json['poster_path'] == null) ? 'null' : json['poster_path'],
        releaseDate: json['release_date'],
        title: json['title'],
        voteAverage: json['vote_average']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'backdrop_path': backdropPath,
      'id': id,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'vote_average': voteAverage
    };
  }
}
