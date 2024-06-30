import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/detail_bloc/detail_event.dart';
import 'package:movie_app/bloc/detail_bloc/detail_state.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/model/detail.dart';
import 'package:movie_app/service/api_service.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailLoading()) {
    on<DetailStarted>((ev, emit) async {
      final service = ApiService();
      emit(DetailLoading());
      try {
        MovieDetail detail = await service.getMovieDetail(ev.id.toString());
        emit(DetailLoaded(detail));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(DetailError());
      }
    });
    on<WatchlistMovieAdd>(addWatchlistMovie);
    on<WatchlistMovieRemove>(removeWatchlistMovie);
  }
}
