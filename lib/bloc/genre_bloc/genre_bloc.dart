import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/genre_bloc/genre_event.dart';
import 'package:movie_app/bloc/genre_bloc/genre_state.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/service/api_service.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading()) {
    on<GenreStarted>((ev, emit) async {
      final service = ApiService();
      emit(GenreLoading());
      try {
        List<Genre> genreList = [];
        if (ev.genreId == 0) {
          genreList = await service.getGenreList();
        }
        emit(GenreLoaded(genreList));
        // ignore: unused_catch_clause
      } on Exception catch (e) {
        emit(GenreError());
      }
    });
  }
}
