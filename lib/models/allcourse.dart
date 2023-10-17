class Module {
  final String id;
  final String title;
  final String description;
  final List<String> videoUrls;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrls,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    List<String> videoUrls = (json['video'] as List)
        .map((videoJson) => videoJson['path'] as String) // Cast to String
        .toList();

    return Module(
      id: json['_id'],
      title: json['module_title'],
      description: json['module_description'],
      videoUrls: videoUrls,
    );
  }
}
