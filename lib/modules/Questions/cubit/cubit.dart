import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Questions/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/Questions/questions_model.dart';

class QuestionsCubit extends Cubit<QuestionStates> {
  QuestionsCubit() : super(QuestionInitialState());

  static QuestionsCubit get(context) => BlocProvider.of(context);

  List<QuestionModel> questions = [];

  void getQuestions() {
    emit(QuestionLoadingState());
    FirebaseFirestore.instance.collection('questions').get().then((value) {
      questions =
          value.docs.map((doc) => QuestionModel.fromJson(doc.data())).toList();
      print(questions.length);
      emit(QuestionSuccessState(questions));
    }).catchError((error) {
      print(error.toString());
      emit(QuestionErrorState(error.toString()));
    });
  }


}