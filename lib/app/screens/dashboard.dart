import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_admin/controllers/dashboard_controller.dart';
import '../../config/responsive.dart';
import '../../config/size_config.dart';
import '../../models/model.dart';
import '../../shared/utils/colors.dart';
import '../../widgets/bar_chart.dart';
import '../../widgets/header_action_items.dart';
import '../../widgets/header_parts.dart';
import '../../widgets/show_history.dart';
import '../../widgets/side_drawer_menu.dart';
import '../../widgets/transfer_info_card.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  final controller = Get.put<DashBoardController>(DashBoardController());

  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: toggleDrawer,
          icon: const Icon(Icons.menu, color: Colors.black),
        ),
        actions: const [
          HeaderActionItems(),
        ],
      )
          : const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox(),
      ),
      body: Stack(
        children: [
          /// 🟦 Main Dashboard UI
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                   Expanded(
                    flex: controller.isExpanded ? 2 : 1,
                    child: SideDrawerMenu(),
                  ),
                Expanded(
                  flex: 10,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderParts(),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                        SizedBox(
                          width: SizeConfig.screenWidth,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.spaceBetween,
                            children: infoCardData
                                .map((info) =>
                                TransferInfoCard(infoCardModel: info))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 4),
                        SizeConfig.screenWidth < 600
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Monthly News Submissions",
                              style: TextStyle(fontSize: 16, color: MyAppColor.secondary),
                            ),
                            const Text(
                              'Tier-Wise News Contribution Overview',
                              style: TextStyle(
                                fontSize: 30,
                                color: MyAppColor.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Past 30 DAYS',
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColor.secondary,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monthly News Submissions",
                                  style: TextStyle(fontSize: 16, color: MyAppColor.secondary),
                                ),
                                Text(
                                  'Tier-Wise News Contribution Overview',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: MyAppColor.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Past 30 DAYS',
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColor.secondary,
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        const SizedBox(
                          height: 180,
                          child: BarChartRepresentation(),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 5),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'History',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: MyAppColor.primary,
                              ),
                            ),
                            Text(
                              'Recent Uploads',
                              style: TextStyle(
                                fontSize: 16,
                                color: MyAppColor.secondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 3),
                         ShowHistory(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isDrawerOpen)
            GestureDetector(
              onTap: toggleDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),

          /// 🟩 Slide in drawer
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: isDrawerOpen ? 0 : -100, // adjust width as needed
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 100,
              child: Material(
                elevation: 16,
                child: SideDrawerMenu(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
