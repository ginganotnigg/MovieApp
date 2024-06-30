import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/util/movie_view.dart';
import 'package:number_paginator/number_paginator.dart';

double? width;
double? height;

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  int _currentPage = 1;
  bool gridView = true;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider<PopularBloc>(
            create: (_) {
              PopularBloc popularBloc = PopularBloc();
              popularBloc.add(const MovieStarted(1, ''));
              return popularBloc;
            },
          )
        ],
        child: WillPopScope(
            onWillPop: () async => true,
            child: Scaffold(
                body: _buildBody(context),
                appBar: AppBar(
                  title: Text(
                    'Page $_currentPage/1000'.toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF80DEEA),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            gridView = !gridView;
                          });
                        },
                        icon: Icon(
                            (gridView) ? Icons.grid_view : Icons.list_sharp))
                  ],
                  foregroundColor: const Color(0xFF80DEEA),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ))));
  }

  Widget _buildBody(context) {
    return Column(
      children: [
        BlocBuilder<PopularBloc, MovieState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              width: width! * 0.4,
              child: Card(
                color: Colors.cyan.shade100.withAlpha(64),
                margin: const EdgeInsets.only(bottom: 5),
                elevation: 0,
                child: NumberPaginator(
                  numberPages: 1000,
                  onPageChange: (index) {
                    setState(() {
                      _currentPage = index + 1;
                      context
                          .read<PopularBloc>()
                          .add(MovieStarted(_currentPage, ''));
                    });
                  },
                  config: NumberPaginatorUIConfig(
                    height: 44,
                    mode: ContentDisplayMode.dropdown,
                    buttonSelectedBackgroundColor: Colors.cyan.shade600,
                    buttonUnselectedForegroundColor: Colors.black54,
                    buttonSelectedForegroundColor: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        BlocBuilder<PopularBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return loadingWidget();
            } else if (state is MovieLoaded) {
              final movies = state.movieList;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: (gridView)
                      ? movieGridScroll(
                          context, movies, context.read<WatchlistBloc>())
                      : movieVertiScroll(
                          context, movies, context.read<WatchlistBloc>()),
                ),
              );
            } else {
              return errorWidget();
            }
          },
        ),
      ],
    );
  }
}
