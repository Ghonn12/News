import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/detail_controller.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';

/// ======================================================
/// DETAIL VIEW – BLACK & WHITE MINIMAL NEWS DESIGN
/// Clean typography, high contrast, modern layout
/// ======================================================
class DetailView extends StatefulWidget {
  const DetailView({Key? key}) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<DetailController>();

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 150), () {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = controller.article;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeaderImage(article),
          _buildBodyContent(article),
        ],
      ),
    );
  }

  /// =======================
  /// HEADER IMAGE SECTION
  /// =======================
  SliverAppBar _buildHeaderImage(article) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.black),
        onPressed: Get.back,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: article.urlToImage ?? article.title,
          child: CachedNetworkImage(
            imageUrl: article.urlToImage ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black87,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image,
                  size: 60, color: Colors.black45),
            ),
          ),
        ),
      ),
    );
  }

  /// ============================
  /// CONTENT BODY (ARTICLE)
  /// ============================
  SliverToBoxAdapter _buildBodyContent(article) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(article.title),
                const SizedBox(height: 12),
                _buildMeta(article),
                const SizedBox(height: 24),
                const Divider(thickness: 1, color: Colors.black12),
                const SizedBox(height: 24),
                _buildDescription(article.description),
                const SizedBox(height: 20),
                _buildContent(article.content),
                const SizedBox(height: 28),
                _buildSourceLink(article.url),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// TITLE
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: Colors.black,
        fontFamily: 'Helvetica',
      ),
    );
  }

  /// META INFORMATION (author + date)
  Widget _buildMeta(article) {
    return Row(
      children: [
        if (article.author != null)
          Flexible(
            child: Text(
              article.author!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (article.author != null) const SizedBox(width: 8),
        const Icon(Icons.access_time_rounded,
            size: 16, color: Colors.black45),
        const SizedBox(width: 4),
        Text(
          DateFormatter.formatFullDate(article.publishedAt),
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  /// DESCRIPTION
  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) return const SizedBox();
    return Text(
      description,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black87,
        height: 1.6,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// CONTENT TEXT
  Widget _buildContent(String? content) {
    if (content == null || content.isEmpty) return const SizedBox();
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.7,
      ),
    );
  }

  /// SOURCE LINK
  Widget _buildSourceLink(String? url) {
    if (url == null || url.isEmpty) return const SizedBox();
    return InkWell(
      onTap: controller.openSource,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black26, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.link_rounded,
                color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ACTION BUTTONS
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMinimalButton(Icons.share_rounded, 'Bagikan',
            controller.shareArticle),
        _buildMinimalButton(
            Icons.bookmark_add_outlined, 'Simpan', controller.bookmarkArticle),
      ],
    );
  }

  /// Minimalistic black-white button
  Widget _buildMinimalButton(
      IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
