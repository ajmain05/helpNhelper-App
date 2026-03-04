// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/utils/global_size.dart';
import '../../utils/my_colors.dart';

class SeekerHistoryDetail extends StatefulWidget {
  SeekerHistoryDetail({Key? key}) : super(key: key);

  @override
  _SeekerHistoryDetailState createState() => _SeekerHistoryDetailState();
}

class _SeekerHistoryDetailState extends State<SeekerHistoryDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Get.find<HomeController>().seekerHistoryDetail.value;

    return Scaffold(
      backgroundColor: MyColors.appColorBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: MyColors.appColor,
                      ),
                    ),
                    SizedBox(
                      height: GlobalSize.height(30),
                      child: const Center(
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.transparent,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  data.title ?? "No Title",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),

                // Status & Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(
                        data.status?.toUpperCase() ?? "N/A",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    Text(
                      "৳${data.requestedAmount}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Divider(color: Colors.white),

                // User Info
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "${data.user?.photo ?? ''}",
                    ),
                  ),
                  title: Text(
                    data.user?.name ?? "No Name",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    data.user?.mobile ?? "No Mobile",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Divider(color: Colors.white),

                // Description
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  data.description ?? "No description available.",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),

                // Completion Date
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Completion Date: ${data.completionDate.toString()}",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Category & Comment
                Row(
                  children: [
                    Text("Category: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(data.category ?? "Others",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("Comment: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(data.comment ?? "No Comment",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 10),

                // Volunteer Document Status
                if (data.volunteerDocumentStatus != null)
                  Row(
                    children: [
                      Text("Document Status: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                        data.volunteerDocumentStatus?.toUpperCase() ?? "N/A",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                // Document & Image Preview
                SizedBox(height: 15),
                if (data.document != null)
                  ElevatedButton(
                    onPressed: () {
                      // Open document
                    },
                    child: Text("View Document"),
                  ),
                SizedBox(height: 10),
                if (data.image != null)
                  Image.network(
                    "https://yourserver.com/${data.image}",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
