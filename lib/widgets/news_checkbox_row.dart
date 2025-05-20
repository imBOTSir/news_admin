import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_admin/widgets/input_field.dart';

import '../controllers/add_news_controller.dart';
import '../models/model.dart';

class NewsCheckboxRow extends StatefulWidget {
  const NewsCheckboxRow({super.key});

  @override
  State<NewsCheckboxRow> createState() => _NewsCheckboxRowState();
}

class _NewsCheckboxRowState extends State<NewsCheckboxRow> {
  final AddNewsController controller = Get.find<AddNewsController>();



  final List<TrendingColor> availableTrendingColors = [
    TrendingColor(color: Colors.red, hexCode: colorToHex(Colors.red), name: 'Red'),
    TrendingColor(color: Colors.blue, hexCode: colorToHex(Colors.blue), name: 'Blue'),
    TrendingColor(color: Colors.green, hexCode: colorToHex(Colors.green), name: 'Green'),
    TrendingColor(color: Colors.orange, hexCode: colorToHex(Colors.orange), name: 'Orange'),
    TrendingColor(color: Colors.purple, hexCode: colorToHex(Colors.purple), name: 'Purple'),
    TrendingColor(color: Colors.yellow, hexCode: colorToHex(Colors.yellow), name: 'Yellow'),
  ];



  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20,
            children: [
              _buildCheckbox("Trending News", controller.isTrending.value, (val) {
                controller.isTrending.value = val!;
                if (!val) controller.selectedTrendingColor.value = null;
              }),
              _buildCheckbox("Bold News", controller.isBold.value, (val) {
                controller.isBold.value = val!;
              }),
              _buildCheckbox("Free News", controller.isFree.value, (val) {
                controller.isFree.value = val!;
                if (!val) controller.isFullFree.value = false;
              }),
            ],
          ),

          // Full Free Checkbox (only if Free is selected)
          if (controller.isFree.value)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8),
              child: _buildCheckbox("Full Free News", controller.isFullFree.value, (val) {
                controller.isFullFree.value = val!;
              }),
            ),

          // Color picker (only if Trending is selected)
          if (controller.isTrending.value)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                children: [
                  Text("Trending News Colors:"),
                  Wrap(
                    spacing: 10,
                    children: availableTrendingColors.map((colorItem) {
                      final isSelected = controller.selectedTrendingColor.value?.color == colorItem.color;
                      return GestureDetector(
                        onTap: () => controller.selectedTrendingColor.value = colorItem,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorItem.color,
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 10,),
                  LabeledInputField(controller: controller.trendingNewsHoursController, label: "Trending News Hours:", context: context),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title),
      ],
    );
  }
}

