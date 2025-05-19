import '../../../models/Questions/questions_model.dart';

abstract class QuestionStates{}

class QuestionInitialState extends QuestionStates{}

class QuestionChangeIndexState extends QuestionStates{}

class QuestionLoadingState extends QuestionStates{}

class QuestionSuccessState extends QuestionStates{
  final List<QuestionModel> questions;
  QuestionSuccessState(this.questions);
}

class QuestionErrorState extends QuestionStates{
  final String error;
  QuestionErrorState(this.error);
}

class QuestionSelectOptionState extends QuestionStates{
  final String selectedOption;
  QuestionSelectOptionState(this.selectedOption);
}

class addAnswerState extends QuestionStates{
}

class QuestionSubmitAnswerLoadingState extends QuestionStates{
}

class QuestionSubmitAnswerSuccessState extends QuestionStates{
  final String message;
  QuestionSubmitAnswerSuccessState(this.message);
}

class QuestionSubmitAnswerErrorState extends QuestionStates{
  final String error;
  QuestionSubmitAnswerErrorState(this.error);
}

class QuestionGetAnswersLoadingState extends QuestionStates{
}

class QuestionGetAnswersSuccessState extends QuestionStates{
  final List<QuestionModel> answers;
  QuestionGetAnswersSuccessState(this.answers);
}

class QuestionGetAnswersErrorState extends QuestionStates{
  final String error;
  QuestionGetAnswersErrorState(this.error);
}