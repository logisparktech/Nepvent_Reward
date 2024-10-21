class InvoiceModel {
  final String vendorName;
  final String invoiceNumber;
  final String tableName;
  final int discount;
  final int finalAmount;

  InvoiceModel({
    required this.vendorName,
    required this.discount,
    required this.tableName,
    required this.finalAmount,
    required this.invoiceNumber,
  });
}
