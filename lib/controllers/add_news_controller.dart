import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_admin/core/di/get_injector.dart';
import 'dart:html' as html;

import '../models/language_model.dart';
import '../models/model.dart';
import '../widgets/dialog_box/success_dialog.dart';

class AddNewsController extends GetxController {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  final TextEditingController newsIdController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController headingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController trendingNewsHoursController =
      TextEditingController();

  String selectedSubscriptionType = 'Regular';
  RxBool isLocked = false.obs;

  Uint8List? imageBytes;
  String? imageName;
  RxList<String> imageUrl = <String>[].obs;

  final List<String> subscriptionTypes = ['Regular', 'Gold', 'Platinum'];

  RxString selectedImageUrl = ''.obs;
  final isImageLoading = true.obs;

  RxList<String> selectedImageUrls = <String>[].obs;
  RxList<String> imageUrls = <String>[].obs;

  var countryList = <Country>[].obs;
  var isLoading = false.obs;

  RxList<Country?> selectedCountry = <Country?>[].obs;
  var filteredCountryList = <Country>[].obs;
  var countriesFetched = false.obs;
  var searchQuery = ''.obs;

  RxList<LanguageModel> allLanguages = <LanguageModel>[].obs;
  RxList<LanguageModel> filteredLanguages = <LanguageModel>[].obs;
  Rx<LanguageModel?> selectedLanguage = Rx<LanguageModel?>(null);

  var languagesFetched = false.obs;
  var searchLanguageQuery = ''.obs;

  QuillController quillController = QuillController.basic();

  RxBool isRegular = false.obs;
  RxBool isGold = false.obs;
  RxBool isPlatinum = false.obs;

  RxBool isTrending = false.obs;
  RxBool isBold = false.obs;
  RxBool isFree = false.obs;
  RxBool isFullFree = false.obs;

  final Rx<TrendingColor?> selectedTrendingColor = Rx<TrendingColor?>(null);

  RxBool isRegularLock = false.obs;
  RxBool isGoldLock = false.obs;
  RxBool isPlatinumLock = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchImagesFromBucket();
    fetchCountries();
    fetchLanguages();
  }

  Future<void> pickImageWeb() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    final fileCompleter = Completer<void>();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((event) {
        imageBytes = reader.result as Uint8List;
        imageName =
            'news_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        fileCompleter.complete();
      });
    });

    await fileCompleter.future;
  }

  @override
  void dispose() {
    newsIdController.dispose();
    authorController.dispose();
    headingController.dispose();
    descriptionController.dispose();
    languageController.dispose();
    countryController.dispose();
    super.dispose();
  }

  String getSubscriptionIds(
      {required bool regular, required bool gold, required bool platinum}) {
    final ids = <int>{};

    if (regular) ids.addAll([1, 2, 3]);
    if (gold) ids.addAll([2, 3]);
    if (platinum) ids.add(3);

    final sortedIds = ids.toList()..sort();
    return sortedIds.join(',');
  }

  String getSubscriptionLocks({
    required bool regular,
    required bool gold,
    required bool platinum,
  }) {
    final ids = <int>[
      if (regular) 1,
      if (gold) 2,
      if (platinum) 3,
    ];
    return ids.join(',');
  }

  /// submit news / adding news
  Future<void> submitNews(BuildContext context) async {
    print('submitNews called');

    final List<int?> countryIds =
        selectedCountry.map((country) => country?.id).toList();

    final String subIds = getSubscriptionIds(
        regular: isRegular.value,
        gold: isGold.value,
        platinum: isPlatinum.value);
    final String subLockIds = getSubscriptionLocks(
        regular: isRegularLock.value,
        gold: isGoldLock.value,
        platinum: isPlatinumLock.value);
    try {
      print('Inside try block');
      final String? thumbnailUrl = imageUrl.isNotEmpty ? imageUrl.first : null;

      final insertedList = await sbServices.client.from('news_feed').insert({
        'author': authorController.text,
        'news_html': "<p>${quillController.document.toPlainText().trim()}</p>",
        'news_plain': quillController.document.toPlainText().trim(),
        'subject': headingController.text,
        'thumbnail': thumbnailUrl,
        'news_date': DateTime.now().toIso8601String(),
        'created_on': DateTime.now().toIso8601String(),
        'updated_on': DateTime.now().toIso8601String(),
        'created_by': 234,
        // add user id here
        'updated_by': 0,
        'is_active': true,
        'views': 0,
        'can_download': true,
        'file_name': "",
        'file_path': "",
        'file_size': 0,
        'news_source': 0,
        'reason_to_delete': "",
        'short_description': descriptionController.text,
        'news_for_sub': subIds,
        'news_for_countries': countryIds,
        'preferredlanguage': "",
        'is_adm_verified': false,
        'adm_id_user': 234,
        // adm user id
        'adm_approve_dtm': DateTime.now().toIso8601String(),
        // add the admin approve DTM
        'adm_reject_remark': "",
        'is_sa_verified': false,
        "sa_id_user": 234,
        // sa user id"
        'sa_approve_dtm': DateTime.now().toIso8601String(),
        // add the sa approve DTM
        'sadm_reject_remark': "",
        'report_link': "",
        'news_favourite_count': 0,
        'language_id': selectedLanguage.value?.idLanguage,
        'news_for_lock': subLockIds,
        "published_on": DateTime.now().toIso8601String(),
        // published DTM
        'trending_news': isTrending.value,
        'send_notification': true,
        // notification sending flag
        'search_tag': descriptionController.text,
        // check what to send for search tag
        'trending_news_colour': selectedTrendingColor.value?.hexCode,
        // set the selected trending news color
        'trending_news_time_limit': trendingNewsHoursController.text,
        // set the trending news time limit
        'free_news': isFree.value,
        'show_fullfree_news': isFullFree.value,
      }).select();

      if (insertedList.isEmpty) {
        throw Exception("Insert failed: No row returned from news_feed.");
      }

      final newsResponse = insertedList.first;
      final int newsId = newsResponse['id'];

      // Upload images to Supabase
      await uploadImageToSupabase(newsId);

      // Add to local history
      newsUploadHistory.insert(
        0,
        NewsUploadHistory(
          newsId: newsId.toString(),
          thumbnailUrls: selectedImageUrls.toList(),
          title: headingController.text,
          time: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
          uploadedBy: 'Admin',
          status: 'Active',
          description: descriptionController.text,
          newsPlain: quillController.document.toPlainText().trim(),
          author: authorController.text,
        ),
      );

      // Reset form
      formKey.currentState!.reset();

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => SuccessDialog(),
      );
      selectedImageUrls.clear();
    } catch (e, stack) {
      print('Error in submitNews: $e');
      print('Stack trace: $stack');
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// Upload to Supabase Storage and save in `news_feed_media
  Future<void> uploadImageToSupabase(int newsId) async {
    try {
      for (int i = 0; i < selectedImageUrls.length; i++) {
        final imageUrl = selectedImageUrls[i];

        final insertResponse = await sbServices.client
            .from('news_feed_media')
            .insert({
              'id_news_feed': newsId,
              'created_on': DateTime.now().toIso8601String(),
              'created_by': 1,
              'update_on': DateTime.now().toIso8601String(),
              'updated_by': 1,
              'type_media': 'image',
              'name_of_media': 'image',
              'extension_of_media': 'jpg',
              'path_of_media': imageUrl,
              'size_of_media': 12,
              'is_active': true,
              'media_data': '',
              'uploaded_file_name': 'image.jpg',
              'isdefaultimage': i == 0, // first image is default
              'default_image_id': 0,
              'webimgpath': imageUrl,
              'mobimgpath': imageUrl,
              'imgflag': 1,
            })
            .select()
            .single();

        print("Media inserted for image $i: $insertResponse");
      }

      // Update thumbnail in news_feed using the first selected image
      if (selectedImageUrls.isNotEmpty) {
        await sbServices.client
            .from('news_feed')
            .update({'thumbnail': selectedImageUrls.first}).eq('id', newsId);

        print("News feed updated with thumbnail.");
      }
    } catch (e, stack) {
      print("Upload or insert failed: $e");
      print("Stack: $stack");
      rethrow;
    }
  }

  Future<void> fetchImagesFromBucket() async {
    isImageLoading.value = true;
    imageUrls.clear();

    try {
      final response = await sbServices.client.storage.from('images').list();

      final fetchedUrls = response
          .where((item) =>
              item.name.endsWith('.jpg') || item.name.endsWith('.png'))
          .map((item) =>
              sbServices.client.storage.from('images').getPublicUrl(item.name))
          .toList();

      imageUrls.assignAll(fetchedUrls);
    } catch (e) {
      imageUrls.clear();
    } finally {
      isImageLoading.value = false;
    }
  }

  /// fetch countries
  Future<void> fetchCountries() async {
    if (countriesFetched.value) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await sbServices.client.from('countries').select('*');

      final data = response as List;
      countryList.value = data.map((e) => Country.fromJson(e)).toList();

      if (kDebugMode) {
        print('Fetched countries: $response');
      }

      countriesFetched.value = true;
    } catch (e) {
      print("Exception fetching countries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// function to search the country
  void searchCountry(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCountryList.clear();
    } else {
      final result = countryList
          .where((country) =>
              country.nicename.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredCountryList.assignAll(result);
    }
  }

  /// reset the search field
  void resetSearch() {
    searchQuery.value = '';
    filteredCountryList.clear();
  }

  void toggleCountrySelection(Country country) {
    if (selectedCountry.contains(country)) {
      selectedCountry.remove(country);
    } else {
      selectedCountry.add(country);
    }
  }

  void selectAllCountries() {
    selectedCountry.assignAll(
        searchQuery.value.isEmpty ? countryList : filteredCountryList);
  }

  bool areAllSelected() {
    final list = searchQuery.value.isEmpty ? countryList : filteredCountryList;
    return list.isNotEmpty && list.every((c) => selectedCountry.contains(c));
  }

  void deselectAllCountries() {
    selectedCountry.clear();
  }

  void toggleSelectAll(bool selectAll) {
    if (selectAll) {
      selectedCountry.value = filteredCountryList.toList();
    } else {
      selectedCountry.clear();
    }
  }

  void toggleSelection(Country country, bool selected) {
    if (selected) {
      selectedCountry.add(country);
    } else {
      selectedCountry.remove(country);
    }
  }

  bool isAllSelected() {
    return selectedCountry.length == filteredCountryList.length;
  }

  /// function to fetch all the languages from supabase database
  Future<void> fetchLanguages() async {
    if (languagesFetched.value) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await sbServices.client.from('language').select('*');

      final data = response as List;
      allLanguages.value = data.map((e) => LanguageModel.fromJson(e)).toList();

      if (kDebugMode) {
        print('Fetched languages: $response');
      }

      languagesFetched.value = true;
    } catch (e) {
      print("Exception fetching languages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// function to search the language
  void searchLanguage(String query) {
    searchLanguageQuery.value = query;
    if (query.isEmpty) {
      filteredLanguages.clear();
    } else {
      final result = allLanguages
          .where((lang) =>
              lang.languageName.toLowerCase().contains(query.toLowerCase()) ||
              lang.nicename.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredLanguages.assignAll(result);
    }
  }

  /// reset the language search field
  void resetFilter() {
    searchLanguageQuery.value = '';
    filteredLanguages.clear();
  }

  /// function to reset the add news form
  void resetForm() {
    authorController.clear();
    headingController.clear();
    descriptionController.clear();
    selectedSubscriptionType = subscriptionTypes.first;
    isLocked.value = false;
    selectedImageUrls.clear();
    // Reset the Quill editor
    quillController.document = Document();
    // reset the country and language field controller
    countryController.clear();
    languageController.clear();
    // Reset the  subscription type checkboxes
    isRegular.value = false;
    isGold.value = false;
    isPlatinum.value = false;
    // Reset the news type checkboxes
    isTrending.value = false;
    isBold.value = false;
    isFree.value = false;
    isFullFree.value = false;
  }

  /// Helper to update the TextEditingController text based on selected countries
  void updateCountryControllerText() {
    final selected = selectedCountry;
    if (selected.isEmpty) {
      countryController.text = '';
    } else if (selected.length <= 4) {
      countryController.text = selected.map((c) => c?.nicename).join(', ');
    } else {
      countryController.text = '${selected.length} countries selected';
    }
  }
}
