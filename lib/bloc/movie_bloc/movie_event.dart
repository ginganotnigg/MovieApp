import 'package:equatable/equatable.dart';
import 'package:movie_app/model/movie.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  get movieId => null;
}

class MovieStarted extends MovieEvent {
  @override
  final int movieId;
  final String query;

  const MovieStarted(this.movieId, this.query);

  @override
  List<Object> get props => [];
}

class WatchlistMovieAdd extends MovieEvent {
  final Movie movie;

  const WatchlistMovieAdd(this.movie);

  @override
  List<Object> get props => [];
}

// class WatchlistMovieRemove extends MovieEvent {
//   @override
//   final int movieId;

//   const WatchlistMovieRemove(this.movieId);

//   @override
//   List<Object> get props => [];
// }

class WatchlistMovieRemove extends MovieEvent {
  final Movie movie;

  const WatchlistMovieRemove(this.movie);

  @override
  List<Object> get props => [];
}
