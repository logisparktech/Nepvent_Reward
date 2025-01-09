import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/InvoiceModel.dart';
import 'package:nepvent_reward/Model/VendorModel.dart';
import 'package:nepvent_reward/Provider/NepventProvider.dart';
import 'package:nepvent_reward/Screen/InvoiceDetailWidget.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';
import 'package:provider/provider.dart';

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

  @override
  dispose() {
    super.dispose();
    // context.read<NepventProvider>().setVendor('');
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
            discount: item['discount'].toInt(),
            vendorName: item['name'],
            location: item['address'],
            description: '', phone: '',
            vId: '',
          ),
        );
      });
      setState(() {
        vendorName = newVendorData;
      });
    } catch (e) {
      print("Error Fetching vendor data: $e");
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
            discount: invoice['discountPercent'].toStringAsFixed(2),
            invoiceNumber: invoice['invoiceNumber'],
            finalAmount: invoice['finalAmount'].toInt(),
            totalPoints: invoice['totalPoints'].toInt(),
            invId: invoice['_id'],
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
    final vendorNames = context.watch<NepventProvider>().vendor;

    if (vendorNames != null) {
      if (vendorNames.isNotEmpty) {
        _selectedVendorName = vendorNames;
      }
    }
    Size screen = MediaQuery.sizeOf(context);
    bool isWeb = screen.width >= 900;
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                        context.read<NepventProvider>().setVendor('');
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
                        filterInvoiceData = snapshot.data!
                            .where((element) =>
                                element.vendorName.toLowerCase() ==
                                _selectedVendorName!.toLowerCase())
                            .toList();
                        debugPrint(' 🎦filterInvoiceData: $filterInvoiceData');
                      } else {
                        filterInvoiceData = snapshot.data!;
                      }

                      return filterInvoiceData == null ||
                              filterInvoiceData.isEmpty
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
                              ? _buildContainer(screen, filterInvoiceData)
                              : _buildForMobile(screen, filterInvoiceData);
                    }
                  },
                ),
              ),

              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         mainAxisSize: MainAxisSize.max,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Padding(
              //             padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 color: Color(0xFFDD153C),
              //                 shape: BoxShape.circle,
              //               ),
              //               child: Icon(
              //                 Icons.storefront_outlined,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //           Text(
              //             'Vendor Name',
              //             style: TextStyle(
              //               fontFamily: 'Inter',
              //               fontSize: 16,
              //               letterSpacing: 0.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //
              //       Row(
              //         mainAxisSize: MainAxisSize.max,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Padding(
              //             padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              //             child: Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 color: Color(0xFFDD153C),
              //                 shape: BoxShape.circle,
              //               ),
              //               child: Icon(
              //                 Icons.calendar_month_outlined,
              //                 color: Colors.white,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //           Text(
              //             '2080/09/14',
              //             style: TextStyle(
              //               fontFamily: 'Inter',
              //               letterSpacing: 0.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              //
              //
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              //   child: Container(
              //     width: screen.width,
              //     // height: 160,
              //     decoration: BoxDecoration(
              //       color: Color(0xFFF8F9FA),
              //       borderRadius: BorderRadius.circular(16),
              //       border: Border.all(
              //         color: Color(0xFFC8C5C5),
              //       ),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Padding(
              //             padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
              //             child: Text(
              //               '#5560',
              //               style: TextStyle(
              //                 fontFamily: 'Inter',
              //                 color: Color(0xFF174184),
              //                 fontSize: 18,
              //                 letterSpacing: 0.0,
              //                 fontWeight: FontWeight.w800,
              //               ),
              //             ),
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Container(
              //                 width: screen.width / 2,
              //                 color: Colors.greenAccent,
              //                 height: 100,
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(top: 30),
              //                   child: Column(
              //                     children: [
              //                       Padding(
              //                         padding: EdgeInsetsDirectional.fromSTEB(
              //                             0, 0, 0, 5),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.max,
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: [
              //                             Icon(
              //                               MdiIcons.percentOutline,
              //                               color: Color(0xFFDD153C),
              //                               size: 22,
              //                             ),
              //                             Padding(
              //                               padding:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       18, 0, 0, 0),
              //                               child: Column(
              //                                 mainAxisSize: MainAxisSize.max,
              //                                 children: [
              //                                   Text(
              //                                     'Discount -',
              //                                     style: TextStyle(
              //                                       fontFamily: 'Inter',
              //                                       fontSize: 16,
              //                                       letterSpacing: 0.0,
              //                                       fontWeight: FontWeight.w500,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             Padding(
              //                               padding:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       5, 0, 0, 0),
              //                               child: Column(
              //                                 mainAxisSize: MainAxisSize.max,
              //                                 children: [
              //                                   Text(
              //                                     '15%',
              //                                     // '${invoice.discount.toString()}%',
              //                                     style: TextStyle(
              //                                       fontFamily: 'Inter',
              //                                       color: Color(0xFF14181B),
              //                                       fontSize: 16,
              //                                       letterSpacing: 0.0,
              //                                       fontWeight: FontWeight.bold,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: EdgeInsetsDirectional.fromSTEB(
              //                             0, 5, 0, 0),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.max,
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.start,
              //                           children: [
              //                             Icon(
              //                               MdiIcons.cash,
              //                               color: Color(0xFFDD153C),
              //                               size: 22,
              //                             ),
              //                             Padding(
              //                               padding:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       8, 0, 0, 0),
              //                               child: Column(
              //                                 mainAxisSize: MainAxisSize.max,
              //                                 children: [
              //                                   Text(
              //                                     'Total Amt -',
              //                                     style: TextStyle(
              //                                       fontFamily: 'Inter',
              //                                       fontSize: 16,
              //                                       letterSpacing: 0.0,
              //                                       fontWeight: FontWeight.w500,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             Padding(
              //                               padding:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       5, 0, 0, 0),
              //                               child: Column(
              //                                 mainAxisSize: MainAxisSize.max,
              //                                 children: [
              //                                   Text(
              //                                     'Rs . 15000',
              //                                     // 'Rs ${invoice.finalAmount.toString()}',
              //                                     style: TextStyle(
              //                                       fontFamily: 'Inter',
              //                                       color: Color(0xFF14181B),
              //                                       fontSize: 16,
              //                                       letterSpacing: 0.0,
              //                                       fontWeight: FontWeight.bold,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //               Container(
              //                 width: screen.width / 2.5,
              //                 height: 100,
              //                 color: Colors.blue,
              //                 child: Column(
              //                   children: [
              //                     Row(
              //                       mainAxisSize: MainAxisSize.max,
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       children: [
              //                         Icon(
              //                           MdiIcons.handHeart,
              //                           color: Color(0xFFDD153C),
              //                           size: 20,
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               10, 0, 0, 0),
              //                           child: Text(
              //                             'Points',
              //                             style: TextStyle(
              //                               fontFamily: 'Inter',
              //                               fontSize: 16,
              //                               letterSpacing: 0.0,
              //                               fontWeight: FontWeight.w500,
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Row(
              //                       mainAxisSize: MainAxisSize.max,
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           '2000',
              //                           // invoice.totalPoints.toString(),
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Merryweather',
              //                             color: Color(0xFF248F24),
              //                             fontSize: 50,
              //                             letterSpacing: 0.0,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           ),
              //           InkWell(
              //             onTap: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => InvoiceDetailWidget(
              //               //       invoiceId: invoice.invId,
              //               //     ),
              //               //   ),
              //               // );
              //             },
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Text(
              //                   'Show More',
              //                   style: TextStyle(
              //                     fontFamily: 'Inter',
              //                     color: Color(0xFF14181B),
              //                     letterSpacing: 0.0,
              //                   ),
              //                 ),
              //                 Icon(
              //                   Icons.keyboard_arrow_right,
              //                   color: Color(0xFF14181B),
              //                   size: 26,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildContainer(Size screen, List filterInvoiceData) {
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

  Widget _buildForMobile(Size screen, List filterInvoiceData) {
    return SizedBox(
      height: screen.height / 1.55,
      child: ListView(
        children: List.generate(filterInvoiceData.length, (index) {
          final invoice = filterInvoiceData[index];
          debugPrint('Invoinc : $invoice');
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
            child: Container(
              width: screen.width,
              // height: 160,
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFC8C5C5),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text(
                        '#${invoice.invoiceNumber}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFF174184),
                          fontSize: 18,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 8, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        MdiIcons.percentOutline,
                                        color: Color(0xFFDD153C),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            18, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Discount -',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              '${invoice.discount.toString()}%',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0xFF14181B),
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        MdiIcons.cash,
                                        color: Color(0xFFDD153C),
                                        size: 22,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Total Amt -',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Rs ${invoice.finalAmount.toString()}',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0xFF14181B),
                                                fontSize: 16,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      MdiIcons.handHeart,
                                      color: Color(0xFFDD153C),
                                      size: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 0, 0),
                                      child: Text(
                                        'Points',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      invoice.totalPoints.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Merryweather',
                                        color: Color(0xFF248F24),
                                        fontSize: 50,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceDetailWidget(
                                  invoiceId: invoice.invId,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // Keeps the button's width compact
                            children: [
                              Text(
                                'Show More',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFF14181B),
                                  letterSpacing: 0.0,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xFF14181B),
                                size: 26,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
