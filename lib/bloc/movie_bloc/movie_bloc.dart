import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/service/api_service.dart';
import 'package:movie_app/service/watchlist_repository.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final service = ApiService();
      emit(MovieLoading());
      try {
        List<Movie> movieList;
        if (ev.movieId != 0) {
          movieList = await service.getSelectedMovies(ev.movieId);
        } else {
          movieList = await service.getNowPlayingMovies();
        }
        emit(MovieLoaded(movieList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

class TopRatedBloc extends Bloc<MovieEvent, MovieState> {
  TopRatedBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final service = ApiService();
      emit(MovieLoading());
      try {
        List<Movie> movieList = await service.getTopRatedMovies();
        emit(MovieLoaded(movieList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

class UpcomingBloc extends Bloc<MovieEvent, MovieState> {
  UpcomingBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final service = ApiService();
      emit(MovieLoading());
      try {
        List<Movie> movieList = await service.getUpcomingMovies();
        emit(MovieLoaded(movieList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

class PopularBloc extends Bloc<MovieEvent, MovieState> {
  PopularBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final service = ApiService();
      emit(MovieLoading());
      try {
        List<Movie> movieList = await service.getMoviesInPage(ev.movieId);
        emit(MovieLoaded(movieList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

class SearchBloc extends Bloc<MovieEvent, MovieState> {
  SearchBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final service = ApiService();
      emit(MovieLoading());
      try {
        List<Movie> movieList = await service.getSearchedMovies(ev.query);
        emit(MovieLoaded(movieList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

class WatchlistBloc extends Bloc<MovieEvent, MovieState> {
  WatchlistBloc() : super(MovieLoading()) {
    on<MovieStarted>((ev, emit) async {
      final watchlistRepo = WatchlistRepository();
      emit(MovieLoading());
      try {
        List<Movie> watchlist = await watchlistRepo.getWatchlist();
        emit(MovieLoaded(watchlist));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(MovieError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}

Future<void> addWatchlistMovie(ev, emit) async {
  final watchlistRepo = WatchlistRepository();
  try {
    await watchlistRepo.addToWL(ev.movie);
    List<Movie> watchlist = await watchlistRepo.getWatchlist();
    emit(MovieLoaded(watchlist));
    // ignore: unused_catch_clause
  } on Exception catch (e) {
    emit(MovieError());
  }
}

Future<void> removeWatchlistMovie(ev, emit) async {
  final watchlistRepo = WatchlistRepository();
  try {
    await watchlistRepo.removeFromWL(ev.movie);
    List<Movie> watchlist = await watchlistRepo.getWatchlist();
    emit(MovieLoaded(watchlist));
    // ignore: unused_catch_clause
  } on Exception catch (e) {
    emit(MovieError());
  }
}
