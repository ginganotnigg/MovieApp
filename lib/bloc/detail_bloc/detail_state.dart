import 'package:equatable/equatable.dart';
import 'package:movie_app/model/detail.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final MovieDetail detail;
  const DetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}

class DetailError extends DetailState {}
