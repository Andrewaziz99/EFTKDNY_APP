import 'package:card_swiper/card_swiper.dart';
import 'package:eftkdny/modules/Questions/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => QuestionsCubit()..getQuestions(),
      child: BlocConsumer<QuestionsCubit, QuestionStates>(
        builder: (BuildContext context, state) {
          final cubit = QuestionsCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/pattern.png',
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Swiper(
                        loop: false,
                        itemCount: cubit.questions.length,
                        fade: 10,
                        itemHeight: 500,
                        itemWidth: MediaQuery.of(context).size.width * 0.7,
                        layout: SwiperLayout.TINDER,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Question ${index + 1}'),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text('This is the content of question ${index + 1}'),
                              ],
                            ),
                          );
                        },
                        pagination: SwiperPagination(
                          margin: EdgeInsets.only(top: 520),
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                            color: Colors.grey,
                            activeColor: Colors.blue,
                            size: 10.0,
                            activeSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {  },
      ),
    );
  }
}
