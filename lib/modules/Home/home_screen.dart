import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eftkdny/models/Children/children_model.dart';
import 'package:eftkdny/modules/Home/Answers/answers_screen.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:eftkdny/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../Questions/question_screen.dart';
import 'child_dialog_page.dart';
import 'cubit/cubit.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController childNameController = TextEditingController();

  ChildrenModel? childData;
  User? user = FirebaseAuth.instance.currentUser;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {
        final cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            onRefresh: () async {
              childData = null;
              childNameController.clear();
              cubit.childrenList!.clear();
              cubit.getUserData();
              print(user!.emailVerified);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.fill,
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ConditionalBuilder(
                      condition: state is! getUserDataLoadingState,
                      builder: (BuildContext context) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!user!.emailVerified) emailVerificationWarning(context),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomDropDownMenu(
                              showTitle: false,
                              controller: childNameController,
                              screenWidth: MediaQuery.of(context).size.width,
                              screenRatio:
                                  MediaQuery.of(context).devicePixelRatio,
                              entries: [
                                for (var item in cubit.childrenList!)
                                  DropdownMenuEntry(
                                      value: item, label: item.name!),
                              ],
                              onSelected: (value) {
                                cubit.changeChildData(value);
                                childData = value;
                                childNameController.text = childData!.name!;
                                cubit.getAnswers(value.childId!);
                              }),
                          SizedBox(
                            height: 20.0,
                          ),
                          ConditionalBuilder(
                            condition: state is changeChildDataState ||
                                childData != null,
                            builder: (BuildContext context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    childData!.name ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        childData!.image ?? ''),
                                    radius: 30.0,
                                    backgroundColor: Colors.white,
                                    child: childData!.image != null
                                        ? null
                                        : Icon(
                                            Icons.person,
                                            size: 50.0,
                                            color: Colors.blue,
                                          ),
                                  ),
                                  subtitle: Text(
                                    childData!.birthDate ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (buildContext) =>
                                            childDialog(context, childData));
                                  },
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                defaultButton(
                                    function: () {
                                      String childId = childData!.childId!;
                                      navigateTo(context,
                                          QuestionScreen(childId: childId));
                                    },
                                    text: startVisit,
                                    width: double.infinity,
                                    background: Colors.blueAccent,
                                    radius: 10.0,
                                    fSize: 20.0),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  headLine1,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: ConditionalBuilder(
                                    condition: cubit.answersList.isNotEmpty,
                                    builder: (BuildContext context) {
                                      return ListView.separated(
                                        itemCount: cubit.answersList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              historyItem(
                                                  context, cubit, index),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (BuildContext context,
                                                int index) =>
                                            myDivider(color: Colors.black87),
                                      );
                                    },
                                    fallback: (BuildContext context) => Center(
                                      child: Text(
                                        noData,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            fallback: (BuildContext context) =>
                                Center(child: Text(noData)),
                          ),
                        ],
                      ),
                      fallback: (BuildContext context) {
                        return loadingDialog(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {},
    );
  }
}

Widget historyItem(Context, HomeCubit cubit, int index) => BlurryContainer(
      color: Colors.white60,
      child: ListTile(
        onTap: () {
          navigateTo(Context, AnswersScreen(answers: cubit.answersList[index]));
        },
        leading: Text('${index + 1}'),
        title: Text(
          DateFormat('EEEE, d MMMM yyyy', 'ar').format(
            cubit.answersList[index].date!,
          ),
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: Transform.rotate(
            angle: pi, child: Icon(Icons.arrow_back_ios_rounded)),
      ),
    );

Widget emailVerificationWarning(context) => Container(
      color: Colors.amber.shade100,
      width: double.infinity,
      height: 50.0,
      child: ListTile(
        onTap: () async {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && !user.emailVerified) {
            await user.sendEmailVerification();
            Toastification().show(
              autoCloseDuration: Duration(seconds: 2),
              context: context,
              backgroundColor: Colors.amber,
              icon: Icon(Icons.warning_amber, color: Colors.black,),
              description: Text('Email sent'),
              alignment: Alignment.bottomCenter,
              animationDuration: Duration(seconds: 2),
              dragToClose: true
            );
          }
        },
        leading: Icon(Icons.email_outlined),
        title: Text(
          emailVerification,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        trailing: Transform.rotate(
            angle: pi, child: Icon(Icons.arrow_back_ios_rounded)),
      ),
    );
