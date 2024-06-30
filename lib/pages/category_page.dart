import 'package:movie_app/util/movie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/genre_bloc/genre_bloc.dart';
import 'package:movie_app/bloc/genre_bloc/genre_event.dart';
import 'package:movie_app/bloc/genre_bloc/genre_state.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/model/movie.dart';

double? width;
double? height;

class CategoryPage extends StatefulWidget {
  final int? genreId;
  const CategoryPage({Key? key, this.genreId}) : super(key: key);

  @override
  State<CategoryPage> createState() => CategoryPageState();
}

final glbGenKey = GlobalKey();

class CategoryPageState extends State<CategoryPage> {
  late int selectedGenre;
  final textController = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    textController.addListener(() {
      if (textController.text.isNotEmpty && isVisible == true) {
        setState(() {
          isVisible = false;
        });
      } else if (textController.text.isEmpty && isVisible == false) {
        setState(() {
          isVisible = true;
        });
      }
    });
    super.initState();
    selectedGenre = widget.genreId ?? 28;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) {
            GenreBloc genreBloc = GenreBloc();
            genreBloc.add(const GenreStarted(0, ''));
            return genreBloc;
          },
        ),
        BlocProvider<MovieBloc>(create: (_) {
          MovieBloc movieBloc = MovieBloc();
          movieBloc.add(MovieStarted(selectedGenre, ''));
          return movieBloc;
        }),
        BlocProvider<SearchBloc>(
          create: (_) {
            SearchBloc searchBloc = SearchBloc();
            searchBloc.add(const MovieStarted(0, ''));
            return searchBloc;
          },
        )
      ],
      child: _buildBody(context),
    );
  }

  Widget genreTabs(context, genres) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedGenre = genres[index].id;
                  context
                      .read<MovieBloc>()
                      .add(MovieStarted(selectedGenre, ''));
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF80DEEA), width: 1),
                  borderRadius: BorderRadius.circular(25),
                  color: (genres[index].id == selectedGenre)
                      ? const Color(0xFF80DEEA)
                      : Colors.white,
                ),
                child: Center(
                  child: Text(
                    genres[index].name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: (genres[index].id == selectedGenre)
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
      itemCount: genres.length,
      separatorBuilder: (context, index) => const SizedBox(width: 5),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: isVisible ? null : 0,
              child: Column(
                children: [
                  BlocBuilder<GenreBloc, GenreState>(builder: (context, state) {
                    if (state is GenreLoading) {
                      return loadingWidget();
                    } else if (state is GenreLoaded) {
                      List<Genre> genres = state.genreList;
                      return SizedBox(
                          height: 35, child: genreTabs(context, genres));
                    } else {
                      return errorWidget();
                    }
                  }),
                  const SizedBox(height: 10),
                  BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                    if (state is MovieLoading) {
                      return loadingWidget();
                    } else if (state is MovieLoaded) {
                      List<Movie> movies = state.movieList;
                      return movieHorizScroll(
                          context, movies, context.read<WatchlistBloc>());
                    } else {
                      return errorWidget();
                    }
                  }),
                  const Divider(
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<SearchBloc, MovieState>(
            builder: (context, state) {
              return Center(
                child: Container(
                  width: width! * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.cyan)),
                  child: TextFormField(
                    controller: textController,
                    onChanged: (query) {
                      context.read<SearchBloc>().add(MovieStarted(0, query));
                    },
                    style: const TextStyle(color: Colors.black54),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          textController.text = '';
                          context
                              .read<SearchBloc>()
                              .add(const MovieStarted(0, ''));
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.cyan,
                        ),
                      ),
                      hintText: 'Type title, actor, etc.',
                      hintStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<SearchBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return loadingWidget();
              } else if (state is MovieLoaded) {
                final movies = state.movieList;
                return (movies.isEmpty)
                    ? Center(
                        child: Text(
                          'No results'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : Expanded(
                        child: movieVertiScroll(
                            context, movies, context.read<WatchlistBloc>()));
              } else {
                return errorWidget();
              }
            },
          ),
        ],
      ),
    );
  }
}
