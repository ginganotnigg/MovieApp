import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/service/auth_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => AuthRepository(),
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>()),
              ),
              BlocProvider<WatchlistBloc>(
                create: (context) =>
                    WatchlistBloc()..add(const MovieStarted(0, '')),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'Muli'),
              home: const AuthRoutePage(),
            )));
  }
}
