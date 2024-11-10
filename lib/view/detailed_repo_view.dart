import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_color.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/model/repo_model.dart';
import 'package:intl/intl.dart';

class GistDetailScreen extends StatelessWidget {
  final Gist gist;

  const GistDetailScreen({super.key, required this.gist});

  @override
  Widget build(BuildContext context) {
    Owner owner = gist.owner;
    String filename =
        gist.files.isNotEmpty ? gist.files.values.first.filename : 'No file';
    String type =
        gist.files.isNotEmpty ? gist.files.values.first.type : 'Unknown';
    String language = gist.files.isNotEmpty
        ? gist.files.values.first.language ?? 'N/A'
        : 'N/A';

    return Scaffold(
      backgroundColor: AppColor.backGroundAppColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.backGroundAppColor,
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wrap the avatar in a Hero widget
                  Hero(
                    tag: 'avatar-${gist.id}', // Unique tag using owner's login
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 102,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(owner.avatarUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Wrap the username in a Hero widget
                  Hero(
                    tag:
                        'username-${gist.id}', // Unique tag using owner's login
                    child: Material(
                      // Wrap with Material to preserve text style during animation
                      color: Colors.transparent,
                      child: Text(
                        owner.login,
                        style: AppText.popinsFont(
                            fontWt: FontWeight.bold, size: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rest of the content remains the same
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Card
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Description',
                                style: AppText.popinsFont(
                                  fontWt: FontWeight.bold,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            gist.description ?? 'No description available',
                            style: AppText.popinsFont(
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Statistics Card
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Statistics',
                                style: AppText.popinsFont(
                                  fontWt: FontWeight.bold,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            context,
                            Icons.public,
                            'Visibility',
                            gist.public ? 'Public' : 'Private',
                            Colors.blue,
                          ),
                          _buildStatRow(
                            context,
                            Icons.comment,
                            'Comments',
                            gist.comments.toString(),
                            Colors.green,
                          ),
                          _buildStatRow(
                            context,
                            Icons.calendar_today,
                            'Created',
                            DateFormat.yMMMd()
                                .format(DateTime.parse(gist.createdAt)),
                            Colors.orange,
                          ),
                          _buildStatRow(
                            context,
                            Icons.update,
                            'Updated',
                            DateFormat.yMMMd()
                                .format(DateTime.parse(gist.updatedAt)),
                            Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // File Details Card
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.folder,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'File Details',
                                style: AppText.popinsFont(
                                  fontWt: FontWeight.bold,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            context,
                            Icons.insert_drive_file,
                            'Filename',
                            filename,
                            Colors.indigo,
                          ),
                          _buildStatRow(
                            context,
                            Icons.code,
                            'Language',
                            language,
                            Colors.teal,
                          ),
                          _buildStatRow(
                            context,
                            Icons.category,
                            'Type',
                            type,
                            Colors.deepOrange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, IconData icon, String label,
      String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: AppText.popinsFont(fontWt: FontWeight.bold, size: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.popinsFont(
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
