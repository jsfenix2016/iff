class VideoPresigned {
  late String modified;
  late String url;

  VideoPresigned({
    required this.modified,
    required this.url,
  });

  factory VideoPresigned.fromJson(Map<String, dynamic> json) {
    return VideoPresigned(
      modified: json['modified'],
      url: json['url'],
    );
  }
}
