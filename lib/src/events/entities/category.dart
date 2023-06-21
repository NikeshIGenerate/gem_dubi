import 'package:gem_dubi/common/converter/converter.dart';

class Category {
  final int id;
  final String name;
  final String slug;
  final int parent;
  final int count;

//<editor-fold desc="Data Methods">

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          slug == other.slug &&
          parent == other.parent &&
          count == other.count);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      slug.hashCode ^
      parent.hashCode ^
      count.hashCode;

  @override
  String toString() {
    return 'Category{ id: $id, name: $name, slug: $slug, parent: $parent, count: $count,}';
  }

  Category copyWith({
    int? id,
    String? name,
    String? slug,
    int? parent,
    int? count,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      parent: parent ?? this.parent,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent': parent,
      'count': count,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'].toString().to(),
      name: map['name'].toString().to(),
      slug: map['slug'].toString().to(),
      parent: map['parent'].toString().to(),
      count: map['count'].toString().to(),
    );
  }

//</editor-fold>
}
