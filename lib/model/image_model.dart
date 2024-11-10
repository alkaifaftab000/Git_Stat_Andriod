class PhotoModel {
  final String? id;
  final String? slug; // Made nullable
  final String? description;
  final String? altDescription;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, String> urls;
  final int? likes;
  final int? views;
  final int? downloads;
  final User user;
  final Location? location;
  final Exif? exif;

  PhotoModel({
    this.id,
    this.slug, // Nullable
    this.description,
    this.altDescription,
    this.createdAt,
    this.updatedAt,
    required this.urls,
    this.likes,
    this.views,
    this.downloads,
    required this.user,
    this.location,
    this.exif,
  });

  // Factory method to convert JSON into PhotoModel object
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '', // Default empty string if null
      description: json['description'] ?? '', // Default empty string if null
      altDescription:
          json['alt_description'] ?? '', // Default empty string if null
      createdAt: json['created_at'] ?? '', // Default empty string if null
      updatedAt: json['updated_at'] ?? '', // Default empty string if null
      urls: Map<String, String>.from(json['urls'] ?? {}),
      likes: json['likes'] ?? 0, // Default zero if null
      views: json['views'] ?? 0, // Default zero if null
      downloads: json['downloads'] ?? 0, // Default zero if null
      user: User.fromJson(json['user']),
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      exif: json['exif'] != null ? Exif.fromJson(json['exif']) : null,
    );
  }
}

class User {
  final String id;
  final String username;
  final String name;
  final String? portfolioUrl; // Made nullable
  final String? bio;
  final Social? social;

  User({
    required this.id,
    required this.username,
    required this.name,
    this.portfolioUrl, // Nullable
    this.bio,
    this.social,
  });

  // Factory method to convert JSON into User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      portfolioUrl: json['portfolio_url'], // Nullable
      bio: json['bio'] ?? '',
      social: json['social'] != null ? Social.fromJson(json['social']) : null,
    );
  }
}

class Social {
  final String? instagramUsername;
  final String? twitterUsername;

  Social({
    this.instagramUsername,
    this.twitterUsername,
  });

  // Factory method to convert JSON into Social object
  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      instagramUsername: json['instagram_username'],
      twitterUsername: json['twitter_username'],
    );
  }
}

class Location {
  final String? name;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;

  Location({
    this.name,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
  });

  // Factory method to convert JSON into Location object
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      city: json['city'],
      country: json['country'],
      latitude: json['position'] != null
          ? json['position']['latitude']?.toDouble()
          : null,
      longitude: json['position'] != null
          ? json['position']['longitude']?.toDouble()
          : null,
    );
  }
}

class Exif {
  final String? make;
  final String? model;
  final String? exposureTime;
  final String? aperture;
  final String? focalLength;
  final String? iso;

  Exif({
    this.make,
    this.model,
    this.exposureTime,
    this.aperture,
    this.focalLength,
    this.iso,
  });

  // Factory method to convert JSON into Exif object
  factory Exif.fromJson(Map<String, dynamic> json) {
    return Exif(
      make: json['make'],
      model: json['model'],
      exposureTime: json['exposure_time'],
      aperture: json['aperture'],
      focalLength: json['focal_length'],
      iso: json['iso'],
    );
  }
}
