import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Auth/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/User/user_model.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;

  IconData confirmSuffix = Icons.visibility_outlined;
  bool isPassword = true;
  bool isConfirmPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AuthChangePasswordVisibilityState());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    confirmSuffix = isConfirmPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(AuthChangePasswordVisibilityState());
  }

  var image = '';

  Future<void> pickImage() async {
    emit(AuthPickImageLoadingState());
    // Implement image picking logic here
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      image = imageFile.path;
      print(image);
      emit(AuthPickImageSuccessState());
    } else {
      emit(AuthPickImageErrorState('No image selected'));
      return;
    }
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AuthLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(AuthSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(AuthErrorState(error.toString()));
    });
  }

  void resetPassword({
    required String email,
  }) {
    emit(AuthResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(AuthResetPasswordSuccessState());
    }).catchError((error) {
      emit(AuthResetPasswordErrorState(error.toString()));
    });
  }

  UserModel? userModel;

  Future<void> createUser({
    required String uId,
    String? imagePath, // Make imagePath optional
    required String name,
    required String phone,
    required String address,
    required String className,
    required String email,
  }) async {
    emit(AuthRegisterLoadingState());

    String? imageUrl;
    try {
      // Check if imagePath is provided and not empty
      if (imagePath != null && imagePath.isNotEmpty) {
        // Upload the image to Firebase Storage
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('users_images')
            .child('$name.jpg');

        final UploadTask uploadTask = storageReference.putFile(File(imagePath));
        final TaskSnapshot storageSnapshot = await uploadTask;
        imageUrl = await storageSnapshot.ref.getDownloadURL();
      }

      UserModel model = UserModel(
        uId: uId,
        image: imageUrl,
        name: name,
        phone: phone,
        address: address,
        className: className,
        email: email,
      );

      // Save the user model to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap());

      emit(AuthRegisterSuccessState());
    } catch (error) {
      emit(AuthRegisterErrorState(error.toString()));
    }
  }

  void userRegister({
    required String image,
    required String name,
    required String phone,
    required String address,
    required String className,
    required String email,
    required String password,
  }) {
    emit(AuthLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      // Send verification email
      value.user?.sendEmailVerification();
      String userId = value.user!.uid;
      createUser(
              uId: value.user!.uid,
              imagePath: image,
              name: name,
              phone: phone,
              address: address,
              className: className,
              email: email)
          .then((value) {
        if (state is AuthRegisterSuccessState) {
          emit(AuthSuccessState(userId));
        } else {
          emit(AuthErrorState('Failed to create user'));
        }
      });
    }).catchError((error) {
      emit(AuthErrorState(error.toString()));
    });
  }
}
