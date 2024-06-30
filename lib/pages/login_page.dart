import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:movie_app/bloc/auth_bloc/auth_event.dart';
import 'package:movie_app/bloc/auth_bloc/auth_state.dart';
import 'package:movie_app/pages/main_page.dart';
import 'package:movie_app/util/movie_view.dart';

double? width;
double? height;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('lib/assets/images/movie.json'),
            const SizedBox(height: 10),
            Text('MovAIO',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.cyan.shade600)),
            const SizedBox(height: 10),
            const Text(
                'Sign in to access and save your personal movie and show collection on MovAIO. Start your journey through the world of film and television today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
            const SizedBox(height: 40),
            BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
              if (state is Authenticated) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainPage()));
              } else if (state is AuthError) {
                // Displaying the error message if the user is not authenticated
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            }), builder: ((context, state) {
              if (state is Loading) {
                return loadingWidget();
              } else if (state is Unauthenticated) {
                return GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(GoogleSignInRequested());
                  },
                  child: Container(
                    height: 40,
                    width: width! * 0.8,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                            'http://pngimg.com/uploads/google/google_PNG19635.png',
                            fit: BoxFit.cover),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text('Sign-in with Google',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87))
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            })),
          ],
        ),
      ),
    );
  }
}
