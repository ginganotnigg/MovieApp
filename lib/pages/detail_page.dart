import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/detail_bloc/detail_bloc.dart';
import 'package:movie_app/bloc/detail_bloc/detail_event.dart';
import 'package:movie_app/bloc/detail_bloc/detail_state.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/pages/main_page.dart';
import 'package:movie_app/util/full_screen_image.dart';
import 'package:movie_app/util/movie_view.dart';
import 'package:url_launcher/url_launcher.dart';

double? width;
double? height;

class DetailPage extends StatelessWidget {
  final Movie movie;
  const DetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider<DetailBloc>(
            create: (_) {
              DetailBloc detailBloc = DetailBloc();
              detailBloc.add(DetailStarted(movie.id));
              return detailBloc;
            },
          )
        ],
        child: WillPopScope(
            onWillPop: () async => true,
            child: Scaffold(
                body: _buildDetail(context),
                appBar: AppBar(
                  title: Text(
                    movie.title.toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF80DEEA),
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  foregroundColor: const Color(0xFF80DEEA),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ))));
  }

  Widget boxContent(context, detail) {
    int hour = detail.runtime ~/ 60;
    int minute = detail.runtime % 60;
    double size = (25 - 4 * detail.title.length ~/ 25).toDouble();
    List<dynamic> genres = detail.genres;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          detail.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.cyan.shade600,
              fontWeight: FontWeight.w700,
              fontSize: size),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, color: Colors.cyan.shade600),
            const SizedBox(width: 5),
            SizedBox(
              height: 25,
              child: (genres.isNotEmpty)
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(
                                        defaultGenre: genres[index]['id'])));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.cyan,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                genres[index]['name'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: (genres.length < 4) ? genres.length : 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 3),
                    )
                  : Text(
                      'Other'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(width: 30),
            Icon(Icons.star, color: Colors.cyan.shade600),
            const SizedBox(width: 5),
            Text(
              detail.voteAverage.toStringAsFixed(1),
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
            const SizedBox(width: 50),
            Icon(Icons.timer_rounded, color: Colors.cyan.shade600),
            const SizedBox(width: 5),
            Text(
              '${hour}h${minute}m',
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
            const Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: BlocBuilder<WatchlistBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return loadingWidget();
                    } else if (state is MovieLoaded) {
                      return bookmarkIcon(
                          context, movie, context.read<WatchlistBloc>());
                    } else {
                      return errorWidget();
                    }
                  },
                ))
          ],
        ),
      ],
    );
  }

  Widget titleBox(context, detail) {
    return Padding(
      padding: EdgeInsets.only(top: height! * 0.3, left: width! * 0.06),
      child: Container(
        width: width! * 0.88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(32)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withAlpha(224),
                Colors.white.withAlpha(204),
                Colors.cyan.shade200.withAlpha(102),
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Center(child: boxContent(context, detail)))
          ],
        ),
      ),
    );
  }

  Widget clickableImageSlider(context, images) {
    return SizedBox(
      height: height! * 0.2,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final path = images[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                              imageUrl: (path != 'null')
                                  ? 'https://image.tmdb.org/t/p/w500$path'
                                  : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
                            )));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                    placeholder: (context, url) => loadingWidget(),
                    imageUrl: (path != 'null')
                        ? 'https://image.tmdb.org/t/p/w500$path'
                        : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
                    fit: BoxFit.cover),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemCount: images!.length),
    );
  }

  Widget clickableCastSlider(context, casts) {
    return SizedBox(
      height: height! * 0.21,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final path = casts[index].profilePath;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                  imageUrl: (path != 'null')
                                      ? 'https://image.tmdb.org/t/p/w500$path'
                                      : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
                                )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                        height: height! * 0.15,
                        width: height! * 0.1,
                        placeholder: (context, url) => loadingWidget(),
                        imageUrl: (path != 'null')
                            ? 'https://image.tmdb.org/t/p/w500$path'
                            : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: height! * 0.1,
                  child: Text(
                    casts[index].name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: height! * 0.1,
                  child: Text(
                    casts[index].character,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.cyan.shade600,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemCount: casts!.length),
    );
  }

  Widget _buildDetail(context) {
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (context, state) {
        if (state is DetailLoading) {
          return loadingWidget();
        } else if (state is DetailLoaded) {
          final detail = state.detail;
          final path = detail.backdropPath;
          final trailer = detail.trailerId;
          final images = detail.movieImages;
          final casts = detail.credits;
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Stack(children: [
                      CachedNetworkImage(
                        imageUrl: (path != 'null')
                            ? 'https://image.tmdb.org/t/p/original/$path'
                            : 'https://universitycommercecollege.ac.in/publicimages/thumb/members/400x400/mgps_file_d11584807164.jpg',
                        height: height! * 0.4,
                        width: width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => loadingWidget(),
                      ),
                      (trailer != 'null')
                          ? SizedBox(
                              height: height! / 5 * 2,
                              width: width,
                              child: GestureDetector(
                                onTap: () async {
                                  final youtubeUrl =
                                      'https://www.youtube.com/embed/$trailer';
                                  if (await canLaunchUrl(
                                      Uri.parse(youtubeUrl))) {
                                    await launchUrl(Uri.parse(youtubeUrl));
                                  }
                                },
                                child: const Center(
                                  child: Icon(Icons.play_circle_outline_sharp,
                                      color: Colors.white,
                                      size: 60,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          offset: Offset(2, 2),
                                          spreadRadius: 4,
                                          blurRadius: 4,
                                        )
                                      ]),
                                ),
                              ))
                          : Container()
                    ]),
                  ),
                  titleBox(context, detail)
                ]),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          detail.overview,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Images'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        clickableImageSlider(context, images),
                        const SizedBox(height: 15),
                        Text(
                          'Casts'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        clickableCastSlider(context, casts)
                      ],
                    )),
              ],
            ),
          );
        } else {
          return errorWidget();
        }
      },
    );
  }
}
