import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Answers/answers_model.dart';
import '../../../shared/components/constants.dart';

class AnswersScreen extends StatelessWidget {
  final AnswersModel? answers;
  AnswersScreen({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          'assets/images/pattern.png',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0,),
                Text("$date: ${DateFormat('EEEE, d MMMM yyyy', 'ar').format(
                    answers!.date!)}"),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                      itemCount: answers!.answers!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 10.0,),
                            BlurryContainer(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.white60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    answers!.answers!.keys.elementAt(index),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Text(
                                    answers!.answers!.values.elementAt(index),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => myDivider(color: Colors.black),
                  ),
                ),



              ],
            ),
          ),
        )
      ]),
    );
  }
}
