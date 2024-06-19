class Category {
  int? id;
  String? name;
  String? description;

  Category();

  Category.fromJson(Map<String, dynamic> json) {
    id = json['catId'];
    name = json['catName'];
    description = json['catDescription'];
  }

  Map<String, dynamic> toJson() {
    return {'catId': id, 'catName': name, 'catDescription': description};
  }
}
