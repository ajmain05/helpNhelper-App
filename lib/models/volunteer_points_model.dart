class VolunteerPointsModel {
  int? totalPoints;
  List<VolunteerRewardModel>? rewards;

  VolunteerPointsModel({this.totalPoints, this.rewards});

  VolunteerPointsModel.fromJson(Map<String, dynamic> json) {
    totalPoints = json['total_points'];
    if (json['rewards'] != null) {
      rewards = <VolunteerRewardModel>[];
      json['rewards'].forEach((v) {
        rewards!.add(new VolunteerRewardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_points'] = this.totalPoints;
    if (this.rewards != null) {
      data['rewards'] = this.rewards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VolunteerRewardModel {
  int? id;
  String? type;
  int? month;
  int? year;
  double? amount;
  String? status;
  String? date;

  VolunteerRewardModel(
      {this.id,
      this.type,
      this.month,
      this.year,
      this.amount,
      this.status,
      this.date});

  VolunteerRewardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    month = json['month'];
    year = json['year'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0;
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['month'] = this.month;
    data['year'] = this.year;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['date'] = this.date;
    return data;
  }
}
