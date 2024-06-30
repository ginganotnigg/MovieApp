import 'package:movie_app/pages/more_page.dart';
import 'package:movie_app/util/movie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/model/movie.dart';

double? width;
double? height;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) {
            MovieBloc movieBloc = MovieBloc();
            movieBloc.add(const MovieStarted(0, ''));
            return movieBloc;
          },
        ),
        BlocProvider<TopRatedBloc>(
          create: (_) {
            TopRatedBloc topRatedBloc = TopRatedBloc();
            topRatedBloc.add(const MovieStarted(0, 'top_rated'));
            return topRatedBloc;
          },
        ),
        BlocProvider<UpcomingBloc>(
          create: (_) {
            UpcomingBloc upcomingBloc = UpcomingBloc();
            upcomingBloc.add(const MovieStarted(0, 'upcoming'));
            return upcomingBloc;
          },
        ),
        BlocProvider<WatchlistBloc>(
          create: (_) {
            WatchlistBloc watchlistBloc = WatchlistBloc();
            watchlistBloc.add(const MovieStarted(0, ''));
            return watchlistBloc;
          },
        )
      ],
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return loadingWidget();
                } else if (state is MovieLoaded) {
                  List<Movie> movies = state.movieList;
                  return Column(children: [
                    Container(
                      color: const Color.fromARGB(153, 21, 69, 78),
                      height: 12,
                    ),
                    movieSlider(context, movies),
                    Container(
                      color: const Color.fromARGB(153, 21, 69, 78),
                      height: 12,
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MorePage()));
                      },
                      child: Container(
                        height: 40,
                        width: width! * 0.9,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyan, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                            child: Text(
                          'View more  \u276d',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: Colors.black54,
                    ),
                  ]);
                } else {
                  return errorWidget();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Top rated'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            BlocBuilder<TopRatedBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return loadingWidget();
                } else if (state is MovieLoaded) {
                  List<Movie> movies = state.movieList;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: movieHorizScroll(
                        context, movies, context.read<WatchlistBloc>()),
                  );
                } else {
                  return errorWidget();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Upcoming'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            BlocBuilder<UpcomingBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return loadingWidget();
                } else if (state is MovieLoaded) {
                  List<Movie> movies = state.movieList;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: movieHorizScroll(
                        context, movies, context.read<WatchlistBloc>()),
                  );
                } else {
                  return errorWidget();
                }
              },
            ),
          ],
        ),
      ));
    });
  }
}
