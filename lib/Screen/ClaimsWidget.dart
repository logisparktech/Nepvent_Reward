import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Model/InvoiceModel.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class ClaimsWidget extends StatefulWidget {
  const ClaimsWidget({super.key});

  @override
  State<ClaimsWidget> createState() => _ClaimsWidgetState();
}

class _ClaimsWidgetState extends State<ClaimsWidget> {
  String? _selectedVendorName;

  List<VendorModel> vendorName = [];
  List<InvoiceModel> invoiceData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVendorData();
    _getInvoiceData();
  }

  _getVendorData() async {
    try {
      final Response response = await dio.get(urls['AllVendor']!);
      final body = response.data['data'];
      List<VendorModel> newVendorData = [];
      body['items'].forEach((item) {
        newVendorData.add(
          VendorModel(
            imageUrl: "",
            discount: item['discount'],
            vendorName: item['name'],
            location: item['address'],
          ),
        );
      });
      setState(() {
        vendorName = newVendorData;
      });
    } catch (e) {
      print("Error Fetching  vendor data: $e");
    }
  }

  _getInvoiceData() async {
    try {
      final Response response = await dio.get(urls['GetInvoice']!);
      // debugPrint(' data :  ${response.data}');
      List<InvoiceModel> newInvoiceData = [];
      for (var invoice in response.data['data']['invoices']) {
        newInvoiceData.add(
          InvoiceModel(
            vendorName: invoice['vendor']['name'],
            tableName: invoice['tableName'],
            discount: invoice['discountPercent'],
            invoiceNumber: invoice['invoiceNumber'],
            finalAmount: invoice['finalAmount'],
          ),
        );
      }
      setState(() {
        invoiceData = newInvoiceData;
      });
      debugPrint('Invoice Data :  $invoiceData');
    } catch (error) {
      debugPrint('Error Getting Invoice $error');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    bool isWeb = screen.width >= 900;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                // color:
                // const Color.fromARGB(255, 40, 40, 40),
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton(
                value: _selectedVendorName,
                items: vendorName
                    .map(
                      (emer) => DropdownMenuItem(
                        value: emer.vendorName,
                        child: Text(
                          emer.vendorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (dynamic value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedVendorName = value;
                  });
                },
                isExpanded: true,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                hint: Text(
                  'Filter by Vendor Name',
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFB3A194),
                  size: 20,
                ),
                // dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                elevation: 1,
                underline: Container(
                  height: 0,
                  color: const Color(0xFFB3A194),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: invoiceData == null && invoiceData.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_sharp,
                          color: Color(0xFFDD143D),
                        ),
                        Text(
                          "No claims found",
                          style: TextStyle(
                            color: Color(0xFFDD143D),
                          ),
                        )
                      ],
                    ),
                  )
                : isWeb
                    ? buildContainer(screen)
                    : buildForMobile(screen),
          ),
        ],
      )),
    );
  }

  Container buildContainer(Size screen) {
    return Container(
      width: screen.width,
      decoration: BoxDecoration(
        // color: Colors.greenAccent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'Invoice Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Table Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Discount(%)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Final Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        rows: invoiceData.map((invoice) {
          debugPrint('${invoice.tableName}');
          return DataRow(
            cells: [
              DataCell(
                Text(invoice.invoiceNumber),
              ),
              DataCell(
                Text(invoice.tableName),
              ),
              DataCell(
                Text(invoice.discount.toString()),
              ),
              DataCell(
                Text(invoice.finalAmount.toString()),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildForMobile(Size screen) {
    return SizedBox(
      height: screen.height / 1.41,
      child: ListView(
        children: List.generate(invoiceData.length, (index) {
          final invoice =
              invoiceData[index]; // Get the invoice at the current index
          return Container(
            width: screen.width,

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            // Add some space between items
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(invoice.invoiceNumber),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Table Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(invoice.tableName),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount(%)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(invoice.discount.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Final Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(invoice.finalAmount.toString()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
