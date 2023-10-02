class GirlTypeCategory {
  final int id;
  final String name;
  final String slug;

  GirlTypeCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory GirlTypeCategory.fromJson(Map<String, dynamic> json) {
    return GirlTypeCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
