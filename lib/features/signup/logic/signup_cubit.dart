import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/signup/data/repos/signup_repo.dart';
import 'package:todo_app/features/signup/data/models/signup_request.dart';
import 'package:todo_app/features/signup/logic/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo _signupRepo;
  SignupCubit(this._signupRepo) : super(const SignupState.initial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool isPass = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController yearExpLevelController = TextEditingController();
  TextEditingController expLevelController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  UserCredential? userCredential;

  Future<void> firebaseSignUp() async {
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      signup();
    } catch (error) {
      emit(SignupState.error(error.toString()));
    }
  }

  void signup() async {
    emit(const SignupState.loading());

    final response = await _signupRepo.signup(SignupRequest(
      address: addressController.text,
      displayName: nameController.text,
      experienceYears: int.parse(yearExpLevelController.text),
      level: expLevelController.text,
      password: passController.text,
      phone: '+20${phoneController.text}',
    ));

    response.when(
      success: (data) async {
        await _fireStore.collection('users').doc(emailController.text).set(
          {
            'phone': phoneController.text,
          },
        );
        emit(SignupState.success(data));
      },
      failure: (error) async {
        await userCredential?.user?.delete();
        emit(SignupState.error(error));
      },
    );
  }
}
