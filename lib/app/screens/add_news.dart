import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:news_admin/controllers/add_news_controller.dart';
import 'package:news_admin/widgets/input_field.dart';
import '../../config/responsive.dart';
import '../../config/size_config.dart';
import '../../shared/utils/colors.dart';
import '../../widgets/country_selection_widget.dart';
import '../../widgets/header_action_items.dart';
import '../../widgets/image_selection_dialog.dart';
import '../../widgets/language_selection_dialog.dart';
import '../../widgets/news_checkbox_row.dart';
import '../../widgets/side_drawer_menu.dart';
import '../../widgets/sub_lock_checkbox.dart';
import '../../widgets/sub_tiers_checkbox.dart';
class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final controller = Get.put<AddNewsController>(AddNewsController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      key: controller.drawerKey,
      drawer: const SizedBox(width: 100, child: SideDrawerMenu()),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () =>
                    controller.drawerKey.currentState!.openDrawer(),
              ),
              actions: const [HeaderActionItems()],
            )
          : const PreferredSize(preferredSize: Size.zero, child: SizedBox()),
      // body: SafeArea(
      //   child: Row(
      //     children: [
      //       if (Responsive.isDesktop(context))
      //         const Expanded(flex: 2, child: SideDrawerMenu()),
      //
      //       // Main Content Area
      //       Expanded(
      //         flex: 10,
      //         child: Row(
      //           children: [
      //             /// Left Side: Editor
      //             Flexible(
      //               flex: 8,
      //               child: Container(
      //                 padding: const EdgeInsets.all(40),
      //                 color: Colors.white,
      //                 child: LayoutBuilder(
      //                   builder: (context, constraints) {
      //                     return Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           'Add News',
      //                           style: TextStyle(
      //                             fontSize: 30,
      //                             fontWeight: FontWeight.bold,
      //                             color: MyAppColor.primary,
      //                           ),
      //                         ),
      //                         const SizedBox(height: 20),
      //                         QuillSimpleToolbar(
      //                           controller: quillController,
      //                           config: const QuillSimpleToolbarConfig(),
      //                         ),
      //                         const SizedBox(height: 10),
      //                         SizedBox(
      //                           height: constraints.maxHeight - 200, // leaves bottom space
      //                           child: Container(
      //                             padding: const EdgeInsets.all(12),
      //                             decoration: BoxDecoration(
      //                               border: Border.all(color: Colors.grey.shade400),
      //                               borderRadius: BorderRadius.circular(10),
      //                               color: Colors.white,
      //                             ),
      //                             child: QuillEditor.basic(
      //                               controller: quillController,
      //                               config: const QuillEditorConfig(),
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //
      //             /// Right Side: Scrollable Form
      //             Flexible(
      //               flex: 6,
      //               child: SingleChildScrollView(
      //                 padding: const EdgeInsets.all(30),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     color: Colors.grey[50],
      //                     border: Border.all(color: Colors.grey.shade300),
      //                     borderRadius: BorderRadius.circular(12),
      //                   ),
      //                   padding: const EdgeInsets.all(20),
      //                   child: Form(
      //                     key: controller.formKey,
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         buildInput(controller.authorController, 'Author'),
      //                         const SizedBox(height: 16),
      //                         buildInput(controller.headingController, 'Heading'),
      //                         const SizedBox(height: 16),
      //                         NewsCheckboxRow(),
      //                         const SizedBox(height: 16),
      //                         buildInput(controller.descriptionController, 'Short Description'),
      //                         const SizedBox(height: 16),
      //                         LanguageSelectionWidget(),
      //                         const SizedBox(height: 16),
      //                         SubTierCheckboxes(),
      //                         const SizedBox(height: 16),
      //                         CountrySelectionWidget(),
      //                         const SizedBox(height: 16),
      //
      //                         DropdownButtonFormField<String>(
      //                           value: controller.selectedSubscriptionType,
      //                           decoration: const InputDecoration(
      //                             labelText: 'Subscription Type',
      //                             border: OutlineInputBorder(),
      //                           ),
      //                           items: controller.subscriptionTypes
      //                               .map((type) => DropdownMenuItem(
      //                             value: type,
      //                             child: Text(type),
      //                           ))
      //                               .toList(),
      //                           onChanged: (value) => setState(() {
      //                             controller.selectedSubscriptionType = value!;
      //                           }),
      //                         ),
      //                         const SizedBox(height: 16),
      //
      //                         CheckboxListTile(
      //                           title: const Text('Subscription Locked'),
      //                           value: controller.isLocked,
      //                           onChanged: (val) => setState(() => controller.isLocked = val ?? false),
      //                           controlAffinity: ListTileControlAffinity.leading,
      //                           contentPadding: EdgeInsets.zero,
      //                         ),
      //                         const SizedBox(height: 16),
      //
      //                         const Text(
      //                           'Thumbnail Preview',
      //                           style: TextStyle(fontWeight: FontWeight.w600),
      //                         ),
      //                         const SizedBox(height: 8),
      //                         Obx(() {
      //                           final selectedUrl = controller.selectedImageUrl.value;
      //                           return Row(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               Container(
      //                                 width: 200,
      //                                 height: 100,
      //                                 decoration: BoxDecoration(
      //                                   border: Border.all(color: Colors.grey.shade300),
      //                                   borderRadius: BorderRadius.circular(12),
      //                                   boxShadow: [
      //                                     BoxShadow(
      //                                       color: Colors.black.withOpacity(0.05),
      //                                       blurRadius: 6,
      //                                       offset: const Offset(0, 3),
      //                                     ),
      //                                   ],
      //                                 ),
      //                                 clipBehavior: Clip.antiAlias,
      //                                 child: selectedUrl.isEmpty
      //                                     ? TextButton.icon(
      //                                   onPressed: () {
      //                                     showDialog(
      //                                       context: context,
      //                                       builder: (_) => ImageSelectionDialog(controller: controller),
      //                                     );
      //                                     controller.fetchImagesFromBucket();
      //                                   },
      //                                   icon: const Icon(Icons.image),
      //                                   label: const Text('Select from Storage'),
      //                                 )
      //                                     : GestureDetector(
      //                                   onTap: () {
      //                                     showDialog(
      //                                       context: context,
      //                                       builder: (_) => ImageSelectionDialog(controller: controller),
      //                                     );
      //                                     controller.fetchImagesFromBucket();
      //                                   },
      //                                   child: Row(
      //                                     children: [
      //                                       ClipRRect(
      //                                         borderRadius: BorderRadius.circular(4),
      //                                         child: Image.network(
      //                                           selectedUrl,
      //                                           width: 40,
      //                                           height: 40,
      //                                           fit: BoxFit.cover,
      //                                         ),
      //                                       ),
      //                                       const SizedBox(width: 8),
      //                                       const Text('Change Image'),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           );
      //                         }),
      //
      //                         const SizedBox(height: 24),
      //                         SizedBox(
      //                           width: double.infinity,
      //                           child: ElevatedButton(
      //                             onPressed: () => controller.submitNews(context),
      //                             style: ElevatedButton.styleFrom(
      //                               backgroundColor: MyAppColor.primary,
      //                               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      //                             ),
      //                             child: const Text('Submit News'),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1000;

            return Row(
              children: [
                if (isDesktop) const Expanded(flex: 2, child: SideDrawerMenu()),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Editor
                              Flexible(
                                flex: 8,
                                child: _buildEditorSection(
                                    controller.quillController),
                              ),
                              const SizedBox(width: 16),

                              /// Form
                              Flexible(
                                flex: 6,
                                child: _buildFormSection(controller),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildEditorSection(controller.quillController),
                                const SizedBox(height: 24),
                                _buildFormSection(controller),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEditorSection(QuillController _controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add News',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: MyAppColor.primary,
            ),
          ),
          const SizedBox(height: 20),
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 400, maxHeight: 800),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: QuillEditor.basic(
                controller: _controller,
                config: const QuillEditorConfig(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(AddNewsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledInputField(
                  controller: controller.authorController,
                  label: 'Author',
                  context: context),
              const SizedBox(height: 16),
              LabeledInputField(
                  controller: controller.headingController,
                  label: 'Heading',
                  context: context),
              const SizedBox(height: 16),
              NewsCheckboxRow(),
              const SizedBox(height: 16),
              LabeledInputField(
                  controller: controller.descriptionController,
                  label: 'Short Description',
                  context: context),
              const SizedBox(height: 16),
              LanguageSelectionWidget(),
              const SizedBox(height: 16),
              SubTierCheckboxes(),
              const SizedBox(height: 16),
              CountrySelectionWidget(),
              const SizedBox(height: 16),
              SubLockCheckboxes(),
              const SizedBox(height: 24),
              const Text('Thumbnail Preview',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Obx(() {
                final selectedUrl = controller.selectedImageUrls;
                return Container(
                  width: double.infinity,
                  height: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedUrl.isEmpty
                      ? TextButton.icon(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  ImageSelectionDialog(controller: controller),
                            );
                            await controller.fetchImagesFromBucket();
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Select from Storage'),
                        )
                      : GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  ImageSelectionDialog(controller: controller),
                            );
                            await controller.fetchImagesFromBucket();
                          },
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedUrl.map((url) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      url,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              );
                            }).toList(),
                          )),
                );
              }),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reset Button
                  ElevatedButton.icon(
                    onPressed: () => controller.resetForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 1,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset'),
                  ),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: () => controller.submitNews(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
