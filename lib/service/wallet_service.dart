import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:helpnhelper/utils/api_url.dart';
import 'package:helpnhelper/models/wallet_model.dart';
import 'package:get/get.dart';

class WalletService {
  final _box = GetStorage();

  String? _token() => _box.read<String>('access_token');

  Map<String, String> get _headers => {
        "Accept": "application/json",
        "Authorization": "Bearer ${_token() ?? ''}",
      };

  // ── Wallet balance + allocation history
  Future<CorporateWalletData?> fetchWalletHistory() async {
    if (_token() == null) return null;
    try {
      final res = await http.get(
        Uri.parse('${baseUrl}corporate/wallet-history'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success'] == true) return CorporateWalletData.fromJson(data);
      }
    } catch (e) {
      debugPrint('WalletService.fetchWalletHistory: $e');
    }
    return null;
  }

  // ── Initiate SSLCommerz deposit (max ৳1,00,000)
  Future<String?> initiateDeposit(double amount) async {
    if (_token() == null) return null;
    try {
      final res = await http.post(
        Uri.parse('${baseUrl}corporate/deposit/initiate'),
        headers: {..._headers, "Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success'] == true) return data['redirect_url'];
      }
      final data = json.decode(res.body);
      Get.snackbar('Error', data['message'] ?? 'Failed to initiate deposit.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      debugPrint('WalletService.initiateDeposit: $e');
    }
    return null;
  }

  // ── Submit a cheque deposit request (donor side — admin approves before wallet is credited)
  Future<bool> submitChequeDeposit({
    required double amount,
    required String chequeNo,
    required String bankName,
    File? chequeImage,
  }) async {
    if (_token() == null) return false;
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}corporate/deposit/cheque'),
      );
      request.headers.addAll(_headers);
      request.fields['amount'] = amount.toStringAsFixed(2);
      request.fields['cheque_no'] = chequeNo;
      request.fields['bank_name'] = bankName;

      if (chequeImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'cheque_image',
          chequeImage.path,
        ));
      }

      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      final data = json.decode(res.body);

      if (res.statusCode == 201 && data['success'] == true) return true;

      Get.snackbar('Error', data['message'] ?? 'Submission failed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      debugPrint('WalletService.submitChequeDeposit: $e');
    }
    return false;
  }

  // ── Deposit history (SSLCommerz + cheque, newest first)
  Future<List<CorporateDepositRecord>> fetchDepositHistory() async {
    if (_token() == null) return [];
    try {
      final res = await http.get(
        Uri.parse('${baseUrl}corporate/deposit/history'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['success'] == true) {
          final items = (data['data']?['data'] as List?) ?? [];
          return items.map((e) => CorporateDepositRecord.fromJson(e)).toList();
        }
      }
    } catch (e) {
      debugPrint('WalletService.fetchDepositHistory: $e');
    }
    return [];
  }
}
