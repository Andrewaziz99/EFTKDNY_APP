import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eftkdny/modules/Questions/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/Questions/questions_model.dart';

class QuestionsCubit extends Cubit<QuestionStates> {
  QuestionsCubit() : super(QuestionInitialState());

  static QuestionsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(QuestionChangeIndexState());
  }


  List<QuestionModel> questions = [];

  void getQuestions() {
    emit(QuestionLoadingState());
    FirebaseFirestore.instance.collection('questions').get().then((value) {
      questions =
          value.docs.map((doc) => QuestionModel.fromJson(doc.data())).toList();
      emit(QuestionSuccessState(questions));
    }).catchError((error) {
      print(error.toString());
      emit(QuestionErrorState(error.toString()));
    });
  }

  String selectedOption = '';
  int selectedValue = 0;

  void selectOption(String option, int value) {
    selectedOption = option;
    selectedValue = value;
    emit(QuestionChangeIndexState());
  }

  Map<String, dynamic> answers = {};
  void addAnswer( String question, String answer) {
    emit(addAnswerState());
    answers[question] = answer;
  }

  void submitAnswers(String childId, Map<String, dynamic> answers) {
    emit(QuestionSubmitAnswerLoadingState());
    DocumentReference docRef = FirebaseFirestore.instance.collection('answers').doc();
    FirebaseFirestore.instance
        .collection('answers')
        .doc(docRef.id)
        .set({'answers': answers, 'childId': childId, 'date': DateTime.now()})
        .then((value) {
      emit(QuestionSubmitAnswerSuccessState('Answers submitted successfully'));
      answers.clear();
    }).catchError((error) {
      emit(QuestionSubmitAnswerErrorState(error.toString()));
    });

  }


  void submitAnswer(String childId, String question, String answer) {
    emit(QuestionSubmitAnswerLoadingState());
    DocumentReference docRef = FirebaseFirestore.instance.collection('answers').doc();
    FirebaseFirestore.instance
        .collection('answers')
        .doc(docRef.id)
        .set({'childId': childId, 'question': question,'answer': answer})
        .then((value) {
      emit(QuestionSubmitAnswerSuccessState('Answer submitted successfully'));
    }).catchError((error) {
      emit(QuestionSubmitAnswerErrorState(error.toString()));
    });
  }

  void getAllAnswers() {
    emit(QuestionGetAnswersLoadingState());
    FirebaseFirestore.instance
        .collection('answers')
        .get()
        .then((value) {
      List<QuestionModel> answers = value.docs
          .map((doc) => QuestionModel.fromJson(doc.data()))
          .toList();
      emit(QuestionGetAnswersSuccessState(answers));
    }).catchError((error) {
      print(error.toString());
      emit(QuestionGetAnswersErrorState(error.toString()));
    });
  }


  void getAnswers(String childId) {
    emit(QuestionGetAnswersLoadingState());
    FirebaseFirestore.instance
        .collection('answers')
        .where('childId', isEqualTo: childId)
        .get()
        .then((value) {
      List<QuestionModel> answers = value.docs
          .map((doc) => QuestionModel.fromJson(doc.data()))
          .toList();
      emit(QuestionGetAnswersSuccessState(answers));
    }).catchError((error) {
      print(error.toString());
      emit(QuestionGetAnswersErrorState(error.toString()));
    });
  }


}
