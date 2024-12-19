import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'localization_service.dart';

class LocalizedTranslations extends Translations {

  @override
  Map<String, Map<String, String>> get keys => LocalizationService.getKeys();
}