import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_admin/controllers/dashboard_controller.dart';
import 'package:news_admin/core/di/get_injector.dart';
import 'package:news_admin/routes/app_pages.dart';
import '../models/model.dart';
import '../shared/utils/colors.dart';

class SideDrawerMenu extends StatefulWidget {
  const SideDrawerMenu({super.key});

  @override
  _SideDrawerMenuState createState() => _SideDrawerMenuState();
}

class _SideDrawerMenuState extends State<SideDrawerMenu> {

  final controller = Get.find<DashBoardController>();
 // int selectedIndex = 0;// Toggle state

  final List<String> menuNames = [
    'Home',
    'Add News',
    'Trending News',
    'Manage Content',
    'Help',
  ];

  @override
  Widget build(BuildContext context) {
    double drawerWidth = controller.isExpanded ? 220 : 80;
    return Drawer(
      elevation: 0,
      width: drawerWidth,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: controller.isExpanded ? 220 : 80,
        decoration: const BoxDecoration(color: MyAppColor.secondaryBg),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: 35,
                  height: 20,
                  child: SvgPicture.asset('assets/dashboard/three_color.svg'),
                ),
              ),
            ),

            // Toggle Button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(controller.isExpanded ? Icons.chevron_left : Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    controller.isExpanded = !controller.isExpanded;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: menuNames.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected = controller.selectedDrawerIndex.value == index;
                    return GestureDetector(
                      onTap: () {
                        controller.selectedDrawerIndex.value = index;
                        switch (index) {
                          case 0:
                            appNav.navigateTo(AppRoutes.newsDashboard);
                            break;
                          case 1:
                            appNav.navigateTo(AppRoutes.addNews);
                            break;
                          case 2:
                            appNav.navigateTo(AppRoutes.addNews);
                            break;
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              menuIcons[index],
                              color: isSelected ? Colors.black : MyAppColor.iconGray,
                              height: 24,
                              width: 24,
                            ),
                            if (controller.isExpanded) ...[
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  menuNames[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.black : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
