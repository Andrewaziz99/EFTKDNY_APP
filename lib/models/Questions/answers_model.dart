class AnalysisModel {
  String? question;
  String? answer;
  String? date;
  String? uId;
  String? childId;

  AnalysisModel(this.question, this.answer, this.date, this.uId, this.childId);

  AnalysisModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    date = json['date'];
    uId = json['uId'];
    childId = json['childId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'date': date,
      'uId': uId,
      'childId': childId,
    };
  }
}
