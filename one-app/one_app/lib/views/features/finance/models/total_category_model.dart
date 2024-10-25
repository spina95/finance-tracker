class TotalCategory {
  int categoryId;
  String categoryName;
  String? categoryColor;
  String? categoryIcon;
  String? categoryIconFlutter;
  double? totalAmount;

  TotalCategory({
    required this.categoryId,
    required this.categoryName,
    this.categoryColor,
    this.categoryIcon,
    this.categoryIconFlutter,
    this.totalAmount,
  });

  factory TotalCategory.fromJson(Map<String, dynamic> json) {
    return TotalCategory(
      categoryId: json['category_id'],
      categoryName: json["category_name"],
      categoryColor: json["category_color"],
      categoryIcon: json["category_icon"],
      categoryIconFlutter: json["category_icon_flutter"],
      totalAmount: json["total_amount"]?.toDouble(),
    );
  }
}
