class LanguageModel {
  final int idLanguage;
  final int countryId;
  final String languageName;
  final bool isActive;
  final String nicename;
  final String localLanguageName;
  final bool profileSettings;
  final bool forNews;
  final int userId;
  final String createdDate;
  final String lastUpdatedDate;
  final String flagsUrl;

  LanguageModel({
    required this.idLanguage,
    required this.countryId,
    required this.languageName,
    required this.isActive,
    required this.nicename,
    required this.localLanguageName,
    required this.profileSettings,
    required this.forNews,
    required this.userId,
    required this.createdDate,
    required this.lastUpdatedDate,
    required this.flagsUrl,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      idLanguage: json['idlanguage'] ?? 0,
      countryId: json['countryid'] ?? 0,
      languageName: json['languagename'] ?? '',
      isActive: json['isactive'] ?? false,
      nicename: json['nicename'] ?? '',
      localLanguageName: json['locallanguagename'] ?? '',
      profileSettings: json['profilesettings'] ?? false,
      forNews: json['fornews'] ?? false,
      userId: json['userid'] ?? 0,
      createdDate: json['createddate'] ?? '',
      lastUpdatedDate: json['lastupdateddate'] ?? '',
      flagsUrl: json['flagsurl'] ?? '',
    );
  }
}
