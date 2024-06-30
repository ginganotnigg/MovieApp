import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/model/cast.dart';
import 'package:movie_app/model/detail.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/genre.dart';

class ApiService {
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'd28ad607978f38b07091ea3e31b027a5';

  Future<List<Movie>> getNowPlayingMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Movie>> getSelectedMovies(int genreId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Movie>> getSearchedMovies(String query) async {
    if (query == '') return [];
    final response = await http
        .get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Movie>> getMoviesInPage(int page) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&page=$page'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'] as List;
      List<Movie> movieList = data.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Genre>> getGenreList() async {
    final response =
        await http.get(Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];
      List<Genre> genreList = data.map((m) => Genre.fromJson(m)).toList();
      return genreList;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<MovieDetail> getMovieDetail(String movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      MovieDetail detail = MovieDetail.fromJson(data);
      detail.trailerId = await getYoutubeId(movieId);
      detail.movieImages = await getImagesUrl(movieId);
      detail.credits = await getCastList(movieId);
      return detail;
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<String> getYoutubeId(String movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (data.isEmpty) return 'null';
      return data[0]['key'];
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<String>> getImagesUrl(String movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/images?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data1 = json.decode(response.body)['backdrops'];
      List<String> backdrops =
          data1.map((m) => m['file_path'].toString()).toList();
      final String poster =
          json.decode(response.body)['posters'][0]['file_path'];
      return (backdrops..add(poster));
    } else {
      throw Exception('Failed to load movies data');
    }
  }

  Future<List<Cast>> getCastList(String movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['cast'] as List;
      List<Cast> casts = data.map((m) => Cast.fromJson(m)).toList();
      return casts;
    } else {
      throw Exception('Failed to load movies data');
    }
  }
}
