import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpnhelper/controllers/home_controller.dart';
import 'package:helpnhelper/utils/global_size.dart';
import 'package:helpnhelper/utils/my_colors.dart';

class MyDonationPage extends StatefulWidget {
  MyDonationPage({Key? key}) : super(key: key);

  @override
  _MyDonationPageState createState() => _MyDonationPageState();
}

class _MyDonationPageState extends State<MyDonationPage> {
  List<String> campaign = [
    'Health',
    'Shelter',
    'Sanitation',
    'Health',
    'Shelter',
    'Sanitation',
  ];
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose where to donate your money",
            style: GoogleFonts.philosopher(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: GlobalSize.height(46),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: campaign.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: (() {
                    setState(() {
                      selected = index;
                    });
                  }),
                  child: Container(
                    height: GlobalSize.height(39),
                    // width: GlobalSize.width(112),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    decoration: BoxDecoration(
                      color: index == selected
                          ? MyColors.appColor
                          : MyColors.appColorLight,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.medical_services
                              : Icons.night_shelter,
                          color: index == selected
                              ? Colors.black
                              : const Color.fromARGB(255, 122, 122, 122),
                        ),
                        Text(
                          campaign[index],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: index == selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: index == selected
                                  ? Colors.black
                                  : const Color.fromARGB(255, 142, 142, 142)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          Container(
              alignment: Alignment.centerLeft,
              height: GlobalSize.height(341),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      height: GlobalSize.height(341),
                      width: GlobalSize.width(268),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                    child: Container(
                                  height: GlobalSize.height(152),
                                  width: GlobalSize.width(268),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                          image: AssetImage("assets/bg2.png"),
                                          fit: BoxFit.cover)),
                                )),
                                const Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    "Fundraising for john",
                                    style: GoogleFonts.philosopher(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.height(10),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: GlobalSize.height(34),
                                  width: GlobalSize.width(88),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: MyColors.appColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Health",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: GlobalSize.height(34),
                                  width: GlobalSize.width(88),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: MyColors.appColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Health",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.height(20),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total raised",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.ash),
                                    ),
                                    SizedBox(
                                      height: GlobalSize.height(10),
                                    ),
                                    Text(
                                      "\$65,569 ",
                                      style: GoogleFonts.philosopher(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: GlobalSize.width(40),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total raised",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.ash),
                                    ),
                                    SizedBox(
                                      height: GlobalSize.height(10),
                                    ),
                                    Text(
                                      "\$65,569 ",
                                      style: GoogleFonts.philosopher(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: (() {
                                // Get.to(() => AddProductPage());
                                Get.find<HomeController>().openUrl();
                              }),
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: MyColors.appColor,
                                      gradient: const LinearGradient(
                                        colors: [
                                          MyColors.appColor,
                                          Color.fromARGB(255, 0, 0, 0)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: GlobalSize.height(43),
                                  width: GlobalSize.width(251),
                                  child: Center(
                                    child: Text(
                                      "Donate Now",
                                      style: GoogleFonts.philosopher(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: GlobalSize.height(10),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          Text(
            "Ongoing Crisis",
            style: GoogleFonts.philosopher(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          const Text(
            "Don’t let complicated, expensive software get in the way of your mission. Givebutter’s tools are easy, free, and fun to use.",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          Container(
              alignment: Alignment.centerLeft,
              height: GlobalSize.height(341),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      height: GlobalSize.height(341),
                      width: GlobalSize.width(268),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                    child: Container(
                                  height: GlobalSize.height(152),
                                  width: GlobalSize.width(268),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: const DecorationImage(
                                          image: AssetImage("assets/bg2.png"),
                                          fit: BoxFit.cover)),
                                )),
                                const Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    )),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    "Fundraising for john",
                                    style: GoogleFonts.philosopher(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.height(10),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: GlobalSize.height(34),
                                  width: GlobalSize.width(88),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: MyColors.appColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Health",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: GlobalSize.height(34),
                                  width: GlobalSize.width(88),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: MyColors.appColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.medical_services,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        "Health",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: GlobalSize.height(40),
                            ),
                            Container(
                              height: GlobalSize.height(5),
                              decoration: BoxDecoration(
                                  color: MyColors.appColor,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Container(
                                    height: GlobalSize.height(10),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 167, 167, 167),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$65,569 raised",
                              style: GoogleFonts.philosopher(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              onTap: (() {
                                // Get.to(() => AddProductPage());
                              }),
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: MyColors.appColor,
                                      gradient: const LinearGradient(
                                        colors: [
                                          MyColors.appColor,
                                          Color.fromARGB(255, 97, 97, 97)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: GlobalSize.height(43),
                                  width: GlobalSize.width(251),
                                  child: Center(
                                    child: Text(
                                      "Donate Now",
                                      style: GoogleFonts.philosopher(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: GlobalSize.height(10),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
          SizedBox(
            height: GlobalSize.height(10),
          ),
          Container(
            height: GlobalSize.height(168),
            padding: const EdgeInsets.only(left: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: GlobalSize.height(67),
                        width: GlobalSize.width(67),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/gift.png"))),
                      ),
                      SizedBox(
                        width: GlobalSize.width(20),
                      ),
                      SizedBox(
                        width: GlobalSize.width(194),
                        child: Text(
                          "Send Gift Card for seekers",
                          style: GoogleFonts.philosopher(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: GlobalSize.height(20),
                  ),
                  Container(
                    height: GlobalSize.height(43),
                    width: GlobalSize.width(157),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.white)),
                    child: const Center(
                      child: Text(
                        "Send Gift",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ]),
          ),
          SizedBox(
            height: GlobalSize.height(10),
          ),
        ],
      ),
    );
  }
}

heading(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style:
            GoogleFonts.philosopher(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      const Text(
        "See all",
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
