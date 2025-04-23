import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:eftkdny/layout/main_layout.dart';
import 'package:eftkdny/modules/Auth/register_screen.dart';
import 'package:eftkdny/modules/Home/home_screen.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';

import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});


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
            title: Text(appName,),
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
                  // Login Title
                  Center(
                    child: const Text(
                      login,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
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
                              suffixPressed: (){
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
                              onSubmit: (value) {
                                if (_formKey.currentState!.validate()) {
                                  cubit.userLogin(email: emailController.text, password: passwordController.text);
                                }
                              }
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          // Login Button
                          defaultButton(
                            background: Colors.blue,
                            radius: 10.0,
                            fSize: 20.0,
                            function: () {
                              if (_formKey.currentState!.validate()) {
                                cubit.userLogin(email: emailController.text, password: passwordController.text);
                              }
                            },
                            text: login,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          // Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                forgotPassword,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (buildContext) => resetPasswordDialog(context, emailController, cubit));
                                  },
                                  child: const Text(
                                    reset,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          // Don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                dontHaveAccount,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: const Text(
                                  register,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
        if (state is AuthLoadingState) {
          showDialog(context: context, builder: (buildContext) => loadingDialog(context));
        }
        if (state is AuthSuccessState) {
          emailController.clear();
          passwordController.clear();
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            navigateAndFinish(context, MainLayout());
          });
        }
        if (state is AuthErrorState) {
          Navigator.pop(context);
          QuickAlert.show(
              context: context,
              title: error,
              type: QuickAlertType.error);
        }
      },
    );
  }
}

final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
Widget resetPasswordDialog(BuildContext context, TextEditingController emailController, cubit) => Center(
  child: AlertDialog(
    title: Text(reset, style: TextStyle(color: Colors.blue),),
    content: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      child: Form(
        key: _resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            defaultFormField(
              textColor: Colors.black,
              labelColor: Colors.black,
              controller: emailController,
              type: TextInputType.emailAddress,
              label: email,
              validate: (value) {
                if (value!.isEmpty) {
                  return emptyEmail;
                } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                  return emailValidation;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(onPressed: (){if (_resetFormKey.currentState!.validate()) {
        cubit.resetPassword(email: emailController.text).then((value) {});

      }  }, child: Text(send, style: TextStyle(color: Colors.blue),)),
      SizedBox(width: 10.0,),
      TextButton(onPressed: (){Navigator.pop(context);}, child: Text(exit)),
    ],
  ),
);