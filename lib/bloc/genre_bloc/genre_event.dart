import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  get genreId => null;
}

class GenreStarted extends GenreEvent {
  @override
  final int genreId;
  final String query;

  const GenreStarted(this.genreId, this.query);

  @override
  List<Object> get props => [];
}
