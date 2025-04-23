class FeedbackModel{
  String? uId;
  String? childId;
  String? feedback;

  FeedbackModel(this.uId, this.childId, this.feedback);

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    childId = json['childId'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'childId': childId,
      'feedback': feedback,
    };

  }
}