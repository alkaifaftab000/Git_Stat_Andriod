import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_color.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPhotosScreen extends StatefulWidget {
  const SavedPhotosScreen({super.key});

  @override
  State<SavedPhotosScreen> createState() => _SavedPhotosScreenState();
}

class _SavedPhotosScreenState extends State<SavedPhotosScreen> {
  List<Map<String, dynamic>> savedPhotos = [];
  bool isLoading = true;
  String? appDocPath;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    setState(() {
      appDocPath = appDir.path;
    });
    await _loadSavedPhotos();
  }

  Future<void> _loadSavedPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photoDetails = prefs.getStringList('photo_details') ?? [];

      final List<Map<String, dynamic>> photos = [];
      for (String detail in photoDetails) {
        photos.add(json.decode(detail));
      }

      setState(() {
        savedPhotos = photos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load saved photos: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _removePhoto(String photoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove from saved_photos list
      final savedPhotoIds = prefs.getStringList('saved_photos') ?? [];
      savedPhotoIds.remove(photoId);
      await prefs.setStringList('saved_photos', savedPhotoIds);

      // Remove from photo_details
      final photoDetails = prefs.getStringList('photo_details') ?? [];
      photoDetails.removeWhere((detail) {
        final photo = json.decode(detail);
        return photo['id'] == photoId;
      });
      await prefs.setStringList('photo_details', photoDetails);

      // Delete the actual file
      if (appDocPath != null) {
        final file = File('$appDocPath/$photoId.jpg');
        if (await file.exists()) {
          await file.delete();
        }
      }

      setState(() {
        savedPhotos.removeWhere((photo) => photo['id'] == photoId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo removed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove photo: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildPhotoCard(Map<String, dynamic> photo) {
    if (appDocPath == null) {
      return const Card(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final file = File('$appDocPath/${photo['id']}.jpg');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo['photographer'],
                    style: AppText.popinsFont(
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${photo['likes']}',
                            style: AppText.popinsFont(
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                        onPressed: () => _removePhoto(photo['id']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (savedPhotos.isEmpty) {
      return Scaffold(
        backgroundColor: AppColor.backGroundAppColor,
        appBar: AppBar(
          title: Text(
            'Bookmark Images',
            style: AppText.popinsFont(fontWt: FontWeight.bold, size: 30),
          ),
          centerTitle: true,
          backgroundColor: AppColor.backGroundAppColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sentiment_very_dissatisfied_rounded,
                color: Colors.grey,
                size: 70,
              ),
              const SizedBox(height: 30),
              Text(
                'No Bookmark photos yet',
                style: AppText.popinsFont(
                  size: 18,
                  fontWt: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.backGroundAppColor,
      appBar: AppBar(
        title: Text(
          'Bookmark Images',
          style: AppText.popinsFont(fontWt: FontWeight.bold, size: 30),
        ),
        centerTitle: true,
        backgroundColor: AppColor.backGroundAppColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: savedPhotos.length,
        itemBuilder: (context, index) {
          return _buildPhotoCard(savedPhotos[index]);
        },
      ),
    );
  }
}