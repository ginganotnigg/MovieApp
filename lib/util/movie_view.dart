import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/detail_page.dart';

Widget loadingWidget() {
  return Center(
    child: Platform.isAndroid
        ? const CircularProgressIndicator()
        : const CupertinoActivityIndicator(),
  );
}

Widget errorWidget() {
  return Column(
    children: [
      Image.asset('lib/assets/images/error_sth_wrong.jpeg'),
      const Text(
        'Oops! Something went wrong',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      )
    ],
  );
}

Widget movieSlider(BuildContext context, List<Movie> movies) {
  return Container(
    color: const Color.fromARGB(153, 21, 69, 78),
    child: CarouselSlider.builder(
      itemCount: movies.length,
      itemBuilder: (context, index, _) {
        final path = movies[index].backdropPath;
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(movie: movies[index])));
          },
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(alignment: Alignment.bottomLeft, children: [
                CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/original/$path',
                  height: MediaQuery.of(context).size.height / 7 * 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => loadingWidget(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color.fromARGB(4, 0, 0, 0),
                        Colors.black45
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      movies[index].title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ]),
        );
      },
      options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 1.6,
          autoPlayInterval: const Duration(seconds: 3)),
    ),
  );
}

void addWatchlistBloc(context, movie, bloc) {
  bloc.add(WatchlistMovieAdd(movie));
  bloc.add(const MovieStarted(0, ''));
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add "${movie.title}" to Watchlist')));
}

void removeWatchlistBloc(context, movie, bloc) {
  bloc.add(WatchlistMovieRemove(movie));
  bloc.add(const MovieStarted(0, ''));
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remove "${movie.title}" from Watchlist')));
}

Widget bookmarkIcon(context, movie, bloc, {bool remove = false}) {
  return GestureDetector(
    onTap: () {
      remove
          ? removeWatchlistBloc(context, movie, bloc)
          : addWatchlistBloc(context, movie, bloc);
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        color: Colors.black.withAlpha(64),
        padding: const EdgeInsets.all(5),
        child: remove
            ? Icon(Icons.bookmark_remove, color: Colors.cyan.shade200)
            : Icon(Icons.bookmark_add, color: Colors.cyan.shade200),
      ),
    ),
  );
}

Widget movieImage(context, movie, width, height, bloc, {bool remove = false}) {
  String path;
  if (width > height) {
    path = movie.backdropPath;
  } else {
    path = movie.posterPath;
  }
  return ClipRRect(
    child: Stack(alignment: Alignment.topRight, children: [
      CachedNetworkImage(
        imageUrl: (path != 'null')
            ? 'https://image.tmdb.org/t/p/original/$path'
            : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
        imageBuilder: (context, imageProvider) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          );
        },
        placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: loadingWidget(),
        ),
      ),
      bookmarkIcon(context, movie, bloc, remove: remove)
    ]),
  );
}

Widget movieDesc(context, movie, width) {
  return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onLongPress: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(movie.title)));
            },
            child: Text(
              movie.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.cyan,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie.releaseDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              (movie.releaseDate != '')
                  ? const SizedBox(width: 50)
                  : const SizedBox(width: 0),
              Icon(Icons.star, size: 18, color: Colors.cyan.shade600),
              const SizedBox(width: 5),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
            ],
          )
        ],
      ));
}

Widget movieGridScroll(context, movies, bloc, {bool remove = false}) {
  return Center(
    child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10),
        itemBuilder: ((context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(movie: movies[index])));
                  },
                  child: movieImage(context, movies[index], 200.0, 130.0, bloc,
                      remove: remove)),
              const SizedBox(height: 10),
              movieDesc(context, movies[index], 200.0)
            ],
          );
        }),
        itemCount: movies.length),
  );
}

Widget movieHorizScroll(context, movies, bloc) {
  return SizedBox(
      height: 300,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: ((context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(movie: movies[index])));
                    },
                    child:
                        movieImage(context, movies[index], 200.0, 250.0, bloc)),
                const SizedBox(height: 10),
                movieDesc(context, movies[index], 200.0)
              ],
            );
          }),
          itemCount: movies.length));
}

Widget movieVertiScroll(context, movies, bloc, {bool remove = false}) {
  return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(movie: movies[index])));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.cyan.shade100,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                movieImage(
                    context,
                    movies[index],
                    MediaQuery.of(context).size.height * 0.17,
                    MediaQuery.of(context).size.height * 0.1,
                    bloc,
                    remove: remove),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          movieDesc(context, movies[index],
                              MediaQuery.of(context).size.width * 0.52),
                          const SizedBox(height: 13),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              movies[index].overview,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        );
      }),
      itemCount: movies.length);
}
