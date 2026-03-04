import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:helpnhelper/models/team_member_model.dart';
import 'package:helpnhelper/utils/api_url.dart';

class AboutController extends GetxController {
  var isLoading = false.obs;
  var teamMembers = <TeamMemberModel>[].obs;
  var shariahMembers = <TeamMemberModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    try {
      isLoading(true);

      // Fetch Team Members
      final teamRes = await http.get(Uri.parse('$getTeamMembersApi?type=team'));
      if (teamRes.statusCode == 200) {
        final data = json.decode(teamRes.body)['data'] as List;
        teamMembers.value =
            data.map((e) => TeamMemberModel.fromJson(e)).toList();
      } else {
        _loadFallbackTeam();
      }

      // Fetch Shariah Members
      final shariahRes =
          await http.get(Uri.parse('$getTeamMembersApi?type=shariah'));
      if (shariahRes.statusCode == 200) {
        final data = json.decode(shariahRes.body)['data'] as List;
        shariahMembers.value =
            data.map((e) => TeamMemberModel.fromJson(e)).toList();
      } else {
        _loadFallbackShariah();
      }
    } catch (e) {
      print('Error fetching team members: $e');
      if (teamMembers.isEmpty) _loadFallbackTeam();
      if (shariahMembers.isEmpty) _loadFallbackShariah();
    } finally {
      isLoading(false);
    }
  }

  void _loadFallbackTeam() {
    teamMembers.value = [
      TeamMemberModel(
          name: 'Eng. Muhammed Nasir Uddin',
          designation: 'Founder & Chairman',
          photo: 'assets/owner.png'),
      TeamMemberModel(name: 'Monjurul Karim', designation: 'Vice Chairman'),
      TeamMemberModel(name: 'ASM Rezaul Karim', designation: 'Vice Chairman'),
      TeamMemberModel(
          name: 'MD. Sayedul Abrar', designation: 'Financial Secretary'),
      TeamMemberModel(
          name: 'Mohammed Zobair Sadek', designation: 'General Secretary'),
      TeamMemberModel(
          name: 'Raghib Iftikhar Ahmad', designation: 'Assistant Secretary'),
      TeamMemberModel(
          name: 'Mohammed Mojibul Hoque', designation: 'Organizing Secretary'),
      TeamMemberModel(name: 'Tanvir Sikdar', designation: 'Co-Ordinator'),
    ];
  }

  void _loadFallbackShariah() {
    shariahMembers.value = [
      TeamMemberModel(
          name: 'Dr. AFM Khalid Hossain',
          designation: 'Chairman, Shariah Advisory Board'),
      TeamMemberModel(
          name: 'Prof. Dr. Abu Bakr Rafique',
          designation: 'Secretary, Shariah Advisory Board'),
      TeamMemberModel(
          name: 'Prof. Dr. M. Gias Uddin Talukder',
          designation: 'Member, Shariah Advisory Board'),
      TeamMemberModel(
          name: 'Prof. Dr. B.M Mofizur Rahman Al-Azhari',
          designation: 'Member, Shariah Advisory Board'),
      TeamMemberModel(
          name: 'Prof. Dr. Sheikh Mahmudul Hasan',
          designation: 'Member, Shariah Advisory Board'),
    ];
  }
}
