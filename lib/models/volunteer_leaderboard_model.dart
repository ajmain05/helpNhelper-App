class VolunteerLeaderboardModel {
  int? volunteerId;
  String? name;
  String? photo;
  int? points;
  int? taskCount;

  VolunteerLeaderboardModel(
      {this.volunteerId, this.name, this.photo, this.points, this.taskCount});

  VolunteerLeaderboardModel.fromJson(Map<String, dynamic> json) {
    volunteerId = json['volunteer_id'];
    name = json['name'];
    photo = json['photo'];
    points = json['points'];
    taskCount = json['task_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['volunteer_id'] = this.volunteerId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['points'] = this.points;
    data['task_count'] = this.taskCount;
    return data;
  }
}
