import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nepvent_reward/Model/InvoiceModel.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class ClaimsWidget extends StatefulWidget {
  const ClaimsWidget({
    super.key,
  });

  @override
  State<ClaimsWidget> createState() => _ClaimsWidgetState();
}

class _ClaimsWidgetState extends State<ClaimsWidget> {
  String? _selectedVendorName;

  List<VendorModel> vendorName = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getVendorData();
    _getInvoiceData();
    // _selectedVendorName
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
            description: '', phone: '',
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

  Future<List<InvoiceModel>> _getInvoiceData() async {
    try {
      final Response response = await dio.get(urls['GetInvoice']!);

      List<InvoiceModel> newInvoiceData = [];
      for (var invoice in response.data['data']['invoices']) {
        newInvoiceData.add(
          InvoiceModel(
            vendorName: invoice['vendor']['name'],
            tableName: invoice['tableName']??'',
            discount: invoice['discountPercent'],
            invoiceNumber: invoice['invoiceNumber'],
            finalAmount: invoice['finalAmount'],
          ),
        );
      }
      return newInvoiceData;
    } catch (error) {
      debugPrint('Error Getting Invoice $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // _updateFilteredVendor();
    Size screen = MediaQuery.sizeOf(context);
    bool isWeb = screen.width >= 900;
    return Scaffold(
      backgroundColor: Colors.white,
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
                  color: Color(0xFFD2D7DE),
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
                  size: 20,
                ),
                // dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                elevation: 1,
                underline: Container(
                  height: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<InvoiceModel>>(
              future: _getInvoiceData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFFDD143D),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<InvoiceModel> filterInvoiceData = [];
                  if (_selectedVendorName != null) {
                    filterInvoiceData = filterInvoiceData
                        .where((element) =>
                            element.vendorName.toLowerCase() ==
                            _selectedVendorName!.toLowerCase())
                        .toList();
                  } else {
                    filterInvoiceData = snapshot.data!;
                  }

                  return filterInvoiceData == null || filterInvoiceData.isEmpty
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
                          ? buildContainer(screen, filterInvoiceData)
                          : buildForMobile(screen, filterInvoiceData);
                }
              },
            ),
          ),
        ],
      )),
    );
  }

  Container buildContainer(Size screen, List filterInvoiceData) {
    return Container(
      width: screen.width,
      decoration: BoxDecoration(
        // color: Colors.greenAccent,
        border: Border.all(color: Color(0xFFD2D7DE)),
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
        rows: filterInvoiceData.map((invoice) {
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

  Widget buildForMobile(Size screen, List filterInvoiceData) {
    return SizedBox(
      height: screen.height / 1.41,
      child: ListView(
        children: List.generate(filterInvoiceData.length, (index) {
          final invoice =
              filterInvoiceData[index]; // Get the invoice at the current index
          return Container(
            width: screen.width,

            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD2D7DE)),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            // Add some space between items
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
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
