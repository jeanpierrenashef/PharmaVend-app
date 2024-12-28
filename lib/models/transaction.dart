class Transaction {
  final int id;
  final int quantity;
  final double totalPrice;
  final int userId;
  final int machineId;
  final int productId;
  final String updatedAt;
  final int dispensed;

  Transaction({
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.userId,
    required this.machineId,
    required this.productId,
    required this.updatedAt,
    required this.dispensed,
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
      dispensed: json['dispensed'],
    );
  }

  Transaction copyWith({
    int? id,
    int? quantity,
    double? totalPrice,
    int? userId,
    int? machineId,
    int? productId,
    String? updatedAt,
    int? dispensed,
  }) {
    return Transaction(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      userId: userId ?? this.userId,
      machineId: machineId ?? this.machineId,
      productId: productId ?? this.productId,
      updatedAt: updatedAt ?? this.updatedAt,
      dispensed: dispensed ?? this.dispensed,
    );
  }
}
