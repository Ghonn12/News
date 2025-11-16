import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../utils/date_formatter.dart';
import '../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Good News',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildCategoryTabs(),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return _buildErrorState(controller.errorMessage.value);
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: Colors.black,
                onRefresh: controller.refreshNews,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: controller.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return _buildNewsCard(article);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================
  // CATEGORY TABS (Monokrom Minimalis)
  // ============================================
  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedCategory.value == category;

          return ChoiceChip(
            label: Text(
              category.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => controller.changeCategory(category),
            selectedColor: Colors.black,
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                width: 1,
              ),
            ),
          );
        },
      )),
    );
  }

  // ============================================
  // NEWS CARD (LAYOUT MONOKROM MINIMALIS)
  // ============================================
  Widget _buildNewsCard(article) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.detail, arguments: article),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==== Image Header ====
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.black54),
                  ),
                ),
              ),

            // ==== Text Body ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // DESCRIPTION
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // META INFO
                  Row(
                    children: [
                      if (article.author != null && article.author!.isNotEmpty)
                        Expanded(
                          child: Text(
                            article.author!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      const Icon(Icons.access_time,
                          size: 15, color: Colors.black54),
                      const SizedBox(width: 4),

                      Text(
                        DateFormatter.formatDate(article.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // EMPTY STATE
  // ============================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.article_outlined,
                size: 90, color: Colors.black45),
            SizedBox(height: 16),
            Text(
              'Tidak ada berita untuk ditampilkan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // ERROR STATE
  // ============================================
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 80, color: Colors.black),
            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, size: 18, color: Colors.black),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: controller.fetchNews,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // SEARCH DIALOG
  // ============================================
  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Cari Berita',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),

        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Masukkan kata kunci...',
            hintStyle: const TextStyle(color: Colors.black45),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Get.back();
              }
            },
            child: const Text('Cari', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
