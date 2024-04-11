
class Ingredient {
  final String name;
  final int gram;
  final int kcal;
  final int protein;
  final int carbohydrates;
  final int fat;

  const Ingredient({
    required this.name,
    this.gram = 0,
    required this.kcal,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
  });

}