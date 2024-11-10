class Gist {
  final String url;
  final String forksUrl;
  final String commitsUrl;
  final String id;
  final String nodeId;
  final String gitPullUrl;
  final String gitPushUrl;
  final String htmlUrl;
  final Map<String, File> files;
  final bool public;
  final String createdAt;
  final String updatedAt;
  final String? description;
  final int comments;
  final String commentsUrl;
  final Owner owner;
  final bool truncated;

  Gist({
    required this.url,
    required this.forksUrl,
    required this.commitsUrl,
    required this.id,
    required this.nodeId,
    required this.gitPullUrl,
    required this.gitPushUrl,
    required this.htmlUrl,
    required this.files,
    required this.public,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.comments,
    required this.commentsUrl,
    required this.owner,
    required this.truncated,
  });

  factory Gist.fromJson(Map<String, dynamic> json) {
    var filesJson = json['files'] as Map<String, dynamic>;
    Map<String, File> files = {};
    filesJson.forEach((key, value) {
      files[key] = File.fromJson(value);
    });

    return Gist(
      url: json['url'],
      forksUrl: json['forks_url'],
      commitsUrl: json['commits_url'],
      id: json['id'],
      nodeId: json['node_id'],
      gitPullUrl: json['git_pull_url'],
      gitPushUrl: json['git_push_url'],
      htmlUrl: json['html_url'],
      files: files,
      public: json['public'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['description'],
      comments: json['comments'],
      commentsUrl: json['comments_url'],
      owner: Owner.fromJson(json['owner']),
      truncated: json['truncated'],
    );
  }
}

class File {
  final String filename;
  final String type;
  final String? language;
  final String rawUrl;
  final int size;

  File({
    required this.filename,
    required this.type,
    this.language,
    required this.rawUrl,
    required this.size,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      filename: json['filename'],
      type: json['type'],
      language: json['language'],
      rawUrl: json['raw_url'],
      size: json['size'],
    );
  }
}

class Owner {
  final String login;
  final int id;
  final String nodeId;
  final String avatarUrl;
  final String url;
  final String htmlUrl;
  final bool siteAdmin;

  Owner({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.url,
    required this.htmlUrl,
    required this.siteAdmin,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'],
      id: json['id'],
      nodeId: json['node_id'],
      avatarUrl: json['avatar_url'],
      url: json['url'],
      htmlUrl: json['html_url'],
      siteAdmin: json['site_admin'],
    );
  }
}
