import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/auth_controller.dart';
import 'package:helpnhelper/controllers/seeker_controller.dart';
import 'package:helpnhelper/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../../utils/global_size.dart';
import 'package:path/path.dart';

class InvestigateDocUpdate extends StatefulWidget {
  InvestigateDocUpdate({Key? key}) : super(key: key);

  @override
  _InvestigateDocUpdateState createState() => _InvestigateDocUpdateState();
}

class _InvestigateDocUpdateState extends State<InvestigateDocUpdate> {
  final _formKey = GlobalKey<FormState>();

  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    Get.find<AuthController>().profileImage.add(_pickedFile!);
  }

  TextEditingController commentController = TextEditingController();

  _createWallet(context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            Get.back();
          });
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              decoration: BoxDecoration(
                  //  color: Colors.black,
                  borderRadius: BorderRadius.circular(15)),
              constraints:
                  BoxConstraints(maxHeight: Get.height, maxWidth: Get.width),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Lottie.asset("assets/animations/ss.json")),
            ),
          );
        });
  }

  void _selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files[0].path.toString());
      if (Get.find<SeekerController>().investigateDoc.isNotEmpty) {
        Get.find<SeekerController>().investigateDoc.clear();
      }
      Get.find<SeekerController>().investigateDoc.add(file);
      // _uploadFile(file);
    } else {
      // User canceled the file selection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !(Get.find<AuthController>().isLoading.value),
          replacement: Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00BFA5),
                strokeWidth: 3,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: MyColors.appColorBg,
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        height: GlobalSize.height(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: MyColors.appColor,
                                )),
                            Text(
                              "Upload  Document",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Get.find<SeekerController>()
                            .applicationDetail
                            .value
                            .application!
                            .title
                            .toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Requested BDT " +
                            Get.find<SeekerController>()
                                .applicationDetail
                                .value
                                .application!
                                .requestedAmount
                                .toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Completion Date : " +
                            Get.find<SeekerController>()
                                .applicationDetail
                                .value
                                .application!
                                .completionDate
                                .toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: Get.width - 100,
                        child: Text(
                          Get.find<SeekerController>()
                              .applicationDetail
                              .value
                              .application!
                              .description
                              .toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 91, 91, 91),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: GlobalSize.height(20),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectFile(context);
                        },
                        child: Container(
                          width: Get.width,
                          height: 100,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Get.find<SeekerController>()
                                      .investigateDoc
                                      .isEmpty
                                  ? Text(
                                      "Upload Verification File",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      "Change File (" +
                                          basename(Get.find<SeekerController>()
                                              .investigateDoc[0]
                                              .absolute
                                              .toString()) +
                                          ")",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.upload_file,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Get.width - 32,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          controller: commentController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontStyle: FontStyle.normal),
                          decoration: InputDecoration(
                            hintText: "Comment",
                            hintStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                fontStyle: FontStyle.normal),
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(color: MyColors.ash),
                            ),
                            errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                )),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      MaterialButton(
                        onPressed: () {
                          if (Get.find<SeekerController>()
                              .investigateDoc
                              .isEmpty) {
                            Get.snackbar(" Sorry", "You need to add File",
                                duration: Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                          } else {
                            Get.find<SeekerController>()
                                .uploadDoc(commentController.text)
                                .then((value) async {
                              if (value == true) {
                                commentController.text = '';
                                Get.find<SeekerController>()
                                    .investigateDoc
                                    .clear();
                                _createWallet(context);
                              }
                            });
                          }
                        },
                        color: MyColors.appColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: GlobalSize.height(53),
                          width: Get.width,
                          alignment: Alignment.center,
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
