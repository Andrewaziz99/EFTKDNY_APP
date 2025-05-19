import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eftkdny/layout/main_layout.dart';
import 'package:eftkdny/modules/Home/home_screen.dart';
import 'package:eftkdny/modules/Questions/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';

class QuestionScreen extends StatelessWidget {
  final String childId;
  const QuestionScreen({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => QuestionsCubit()..getQuestions(),
      child: BlocConsumer<QuestionsCubit, QuestionStates>(
        builder: (BuildContext context, state) {
          final cubit = QuestionsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                appName,
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/pattern.png',
                    fit: BoxFit.fill,
                  ),
                  ConditionalBuilder(
                    condition: state is! QuestionLoadingState,
                    builder: (BuildContext context) {
                      final currentQuestion = cubit.questions[cubit.currentIndex];
                      return Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BlurryContainer(
                                    blur: 5,
                                    color: Colors.blue.withAlpha(76),
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(20),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Column(
                                      children: [
                                        // Question Container
                                        BlurryContainer(
                                          blur: 5,
                                          width: double.infinity,
                                          color: Colors.white.withAlpha(76),
                                          padding: const EdgeInsets.all(16),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Text(
                                            currentQuestion.question!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Options List
                                        Column(
                                          children: [
                                            _buildOption(
                                                context,
                                                'A',
                                                currentQuestion.option1!, 10,
                                                cubit),
                                            const SizedBox(height: 10),
                                            _buildOption(
                                                context,
                                                'B',
                                                currentQuestion.option2!, 8,
                                                cubit),
                                            const SizedBox(height: 10),
                                            _buildOption(
                                                context,
                                                'C',
                                                currentQuestion.option3!, 6,
                                                cubit),
                                            const SizedBox(height: 10),
                                            _buildOption(
                                                context,
                                                'D',
                                                currentQuestion.option4!, 4,
                                                cubit),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  defaultButton(
                                      function: () {
                                        if (cubit.currentIndex < cubit.questions.length - 1) {
                                        cubit.changeIndex(cubit.currentIndex  + 1);
                                        cubit.addAnswer(currentQuestion.question!, cubit.selectedOption);
                                        // cubit.submitAnswer(childId, currentQuestion.question!, cubit.selectedOption);
                                        } else {
                                          cubit.addAnswer(currentQuestion.question!, cubit.selectedOption);
                                          cubit.submitAnswers(childId, cubit.answers);
                                          showDialog(context: context, builder: (context) {
                                            return AlertDialog(
                                              title: const Text('تم'),
                                              content: const Text('تم الانتهاء من جميع الأسئلة'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    navigateAndFinish(context, MainLayout());
                                                  },
                                                  child: const Text('حسناً'),
                                                ),
                                              ],
                                            );
                                          });
                                        }
                                      },
                                      text: cubit.currentIndex < cubit.questions.length - 1 ? next : finish,
                                      width: MediaQuery.of(context).size.width,
                                      fSize: 20.0,
                                      radius: 10.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    fallback: (BuildContext context) => loadingDialog(context),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }

  Widget _buildOption(BuildContext context, String letter, String optionText, int optionValue,
      QuestionsCubit cubit) {
    return InkWell(
      onTap: () {
        //Change the color of the selected option
        cubit.selectOption(optionText, optionValue);
      },
      child: BlurryContainer(
        blur: 5,
        width: double.infinity,
        color: cubit.selectedOption == optionText
            ? Colors.blue.withAlpha(128)
            : Colors.white.withAlpha(128),
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Text(
              '($letter) ',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                optionText,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Padding(
// padding: const EdgeInsets.all(20.0),
// child: SingleChildScrollView(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// SizedBox(
// height: MediaQuery.of(context).size.height * 0.2,
// ),
// Transform.rotate(
// angle: pi,
// child: Swiper(
// scrollDirection: Axis.horizontal,
// axisDirection: AxisDirection.right,
// loop: false,
// itemCount: cubit.questions.length,
// itemHeight: 500,
// itemWidth: MediaQuery.of(context).size.width * 0.7,
// layout: SwiperLayout.STACK,
// itemBuilder: (context, index) {
// return Transform.rotate(
// angle: pi,
// child: Padding(
// padding: const EdgeInsets.all(20.0),
// child: BlurryContainer(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height * 0.5,
// elevation: 10,
// color: Colors.white,
// child: Column(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// BlurryContainer(
// width: double.infinity,
// color: Colors.green,
// child: Center(
// child: Text(
// cubit.questions.elementAt(index).question!,
// ),
// ),
// ),
// SizedBox(
// height: 20.0,
// ),
// Column(
// crossAxisAlignment:
// CrossAxisAlignment.start,
// children: [
// SizedBox(
// height: 20.0,
// ),
// RadioListTile.adaptive(
// activeColor: Colors.green,
// value: 10,
// groupValue: 1,
// onChanged: (value) {
// // cubit.changeSelectedOption(value);
// },
// title: Text(
// cubit.questions
//     .elementAt(index)
//     .option1!,
// maxLines: 2,
// overflow: TextOverflow.visible,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// SizedBox(
// height: 10.0,
// ),
// RadioListTile.adaptive(
// activeColor: Colors.green,
// value: 10,
// groupValue: 1,
// onChanged: (value) {
// // cubit.changeSelectedOption(value);
// },
// title: Text(
// cubit.questions
//     .elementAt(index)
//     .option2!,
// maxLines: 2,
// overflow: TextOverflow.visible,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// SizedBox(
// height: 10.0,
// ),
// RadioListTile.adaptive(
// activeColor: Colors.green,
// value: 10,
// groupValue: 1,
// onChanged: (value) {
// // cubit.changeSelectedOption(value);
// },
// title: Text(
// cubit.questions
//     .elementAt(index)
//     .option3!,
// maxLines: 2,
// overflow: TextOverflow.visible,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// SizedBox(
// height: 10.0,
// ),
// RadioListTile.adaptive(
// activeColor: Colors.green,
// value: 10,
// groupValue: 1,
// onChanged: (value) {
// // cubit.changeSelectedOption(value);
// },
// title: Text(
// cubit.questions
//     .elementAt(index)
//     .option4!,
// maxLines: 2,
// overflow: TextOverflow.visible,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// );
// },
// pagination: const SwiperPagination(
// alignment: Alignment.bottomCenter,
// builder: DotSwiperPaginationBuilder(
// color: Colors.grey,
// activeColor: Colors.green,
// size: 10.0,
// activeSize: 15.0,
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
