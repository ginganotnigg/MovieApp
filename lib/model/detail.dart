import 'package:movie_app/model/cast.dart';

class MovieDetail {
  final int id;
  final String title;
  final String backdropPath;
  final String budget;
  final String originalTitle;
  final String overview;
  final String releaseDate;
  final List<dynamic> genres;
  final int runtime;
  final double voteAverage;
  final int voteCount;

  String? trailerId;
  List<String>? movieImages;
  List<Cast>? credits;

  MovieDetail(
      {required this.id,
      required this.title,
      required this.backdropPath,
      required this.budget,
      required this.originalTitle,
      required this.overview,
      required this.releaseDate,
      required this.genres,
      required this.runtime,
      required this.voteAverage,
      required this.voteCount});

  factory MovieDetail.fromJson(dynamic json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'] as String,
      backdropPath: json['backdrop_path'] as String,
      budget: json['budget'].toString(),
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String,
      releaseDate: json['release_date'] as String,
      genres: json['genres'] as List<dynamic>,
      runtime: json['runtime'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }
}
