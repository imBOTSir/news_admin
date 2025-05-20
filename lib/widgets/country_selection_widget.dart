import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_admin/controllers/add_news_controller.dart';

// class CountrySelectionWidget extends StatelessWidget {
//   final AddNewsController controller = Get.find<AddNewsController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           return GestureDetector(
//             onTap: () => _showCountryDropdown(context),
//             child: AbsorbPointer(
//               child: TextField(
//                 controller: controller.countryController,
//                 decoration: const InputDecoration(
//                   labelText: 'Country',
//                   hintText: 'Select Country',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(
//                     Icons.arrow_drop_down, // Downward arrow icon
//                     color: Colors.black, // You can change the color as needed
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
//
//   /// country dialog
//   void _showCountryDropdown(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async {
//             controller.resetSearch(); // Reset when dismissed with back button
//             return true;
//           },
//           child: Center(
//             // Forces dialog to be centered and respect size
//             child: AlertDialog(
//               title: const Text('Select Country'),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               content: Obx(() {
//                 if (controller.isLoading.value) {
//                   return const SizedBox(
//                     width: 100,
//                     height: 100,
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//
//                 return ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxHeight: 400,
//                     maxWidth: 300, // Set a smaller width
//                   ),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 4.0),
//                           child: Row(
//                             children: [
//                               Checkbox(
//                                 value: controller.areAllSelected(),
//                                 onChanged: (val) {
//                                   if (val == true) {
//                                     controller.selectAllCountries();
//                                   } else {
//                                     controller.deselectAllCountries();
//                                   }
//                                 },
//                               ),
//                               const Text("Select All"),
//                               const Spacer(),
//                               Obx(() => Text(
//                                     "${controller.selectedCountry.length} items selected",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w500),
//                                   )),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             onChanged: (query) {
//                               controller.searchCountry(query);
//                             },
//                             decoration: const InputDecoration(
//                               labelText: 'Search Country',
//                               hintText: 'Type country name...',
//                               border: OutlineInputBorder(),
//                               prefixIcon: Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 500,
//                           height: 300,
//                           child: Obx(() {
//                             final listToShow =
//                                 controller.searchQuery.value.isEmpty
//                                     ? controller.countryList
//                                     : controller.filteredCountryList;
//
//                             return ListView.builder(
//                               itemCount: listToShow.length,
//                               itemBuilder: (context, index) {
//                                 final country = listToShow[index];
//                                 final isSelected = controller.selectedCountry
//                                     .contains(country);
//
//                                 return ListTile(
//                                   leading: Checkbox(
//                                     value: isSelected,
//                                     onChanged: (val) {
//                                       controller
//                                           .toggleCountrySelection(country);
//                                     },
//                                   ),
//                                   title: Row(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(4),
//                                         child: SizedBox(
//                                           width: 32,
//                                           height: 32,
//                                           child: country.flagUrl
//                                                   .endsWith('.svg')
//                                               ? SvgPicture.network(
//                                                   country.flagUrl,
//                                                   placeholderBuilder:
//                                                       (context) =>
//                                                           const SizedBox(
//                                                     height: 20,
//                                                     width: 20,
//                                                     child:
//                                                         CircularProgressIndicator(
//                                                             strokeWidth: 1),
//                                                   ),
//                                                   height: 32,
//                                                   width: 32,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : CircleAvatar(
//                                                   backgroundImage: NetworkImage(
//                                                       country.flagUrl),
//                                                 ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(child: Text(country.nicename)),
//                                     ],
//                                   ),
//                                   onTap: () {
//                                     controller.toggleCountrySelection(country);
//                                   },
//                                 );
//                               },
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     controller.resetSearch(); // Reset when pressing close
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Close'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter_svg/flutter_svg.dart';

// Assume you already have your AddNewsController and Country model set up properly.

class CountrySelectionWidget extends StatelessWidget {
  final AddNewsController controller = Get.find<AddNewsController>();

  CountrySelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          controller.updateCountryControllerText();

          return GestureDetector(
            onTap: () => _showCountryDropdown(context),
            child: AbsorbPointer(
              child: TextField(
                controller: controller.countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  hintText: 'Select Country',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Country selection dialog
  void _showCountryDropdown(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            controller.resetSearch(); // Reset search on back button dismiss
            return true;
          },
          child: Center(
            child: AlertDialog(
              title: const Text('Select Country'),
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
                    maxWidth: 300,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: controller.areAllSelected(),
                                onChanged: (val) {
                                  if (val == true) {
                                    controller.selectAllCountries();
                                  } else {
                                    controller.deselectAllCountries();
                                  }
                                },
                              ),
                              const Text("Select All"),
                              const Spacer(),
                              Obx(() => Text(
                                    "${controller.selectedCountry.length} items selected",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (query) {
                              controller.searchCountry(query);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Search Country',
                              hintText: 'Type country name...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 500,
                          height: 300,
                          child: Obx(() {
                            final listToShow =
                                controller.searchQuery.value.isEmpty
                                    ? controller.countryList
                                    : controller.filteredCountryList;

                            return ListView.builder(
                              itemCount: listToShow.length,
                              itemBuilder: (context, index) {
                                final country = listToShow[index];
                                final isSelected = controller.selectedCountry
                                    .contains(country);

                                return ListTile(
                                  leading: Checkbox(
                                    value: isSelected,
                                    onChanged: (val) {
                                      controller
                                          .toggleCountrySelection(country);
                                    },
                                  ),
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: country.flagUrl
                                                  .endsWith('.svg')
                                              ? SvgPicture.network(
                                                  country.flagUrl,
                                                  placeholderBuilder:
                                                      (context) =>
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
                                                  backgroundImage: NetworkImage(
                                                      country.flagUrl),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(country.nicename)),
                                    ],
                                  ),
                                  onTap: () {
                                    controller.toggleCountrySelection(country);
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.resetSearch();
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
