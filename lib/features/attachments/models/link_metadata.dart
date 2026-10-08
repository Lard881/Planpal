import '../../../core/db/app_database.dart';

/// Link metadata from URL preview
class LinkMetadata {
  final String url;
  final String? title;
  final String? description;
  final String? faviconUrl;
  final String? imageUrl;

  LinkMetadata({
    required this.url,
    this.title,
    this.description,
    this.faviconUrl,
    this.imageUrl,
  });

  factory LinkMetadata.fromJson(Map<String, dynamic> json) {
    return LinkMetadata(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      faviconUrl: json['favicon_url'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (faviconUrl != null) 'favicon_url': faviconUrl,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}
