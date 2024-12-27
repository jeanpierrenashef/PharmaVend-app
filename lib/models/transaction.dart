class Transaction {
  final int id;
  final int quantity;
  final double totalPrice;
  final int userId;
  final int machineId;
  final int productId;
  final String updatedAt;

  Transaction({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.userId,
    required this.machineId,
    required this.productId,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price'].toString()),
      userId: json['user_id'],
      machineId: json['machine_id'],
      productId: json['product_id'],
      updatedAt: json['updated_at'],
    );
  }
}
