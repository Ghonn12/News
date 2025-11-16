import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';

class DetailController extends GetxController {
  late ArticleModel article;

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as ArticleModel;
  }

  /// 🔗 Buka sumber artikel di browser
  void openSource() async {
    final url = article.url;
    if (url == null || url.isEmpty) {
      Get.snackbar(
        'Gagal',
        'URL artikel tidak tersedia',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka link artikel',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 📤 Share artikel (belum diimplementasikan)
  void shareArticle() {
    Get.snackbar(
      'Info',
      'Fitur share akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// 🔖 Bookmark artikel
  void bookmarkArticle() {
    Get.snackbar(
      'Info',
      'Artikel berhasil di-bookmark',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
