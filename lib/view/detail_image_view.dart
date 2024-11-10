import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/model/image_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoDetailScreen extends StatefulWidget {
  final PhotoModel photo;
  const PhotoDetailScreen({super.key, required this.photo});
  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhotos = prefs.getStringList('saved_photos') ?? [];
    setState(() {
      _isSaved = savedPhotos.contains(widget.photo.id);
    });
  }

  Future<void> _saveImage() async {
    if (_isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image already saved!')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Download image
      final response = await http.get(Uri.parse(widget.photo.urls['regular']!));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Get app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${widget.photo.id}.jpg';
      final file = File('${appDir.path}/$fileName');

      // Save image to file
      await file.writeAsBytes(response.bodyBytes);

      // Save photo metadata
      final prefs = await SharedPreferences.getInstance();
      final savedPhotos = prefs.getStringList('saved_photos') ?? [];
      savedPhotos.add(widget.photo.id!);
      await prefs.setStringList('saved_photos', savedPhotos);

      // Save photo details
      final photoDetails = {
        'id': widget.photo.id,
        'url': widget.photo.urls['regular'],
        'photographer': widget.photo.user.name,
        'likes': widget.photo.likes,
        'downloads': widget.photo.downloads,
        'views': widget.photo.views,
        'savedAt': DateTime.now().toIso8601String(),
      };
      final savedPhotoDetails = prefs.getStringList('photo_details') ?? [];
      savedPhotoDetails.add(jsonEncode(photoDetails));
      await prefs.setStringList('photo_details', savedPhotoDetails);

      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Failed to save image: (Use Andriod app not work on the web)  ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton.icon(
        onPressed: _isSaving ? null : _saveImage,
        label: Text(
            _isSaved ? 'Bookmarked' : (_isSaving ? 'Saving...' : 'Bookmark'),
            style: AppText.popinsFont(
              fontWt: FontWeight.bold,
              size: 20,
              color: Colors.white,
            )),
        icon: const Icon(
          Icons.bookmark_add_rounded,
          color: Colors.white,
          size: 25,
        ),
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.cyan,
            minimumSize: const Size(250, 70)),
      ),
      appBar: AppBar(
        title: Text(
          widget.photo.user.name,
          style: AppText.popinsFont(
            fontWt: FontWeight.bold,
            size: 20,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Zoomable Image Section
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: 'photo${widget.photo.id}',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    widget.photo.urls['regular']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photographer Card
                  const SizedBox(height: 10),
                  Text('Pinch In and Out on the Image to Zoom ',
                      style: AppText.popinsFont()),
                  const SizedBox(height: 10),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photographer',
                            style: AppText.popinsFont(
                              fontWt: FontWeight.bold,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.people,
                            'Name',
                            widget.photo.user.name,
                          ),
                          if (widget.photo.user.social?.instagramUsername !=
                              null)
                            _buildInfoRow(
                              Icons.install_desktop,
                              'Instagram',
                              '@${widget.photo.user.social!.instagramUsername!}',
                            ),
                          if (widget.photo.user.social?.twitterUsername != null)
                            _buildInfoRow(
                              Icons.twelve_mp,
                              'Twitter',
                              '@${widget.photo.user.social!.twitterUsername!}',
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stats',
                            style: AppText.popinsFont(
                              fontWt: FontWeight.bold,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildStatsRow(
                            Icons.hearing,
                            'Likes',
                            '${widget.photo.likes ?? 0}',
                          ),
                          _buildStatsRow(
                            Icons.remove_red_eye,
                            'Views',
                            '${widget.photo.views ?? 0}',
                          ),
                          _buildStatsRow(
                            Icons.download,
                            'Downloads',
                            '${widget.photo.downloads ?? 0}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Technical Details Card
                  if (widget.photo.exif != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Camera Details',
                              style: AppText.popinsFont(
                                fontWt: FontWeight.bold,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.camera,
                              'Make',
                              widget.photo.exif!.make ?? 'N/A',
                            ),
                            _buildInfoRow(
                              Icons.camera_enhance,
                              'Model',
                              widget.photo.exif!.model ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppText.popinsFont(
                  fontWt: FontWeight.bold,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: AppText.popinsFont(
                  fontWt: FontWeight.normal,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppText.popinsFont(
                    fontWt: FontWeight.bold,
                    size: 16,
                  ),
                ),
                Text(
                  value,
                  style: AppText.popinsFont(
                    fontWt: FontWeight.normal,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
