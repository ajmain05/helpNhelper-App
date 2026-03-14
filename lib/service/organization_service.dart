import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/models/org_application_model.dart';
import 'dart:io';

class OrganizationService {
  final box = GetStorage();

  Future<List<OrgApplicationModel>> getApplications() async {
    final token = box.read('access_token');
    final response = await http.get(
      Uri.parse(orgApplicationsApi),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((e) => OrgApplicationModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load applications');
    }
  }

  Future<bool> submitApplication({
    required String title,
    required String description,
    required String category,
    required String targetAmount,
    required String seekerName,
    required String seekerLocation,
    required String paymentMethod,
    required String paymentAccount,
    required File certImage,
  }) async {
    final token = box.read('access_token');
    final request = http.MultipartRequest('POST', Uri.parse(orgSubmitApplicationApi));
    
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.fields['target_amount'] = targetAmount;
    request.fields['seeker_name'] = seekerName;
    request.fields['seeker_location'] = seekerLocation;
    request.fields['payment_method'] = paymentMethod;
    request.fields['payment_account'] = paymentAccount;

    request.files.add(
      await http.MultipartFile.fromPath('cert_image', certImage.path),
    );

    final response = await request.send();
    final responsed = await http.Response.fromStream(response);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print('Submission error: ${responsed.body}');
      return false;
    }
  }

  Future<double> getServiceCharge() async {
    try {
      final response = await http.get(
        Uri.parse(settingsApi),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return (data['org_service_charge'] as num).toDouble();
      }
    } catch (e) {
      print('Error fetching settings: $e');
    }
    return 7.0; // Default fallback
  }
}
