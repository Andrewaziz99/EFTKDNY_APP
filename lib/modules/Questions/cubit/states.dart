import '../../../models/Questions/questions_model.dart';

abstract class QuestionStates{}

class QuestionInitialState extends QuestionStates{}

class QuestionLoadingState extends QuestionStates{}

class QuestionSuccessState extends QuestionStates{
  final List<QuestionModel> questions;
  QuestionSuccessState(this.questions);
}

class QuestionErrorState extends QuestionStates{
  final String error;
  QuestionErrorState(this.error);
}