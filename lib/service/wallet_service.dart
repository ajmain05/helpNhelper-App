import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/models/wallet_model.dart';
import 'package:get/get.dart';

class WalletService {
  final box = GetStorage();

  Future<CorporateWalletData?> fetchWalletHistory() async {
    final token = box.read<String>('access_token');
    if (token == null || token.isEmpty) return null;

    try {
      final url = Uri.parse('${baseUrl}corporate/wallet-history');
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return CorporateWalletData.fromJson(data);
        }
      } else {
        print(
            'Failed to fetch wallet history: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('WalletService Error: $e');
    }
    return null;
  }
}
