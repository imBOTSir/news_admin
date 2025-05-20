import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/add_news_controller.dart';

class LanguageSelectionWidget extends StatelessWidget {
  final AddNewsController controller = Get.find<AddNewsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return GestureDetector(
            onTap: () => _showCountryDropdown(context),
            child: AbsorbPointer(
              child: TextField(
                controller: controller.languageController,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  hintText: 'Select Language',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down, // Downward arrow icon
                    color: Colors.black, // You can change the color as needed
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// country dialog
  void _showCountryDropdown(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            controller.resetFilter(); // Reset when dismissed with back button
            return true;
          },
          child: Center(
            // Forces dialog to be centered and respect size
            child: AlertDialog(
              title: const Text('Select Language'),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              content: Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                    maxWidth: 300, // Set a smaller width
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Search field for filtering countries
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (query) {
                              controller.searchLanguage(
                                  query); // Call the method to filter the list
                            },
                            decoration: const InputDecoration(
                              labelText: 'Search language',
                              hintText: 'Type language name...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 500,
                          height: 300,
                          child: Obx(() {
                            // Use filtered list only if searchQuery is not empty
                            final listToShow =
                            controller.searchLanguageQuery.value.isEmpty
                                ? controller.allLanguages
                                : controller.filteredLanguages;
                            return ListView.builder(
                              itemCount: listToShow.length,
                              itemBuilder: (context, index) {
                                final language = listToShow[index];
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: language.flagsUrl.endsWith('.svg')
                                          ? SvgPicture.network(
                                        language.flagsUrl,
                                        placeholderBuilder: (context) =>
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                          CircularProgressIndicator(
                                              strokeWidth: 1),
                                        ),
                                        height: 32,
                                        width: 32,
                                        fit: BoxFit.cover,
                                      )
                                          : CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(language.flagsUrl),
                                      ),
                                    ),
                                  ),
                                  title: Text(language.languageName),
                                  onTap: () {
                                    controller.selectedLanguage.value = language;
                                    controller.languageController.text =
                                        language.languageName;
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                );
              }),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.resetFilter(); // Reset when pressing close
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}