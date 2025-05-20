import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_news_controller.dart';

class SubTierCheckboxes extends StatelessWidget {
  const SubTierCheckboxes({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNewsController controller = Get.find<AddNewsController>();

    void updateCheckboxes(String selected, bool value) {
      if (selected == 'Regular') {
        controller.isRegular.value = value;
        controller.isGold.value = value;
        controller.isPlatinum.value = value;
      } else if (selected == 'Gold') {
        controller.isRegular.value = false;
        controller.isGold.value = value;
        controller.isPlatinum.value = value;
      } else if (selected == 'Platinum') {
        controller.isRegular.value = false;
        controller.isGold.value = false;
        controller.isPlatinum.value = value;
      }
    }

    return Obx(() => Column(
          children: [
            Text("Subscription Type"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCheckbox("Regular", controller.isRegular.value,
                    (val) => updateCheckboxes('Regular', val!)),
                _buildCheckbox("Gold", controller.isGold.value,
                    (val) => updateCheckboxes('Gold', val!)),
                _buildCheckbox("Platinum", controller.isPlatinum.value,
                    (val) => updateCheckboxes('Platinum', val!)),
              ],
            ),
          ],
        ));
  }

  Widget _buildCheckbox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(title),
        const SizedBox(width: 12),
      ],
    );
  }
}
