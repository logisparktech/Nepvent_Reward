class InvoiceModel {
  final String invId;
  final String vendorName;
  final String invoiceNumber;
  final String tableName;
  final String discount;
  final int finalAmount;
  final int totalPoints;

  InvoiceModel({
    required this.invId,
    required this.vendorName,
    required this.discount,
    required this.tableName,
    required this.finalAmount,
    required this.invoiceNumber,
    required this.totalPoints,
  });
}
