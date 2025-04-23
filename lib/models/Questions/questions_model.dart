class QuestionModel {
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;

  QuestionModel(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4});

  QuestionModel.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        option1 = json['option1'],
        option2 = json['option2'],
        option3 = json['option3'],
        option4 = json['option4'];

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
    };
  }
}
