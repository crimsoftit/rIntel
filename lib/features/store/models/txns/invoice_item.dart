class MainModel {
  final String title;
  final List<SubItem> items; // List field

  MainModel({required this.title, required this.items});

  // Deserialize JSON
  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      title: json['title'],
      items: (json['items'] as List)
          .map((i) => SubItem.fromJson(i)) // Convert each map to SubItem
          .toList(),
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class SubItem {
  final String name;
  final int id;

  SubItem({required this.name, required this.id});

  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
  };
}
