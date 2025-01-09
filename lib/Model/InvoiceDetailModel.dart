class InvoiceDetailModel {
  late String customerName;
  late String invoiceNumber;
  late String discount;
  late int tax;
  late double grandTotal;
  late double subTotal;
  late int point;
  late String date;
  late List<InvoiceDetail> invDetail;
}

class InvoiceDetail {
   late String itemName;
   late int qty;
   late double amount;
}