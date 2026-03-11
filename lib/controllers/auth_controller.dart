import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/models/country_model.dart';
import 'package:helpnhelper/models/district_model.dart';
import 'package:helpnhelper/models/division_model.dart';
import 'package:helpnhelper/models/upazila_model.dart';
import 'package:helpnhelper/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

import '../service/auth_service.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUpdatingProfile = false.obs;
  RxBool terms = false.obs;
  RxString type = "volunteer".obs;
  RxString countryId = "".obs;
  RxString divisionId = "".obs;
  RxString districtId = "".obs;
  RxString upazilaId = "".obs;
  RxList<PickedFile> profileImage = <PickedFile>[].obs;
  RxList<PickedFile> nidImage = <PickedFile>[].obs;
  RxList<CountryModel> countryList = <CountryModel>[].obs;
  RxList<DistrictModel> districtList = <DistrictModel>[].obs;
  RxList<DivisionModel> divisionList = <DivisionModel>[].obs;
  RxList<UpazilaModel> upazilaList = <UpazilaModel>[].obs;
  Rx<UserModel> userData = UserModel().obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController upazillaController = TextEditingController();
  TextEditingController presentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool passLogin = false;
  bool phoneLogin = false;

  @override
  onInit() async {
    super.onInit();
    getInitialData();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
  }

  getInitialData() {
    getCountry();
    final box = GetStorage();
    final savedUser = box.read('userData');
    if (savedUser != null) {
      userData.value = UserModel.fromJson(savedUser);
    } else {
      final token = box.read<String>('access_token');
      if (token != null && token.isNotEmpty) {
        AuthService().fetchUserProfile();
      }
    }
  }

  getCountry() {
    countryList.clear();
    AuthService service = AuthService();
    service.getCountry();
  }

  getDivision(String id) {
    divisionList.clear();
    AuthService service = AuthService();

    service.getDivision(id);
  }

  getDistrict(String id) {
    districtList.clear();
    AuthService service = AuthService();

    service.getDistrict(id);
  }

  getUpazila(String id) {
    upazilaList.clear();
    AuthService service = AuthService();

    service.getUpazila(id);
  }

  Future<bool> signUp() async {
    AuthService service = AuthService();
    return await service.signUpUser(type.value);
  }

  Future<bool> signIn() async {
    AuthService service = AuthService();
    return await service.signIn();
  }

  Future<bool> getOtp() async {
    AuthService service = AuthService();
    return await service.getOtp();
  }

  logOut() async {
    AuthService service = AuthService();
    return await service.logOut();
  }

  Future<bool> updateProfile({
    String? name,
    String? mobile,
    String? photoPath,
  }) async {
    isUpdatingProfile.value = true;
    final service = AuthService();
    return await service.updateProfile(
      name: name,
      mobile: mobile,
      photoPath: photoPath,
    );
  }
}
