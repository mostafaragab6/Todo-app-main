import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/helpers/shared_pref_helpers.dart';
import 'package:todo_app/core/networking/dio_factory.dart';
import 'package:todo_app/features/login/data/models/login_request.dart';
import 'package:todo_app/features/login/data/repos/login_repo.dart';
import 'package:todo_app/features/login/logic/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void firebaseLogin() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      login();
    } catch (error) {
      emit(LoginState.error(error.toString()));
    }
  }

  DocumentSnapshot? phoneNumber;
  void login() async {
    phoneNumber =
        await _firestore.collection('users').doc(emailController.text).get();

    emit(const LoginState.loading());
    final response = await _loginRepo.login(LoginRequest(
      password: passController.text,
      phone: '+20${phoneNumber?['phone']}',
    ));

    response.when(
      success: (data) {
        DioFactory.setTokenIntoHeaderAfterLogin(data.accessToken!);
        SharedPrefHelper.setSecuredString('access_token', data.accessToken!);
        SharedPrefHelper.setSecuredString('refresh_token', data.refreshToken!);

        emit(LoginState.success(data));
      },
      failure: (error) async {
        await _auth.signOut();
        emit(LoginState.error(error));
      },
    );
  }
}
