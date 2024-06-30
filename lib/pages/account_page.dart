import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:movie_app/bloc/auth_bloc/auth_event.dart';
import 'package:movie_app/bloc/auth_bloc/auth_state.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/auth_page.dart';
import 'package:movie_app/util/movie_view.dart';

double? width;
double? height;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(const MovieStarted(0, ''));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        _buildProfile(context),
        _buildWatchlist(context),
      ],
    ));
  }

  Widget accountImage(context, user, double? height, double? width) {
    return user.photoURL != null
        ? CachedNetworkImage(
            imageUrl: user.photoURL.toString(),
            height: height!,
            width: width!,
            fit: BoxFit.cover,
            placeholder: (context, url) => loadingWidget(),
          )
        : Container(
            height: height,
            width: width,
            color: Colors.cyan.shade100,
          );
  }

  Widget _buildProfile(context) {
    final user = FirebaseAuth.instance.currentUser!;
    return BlocListener<AuthBloc, AuthState>(
      listener: ((context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthRoutePage()),
              (route) => false);
        }
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              accountImage(context, user, height! * 0.2, width),
              SizedBox(
                height: height! * 0.2,
                width: width,
                child: ClipRect(
                    child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.black26,
                  ),
                )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 3)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: accountImage(context, user, 100, 100)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      '${user.email}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan.shade600)),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Log out')),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10, left: 10),
            child: Text(
              'Watchlist'.toUpperCase(),
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlist(context) {
    return BlocBuilder<WatchlistBloc, MovieState>(builder: (context, state) {
      if (state is MovieLoading) {
        return loadingWidget();
      } else if (state is MovieLoaded) {
        List<Movie> movies = state.movieList;
        return (movies.isNotEmpty)
            ? Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: (movies.length > 10)
                        ? movieGridScroll(
                            context, movies, context.read<WatchlistBloc>(),
                            remove: true)
                        : movieVertiScroll(
                            context, movies, context.read<WatchlistBloc>(),
                            remove: true)),
              )
            : Center(
                child: Text(
                  'No movies yet'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              );
      } else {
        return errorWidget();
      }
    });
  }
}
