class DataModel {
  int? id;
  String brand;
  String name;
  String description;

  DataModel(
      {this.id,
      required this.brand,
      required this.name,
      required this.description});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      id: json["id"],
      brand: json["brand"],
      name: json["name"],
      description: json["description"]);

  Map<String, dynamic> toJson() =>
      {'id': id, 'brand': brand, 'name': name, 'description': description};
}
