import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/controller/image_controller.dart';
import 'package:git_stat/model/image_model.dart';
import 'package:git_stat/view/detail_image_view.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  final searchController = TextEditingController();
  final UnsplashService _unsplashService = UnsplashService();
  List<PhotoModel> _photos = [];
  bool _isLoading = true;

  Future<void> _loadPhotos(String query) async {
    setState(() => _isLoading = true);
    try {
      List<PhotoModel> photos =
          await _unsplashService.fetchPhotos(query, perPage: 30);
      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading photos: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPhotos('office');
  }

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Discover Images',
                        style: AppText.popinsFont(
                          fontWt: FontWeight.bold,
                          size: 25,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SearchBar(
                          controller: searchController,
                          textStyle: WidgetStateProperty.all(
                            AppText.popinsFont(
                              size: 18,
                              fontWt: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          hintStyle: WidgetStateProperty.all(
                            AppText.popinsFont(
                              size: 18,
                              fontWt: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          hintText: 'Search beautiful images...',
                          trailing: [
                            if (searchController.text.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  _loadPhotos('office');
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    _loadPhotos(searchController.text),
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) _loadPhotos('office');
                          },
                          onSubmitted: (value) {
                            _loadPhotos(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            _isLoading
                ? SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ss.width < 500
                            ? 1
                            : ss.width < 700
                                ? 2
                                : 4,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.9,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildShimmerCard(),
                        childCount: 10,
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ss.width < 500
                            ? 1
                            : ss.width < 700
                                ? 2
                                : 4,
                        mainAxisExtent: 270,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildPhotoCard(_photos[index]),
                        childCount: _photos.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 180,
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: 120, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 80, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 100, color: Colors.grey[300]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(PhotoModel photo) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoDetailScreen(photo: photo),
        ),
      ),
      child: Container(
        height: 200,
        width: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'photo ${photo.id}',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      photo.urls['regular']!,
                      height: 270,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(

                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.thumb_up,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${photo.likes}',
                          style: AppText.popinsFont(
                            size: 14,
                            fontWt: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            Positioned(


                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        photo.user.name,
                        style: AppText.popinsFont(
                          fontWt: FontWeight.bold,
                          size: 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${photo.views}',
                            style: AppText.popinsFont(
                              size: 14,
                              fontWt: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.download, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${photo.downloads}',
                            style: AppText.popinsFont(
                              size: 14,
                              fontWt: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ])
    )

    );
  }
}
