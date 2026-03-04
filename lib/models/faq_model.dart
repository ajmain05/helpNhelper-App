class FaqModel {
  int? id;
  String? question;
  String? answer;

  FaqModel({this.id, this.question, this.answer});

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['title'];
    answer = json['description'];
  }
}
