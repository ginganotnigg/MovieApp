import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  get id => null;
}

class DetailStarted extends DetailEvent {
  @override
  final int id;

  const DetailStarted(this.id);

  @override
  List<Object> get props => [];
}

class WatchlistMovieAdd extends DetailEvent {
  @override
  final int id;

  const WatchlistMovieAdd(this.id);

  @override
  List<Object> get props => [];
}

class WatchlistMovieRemove extends DetailEvent {
  @override
  final int id;

  const WatchlistMovieRemove(this.id);

  @override
  List<Object> get props => [];
}
