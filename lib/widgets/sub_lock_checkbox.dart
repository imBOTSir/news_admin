import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_news_controller.dart';

class SubLockCheckboxes extends StatelessWidget {
  const SubLockCheckboxes({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNewsController controller = Get.find<AddNewsController>();

    void updateCheckboxes(String selected, bool value) {
      if (selected == 'Regular') {
        controller.isRegularLock.value = value;
      } else if (selected == 'Gold') {
        controller.isGoldLock.value = value;
      } else if (selected == 'Platinum') {
        controller.isPlatinumLock.value = value;
      }
    }

    return Obx(() => Column(
          children: [
            Text("Subscription Lock"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCheckbox("Regular", controller.isRegularLock.value,
                    (val) => updateCheckboxes('Regular', val!)),
                _buildCheckbox("Gold", controller.isGoldLock.value,
                    (val) => updateCheckboxes('Gold', val!)),
                _buildCheckbox("Platinum", controller.isPlatinumLock.value,
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
