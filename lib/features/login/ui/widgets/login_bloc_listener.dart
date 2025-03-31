import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/features/login/logic/login_cubit.dart';
import 'package:todo_app/features/login/logic/login_state.dart';

import '../../../../core/theming/colors_manager.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(loading: () {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.mainPurpule,
              ),
            ),
          );
        }, success: (data) {
          Navigator.pop(context);

          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.homeScreen,
            (Route<dynamic> route) => false,
          );
          //The supplied auth credential is incorrect, malformed or has expired.
        }, error: (error) {
          if (error.contains('status code of 401')) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('incorrect credentials'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (error.contains(
              'The supplied auth credential is incorrect, malformed or has expired.')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('incorrect credentials'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('incorrect credentials'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        });
      },
      child: const SizedBox.shrink(),
    );
  }
}
