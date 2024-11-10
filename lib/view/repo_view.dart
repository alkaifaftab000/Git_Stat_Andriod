import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/model/repo_model.dart';
import 'package:git_stat/view/detailed_repo_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class RepoList extends StatefulWidget {
  const RepoList({super.key});

  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Gist> gists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGists();
  }

  Future<void> fetchGists() async {
    try {
      const String apiUrl = 'https://api.github.com/gists/public';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Gist> newGists =
            jsonResponse.map((gistJson) => Gist.fromJson(gistJson)).toList();

        setState(() {
          isLoading = false;
        });

        // Animate in each item one by one
        for (int i = 0; i < newGists.length; i++) {
          gists.add(newGists[i]);
          _listKey.currentState
              ?.insertItem(i, duration: const Duration(milliseconds: 150));
          // Add a small delay between each item insertion
          await Future.delayed(const Duration(milliseconds: 50));
        }
      } else {
        debugPrint('Failed with status code ${response.statusCode}');
        throw Exception('Failed to load gists');
      }
    } catch (e) {
      debugPrint('Error fetching gists: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildListItem(
      BuildContext context, int index, Animation<double> animation) {
    Gist gist = gists[index];
    Owner owner = gist.owner;
    String filename =
        gist.files.isNotEmpty ? gist.files.values.first.filename : 'No file';
    String type =
        gist.files.isNotEmpty ? gist.files.values.first.type : 'Unknown';
    String language = gist.files.isNotEmpty
        ? gist.files.values.first.language ?? 'N/A'
        : 'N/A';

    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GistDetailScreen(gist: gist),
              ),
            ),
            onLongPress: () => showGistDetails(gist),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(
                          color: const Color(0xFF6366F1),
                          width: 2,
                        ),
                      ),
                      child: Hero(
                        tag: 'avatar-${gist.id}',
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(owner.avatarUrl),
                        ),
                      ),
                    ),
                    title: Hero(
                      tag: 'username-${gist.id}',
                      child: Text(
                        owner.login,
                        style: AppText.popinsFont(
                          fontWt: FontWeight.bold,
                          size: 18,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.code,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                filename,
                                overflow: TextOverflow.ellipsis ,
                                style: AppText.popinsFont(
                                  size: 14,
                                  color: Colors.black54,

                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTag(type, Colors.blue),
                        const SizedBox(width: 10),
                        _buildTag(language, Colors.green),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            const Icon(Icons.comment,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              '${gist.comments}',
                              style: AppText.popinsFont(
                                size: 14,
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
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppText.popinsFont(
          size: 12,
          color: color,
          fontWt: FontWeight.w500,
        ),
      ),
    );
  }

  void showGistDetails(Gist gist) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xFF6366F1), size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Gist Details',
                      style: AppText.popinsFont(
                        fontWt: FontWeight.bold,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.fingerprint, 'ID', gist.id),
                _buildDetailRow(
                  Icons.public,
                  'Visibility',
                  gist.public ? 'Public' : 'Private',
                ),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Created',
                  gist.createdAt.substring(0, 10),
                ),
                _buildDetailRow(
                  Icons.update,
                  'Updated',
                  gist.updatedAt.substring(0, 10),
                ),
                _buildDetailRow(
                  Icons.description,
                  'Description',
                  gist.description ?? 'No description',
                ),
                _buildDetailRow(
                  Icons.comment,
                  'Comments',
                  gist.comments.toString(),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: AppText.popinsFont(
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppText.popinsFont(
                    size: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: AppText.popinsFont(
                    size: 16,
                    color: Colors.black87,
                    fontWt: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.public,
              size: 30,
            ),
            const SizedBox(width: 5),
            Text(
              'Gist List',
              style: AppText.popinsFont(fontWt: FontWeight.bold, size: 30),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Placeholder count for shimmer effect
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            title: Container(
                              height: 20,
                              color: Colors.grey.shade300,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Container(
                                  height: 14,
                                  width: 100,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(16),
              initialItemCount: gists.length,
              itemBuilder: (context, index, animation) {
                return _buildListItem(context, index, animation);
              },
            ),
    );
  }
}
