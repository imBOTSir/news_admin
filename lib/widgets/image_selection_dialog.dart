import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_news_controller.dart';

// class ImageSelectionDialog extends StatelessWidget {
//   final AddNewsController controller;
//
//   const ImageSelectionDialog({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(20),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Obx(() {
//         return SizedBox(
//           width: 600, // small fixed width
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Top Row with Title and Close Button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Select Thumbnail',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               SizedBox(
//                 height: 350, // Set height so the grid is scrollable
//                 child: controller.isImageLoading.value
//                     ? const Center(child: CircularProgressIndicator())
//                     : controller.imageUrls.isEmpty
//                     ? const Center(child: Text("No images found in storage."))
//                     : GridView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: controller.imageUrls.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                   ),
//                   itemBuilder: (_, index) {
//                     final url = controller.imageUrls[index];
//                     final isSelected = controller.selectedImageUrl.value == url;
//
//                     return GestureDetector(
//                       onTap: () {
//                         controller.selectedImageUrl(url);
//                       },
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: Image.network(
//                               url,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                           if (isSelected)
//                             Positioned(
//                               top: 4,
//                               right: 4,
//                               child: const Icon(Icons.check_circle, color: Colors.green),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               if (controller.selectedImageUrl.value.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       controller.imageUrl?.value = controller.selectedImageUrl.value;
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


class ImageSelectionDialog extends StatelessWidget {
  final AddNewsController controller;

  const ImageSelectionDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Obx(() {
        return SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Thumbnails',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Grid
              SizedBox(
                height: 350,
                child: controller.isImageLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.imageUrls.isEmpty
                    ? const Center(child: Text("No images found in storage."))
                    : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.imageUrls.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (_, index) {
                    final url = controller.imageUrls[index];
                    final isSelected = controller.selectedImageUrls.contains(url);

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedImageUrls.remove(url);
                        } else {
                          controller.selectedImageUrls.add(url);
                        }
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: const Icon(Icons.check_circle, color: Colors.green),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Submit selected images
              // Preview of selected images
              if (controller.selectedImageUrls.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedImageUrls.length,
                      itemBuilder: (_, index) {
                        final url = controller.selectedImageUrls[index];
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  url,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Optional: remove icon
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedImageUrls.remove(url);
                                },
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.imageUrl.addAll(controller.selectedImageUrls);
                    controller.selectedImageUrls.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Add Selected Images'),
                ),
              ],


              // OR Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              // Add Custom Image Button
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    controller.pickImageWeb(); // Define in your controller
                  },
                  child: const Text("Add Custom Image"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}




