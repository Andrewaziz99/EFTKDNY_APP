import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:eftkdny/modules/Auth/login_screen.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toastification/toastification.dart';

import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  var imagePath = '';
  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      builder: (BuildContext context, state) {
        final cubit = AuthCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 5,
            backgroundColor: Colors.transparent,
            title: Text(
              appName,
            ),
          ),
          backgroundColor: Colors.blue,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register Title
                  Center(
                    child: const Text(
                      register,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // BlurryContainer
                  BlurryContainer(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.5,
                    elevation: 5.0,
                    color: Colors.white24,
                    blur: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  cubit.pickImage();
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      isImageSelected && imagePath.isNotEmpty
                                          ? FileImage(File(imagePath))
                                          : null,
                                  radius: 50.0,
                                  backgroundColor: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (isImageSelected == false)
                                        Icon(
                                          Icons.person,
                                          size: 50.0,
                                          color: Colors.blue,
                                        ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (isImageSelected == false)
                                        Text(selectImage),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Name Field
                            defaultFormField(
                              textColor: Colors.white,
                              controller: nameController,
                              type: TextInputType.text,
                              label: name,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return emptyName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Phone Field
                            defaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              label: phone,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return emptyPhone;
                                } else if (phoneController.text.length < 11) {
                                  return phoneValidation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Address Field
                            defaultFormField(
                              controller: addressController,
                              type: TextInputType.text,
                              label: address,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return emptyAddress;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Email Field
                            defaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              label: email,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return emptyEmail;
                                } else if (!RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return emailValidation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Password Field
                            defaultFormField(
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                isPassword: cubit.isPassword,
                                label: password,
                                suffix: cubit.suffix,
                                suffixPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return passwordValidation;
                                  } else if (value.length < 6) {
                                    return passwordValidation;
                                  }
                                  return null;
                                },
                                ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            // Class Field
                            CustomDropDownMenu(
                              title: selectClass,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                              controller: classController,
                              screenWidth: MediaQuery.of(context).size.width,
                              screenRatio: MediaQuery.of(context).devicePixelRatio,
                              entries: [
                                for (var item in classItems)
                                  DropdownMenuEntry(value: item, label: item)
                              ],
                              onSelected: (val) {},
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // Login Button
                            defaultButton(
                              background: Colors.blue,
                              radius: 10.0,
                              fSize: 20.0,
                              function: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      image: imagePath,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      address: addressController.text,
                                      className: classController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: register,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {
        final cubit = AuthCubit.get(context);

        if (state is AuthPickImageLoadingState) {
          showDialog(
              context: context, builder: (context) => loadingDialog(context));
        }
        if (state is AuthPickImageSuccessState) {
          imagePath = cubit.image;
          isImageSelected = true;
          Navigator.pop(context);
          QuickAlert.show(
              context: context,
              title: imageSelected,
              type: QuickAlertType.success);
        }
        if (state is AuthPickImageErrorState) {
          Navigator.pop(context);
          QuickAlert.show(
              context: context,
              title: imageNotSelected,
              type: QuickAlertType.error);
        }

        if (state is AuthLoadingState) {
          showDialog(
              context: context,
              builder: (buildContext) => loadingDialog(context));
        }
        if (state is AuthSuccessState) {
          // imagePath = '';
          // nameController.clear();
          // phoneController.clear();
          // addressController.clear();
          // classController.clear();
          // emailController.clear();
          // passwordController.clear();
          // Navigator.pop(context);
          // navigateAndFinish(context, LoginScreen());
        }
        if (state is AuthErrorState) {
          Navigator.pop(context);
          QuickAlert.show(
              context: context, title: error, type: QuickAlertType.error);
        }

        // if (state is AuthRegisterLoadingState) {
        //   showDialog(
        //       context: context,
        //       builder: (buildContext) => loadingDialog(context));
        // }
        //
        if (state is AuthRegisterSuccessState) {
          imagePath = '';
          nameController.clear();
          phoneController.clear();
          addressController.clear();
          classController.clear();
          emailController.clear();
          passwordController.clear();
          Navigator.pop(context);
          navigateAndFinish(context, LoginScreen());
          Toastification().show(
            context: context,
            style: ToastificationStyle.fillColored,
            backgroundColor: Colors.green,
            title: Text(registerSuccess),
            applyBlurEffect: true
          );
        }

      },
    );
  }
}
