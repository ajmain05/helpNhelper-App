class TeamMemberModel {
  int? id;
  String? name;
  String? designation;
  String? institution;
  String? message;
  String? photo;
  String? type;
  int? sequence;

  TeamMemberModel({
    this.id,
    this.name,
    this.designation,
    this.institution,
    this.message,
    this.photo,
    this.type,
    this.sequence,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) =>
      TeamMemberModel(
        id: json['id'],
        name: json['name'],
        designation: json['designation'],
        institution: json['institution'],
        message: json['message'],
        photo: json['photo'],
        type: json['type'],
        sequence: json['sequence'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'designation': designation,
        'institution': institution,
        'message': message,
        'photo': photo,
        'type': type,
        'sequence': sequence,
      };
}
