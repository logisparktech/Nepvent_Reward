import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/InvoiceDetailModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

class InvoiceDetailWidget extends StatefulWidget {
  const InvoiceDetailWidget({
    super.key,
    required this.invoiceId,
  });

  final String invoiceId;

  @override
  State<InvoiceDetailWidget> createState() => _InvoiceDetailWidgetState();
}

class _InvoiceDetailWidgetState extends State<InvoiceDetailWidget> {
  Future _getInvoice() async {
    try {
      final Response response =
          await dio.get('${urls['getOneInvoice']!}/${widget.invoiceId}');
      final body = response.data['data'];
      InvoiceDetailModel invoiceDetailModel = InvoiceDetailModel();
      // Populate fields
      invoiceDetailModel.customerName = body['customer']['name'];
      invoiceDetailModel.invoiceNumber = body['invoiceNumber'];
      invoiceDetailModel.discount = body['discountPercent'].toStringAsFixed(2);
      invoiceDetailModel.tax = body['vat'];
      invoiceDetailModel.grandTotal = body['finalAmount'].toDouble();
      invoiceDetailModel.subTotal = body['subTotal'].toDouble();
      invoiceDetailModel.point = body['totalPoints'];
      invoiceDetailModel.date = body['invoiceDate'];

      // Populate the list of InvoiceDetail
      invoiceDetailModel.invDetail = (body['invoiceDetails'] as List)
          .map((detail) => InvoiceDetail()
            ..itemName = detail['itemName']
            ..qty = detail['quantity']
            ..amount = detail['totalAmount'].toDouble())
          .toList();

      return invoiceDetailModel;
    } on DioException catch (err) {
      debugPrint('Failed to fetch invoice: ${err.response?.statusCode}');
      return [];
    } catch (error) {
      debugPrint('Error Getting Invoice $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Invoice Detail '),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Leading icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => NotificationWidget(),
        //         ),
        //       );
        //     },
        //     icon: Icon(
        //       MdiIcons.bell,
        //       size: 30,
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getInvoice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFDD143D),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData && snapshot.data == null) {
                return Center(
                  child: Text('No invoice Detail Data Available'),
                );
              } else {
                final invoice = snapshot.data!;
                DateTime dateTime = DateTime.parse(invoice.date);
                String formattedDate =
                    DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      child: Container(
                        width: screen.width,
                        // height: 148,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFC8C5C5),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'INV${invoice.invoiceNumber}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF174184),
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          MdiIcons.handHeart,
                                          color: Color(0xFFDD153C),
                                          size: 20,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  6, 0, 0, 0),
                                          child: Text(
                                            invoice.point.toString(),
                                            style: TextStyle(
                                              fontFamily: 'Merriweather',
                                              color: Color(0xFF2B822B),
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                                child: Container(
                                  width: screen.width,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDFDEDE),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Invoice no.',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '#${invoice.invoiceNumber}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Date',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF57636C),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.max,
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Column(
                              //         mainAxisSize: MainAxisSize.max,
                              //         children: [
                              //           Text(
                              //             'Due date',
                              //             style: TextStyle(
                              //               fontFamily: 'Inter',
                              //               color: Color(0xFF14181B),
                              //               fontSize: 16,
                              //               letterSpacing: 0.0,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       Column(
                              //         mainAxisSize: MainAxisSize.max,
                              //         children: [
                              //           Text(
                              //             '01/11/2024',
                              //             style: TextStyle(
                              //               fontFamily: 'Inter',
                              //               color: Color(0xFF57636C),
                              //               letterSpacing: 0.0,
                              //               fontWeight: FontWeight.w500,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      child: Container(
                        width: screen.width,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFFC8C5C5),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Bill To:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFF14181B),
                                  fontSize: 16,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child: Text(
                                  invoice.customerName,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF57636C),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      child: Container(
                        width: screen.width,
                        // height: 143,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFC8C5C5),
                          ),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(12, 10, 12, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: screen.width / 3,
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF14181B),
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screen.width / 4,
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF14181B),
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screen.width / 4,
                                    child: Text(
                                      'Amt',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xFF14181B),
                                        fontSize: 16,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...invoice.invDetail.map(
                                (item) => Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: screen.width / 3,
                                      child: Text(
                                        item.itemName,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF57636C),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screen.width / 4,
                                      child: Text(
                                        item.qty.toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF57636C),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screen.width / 4,
                                      child: Text(
                                        'Rs ${item.amount}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF57636C),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 10),
                                child: Container(
                                  width: screen.width,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFDE7EB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          'SubTotal',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: Text(
                                          'Rs  ${invoice.subTotal}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      child: Container(
                        width: screen.width,
                        // height: 130,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFFC8C5C5),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Discount',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '${invoice.discount}%',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Tax',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '${invoice.tax}%',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Container(
                                  width: screen.width,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFDE7EB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          'Grand Total',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: Text(
                                          'Rs ${invoice.grandTotal}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          // Column(
          //   children: [
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          //       child: Container(
          //         width: screen.width,
          //         // height: 148,
          //         decoration: BoxDecoration(
          //           color: Color(0xFFF8F9FA),
          //           borderRadius: BorderRadius.circular(16),
          //           border: Border.all(
          //             color: Color(0xFFC8C5C5),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text(
          //                       'INV5668',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF174184),
          //                         fontSize: 18,
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w800,
          //                       ),
          //                     ),
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
          //                               6, 0, 0, 0),
          //                           child: Text(
          //                             '24',
          //                             style: TextStyle(
          //                               fontFamily: 'Merriweather',
          //                               color: Color(0xFF2B822B),
          //                               fontSize: 18,
          //                               letterSpacing: 0.0,
          //                               fontWeight: FontWeight.bold,
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
          //                 child: Container(
          //                   width: screen.width,
          //                   height: 2,
          //                   decoration: BoxDecoration(
          //                     color: Color(0xFFDFDEDE),
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           'Invoice no.',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           '#5665',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           'Date',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           '28/10/2024',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF57636C),
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           'Due date',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           '01/11/2024',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF57636C),
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          //       child: Container(
          //         width: screen.width,
          //         height: 44,
          //         decoration: BoxDecoration(
          //           color: Color(0xFFF8F9FA),
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(
          //             color: Color(0xFFC8C5C5),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Bill To:',
          //                 style: TextStyle(
          //                   fontFamily: 'Inter',
          //                   color: Color(0xFF14181B),
          //                   fontSize: 16,
          //                   letterSpacing: 0.0,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
          //                 child: Text(
          //                   'Client name',
          //                   style: TextStyle(
          //                     fontFamily: 'Inter',
          //                     color: Color(0xFF57636C),
          //                     letterSpacing: 0.0,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          //       child: Container(
          //         width: screen.width,
          //         // height: 143,
          //         decoration: BoxDecoration(
          //           color: Color(0xFFF8F9FA),
          //           borderRadius: BorderRadius.circular(16),
          //           border: Border.all(
          //             color: Color(0xFFC8C5C5),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsetsDirectional.fromSTEB(12, 10, 12, 0),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max,
          //             children: [
          //               Row(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   SizedBox(
          //                     width: screen.width / 3,
          //                     child: Text(
          //                       'Description',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF14181B),
          //                         fontSize: 16,
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       'Qty',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF14181B),
          //                         fontSize: 16,
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       'Amt',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF14181B),
          //                         fontSize: 16,
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   SizedBox(
          //                     width: screen.width / 3,
          //                     child: Text(
          //                       'Item 1',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       '2',
          //                       maxLines: 1,
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       'Rs 510',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   SizedBox(
          //                     width: screen.width / 3,
          //                     child: Text(
          //                       'Item 2',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       '4',
          //                       maxLines: 1,
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: screen.width / 4,
          //                     child: Text(
          //                       'Rs 1000',
          //                       style: TextStyle(
          //                         fontFamily: 'Inter',
          //                         color: Color(0xFF57636C),
          //                         letterSpacing: 0.0,
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
          //                 child: Container(
          //                   width: screen.width,
          //                   height: 38,
          //                   decoration: BoxDecoration(
          //                     color: Color(0xFFFDE7EB),
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.max,
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Padding(
          //                         padding: EdgeInsetsDirectional.fromSTEB(
          //                             10, 0, 0, 0),
          //                         child: Text(
          //                           'SubTotal',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: EdgeInsetsDirectional.fromSTEB(
          //                             0, 0, 10, 0),
          //                         child: Text(
          //                           'Rs 1510',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             fontSize: 14,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
          //       child: Container(
          //         width: screen.width,
          //         // height: 130,
          //         decoration: BoxDecoration(
          //           color: Color(0xFFF8F9FA),
          //           borderRadius: BorderRadius.circular(16),
          //           border: Border.all(
          //             color: Color(0xFFC8C5C5),
          //           ),
          //         ),
          //         child: Padding(
          //           padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.max,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           'Discount',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           '7%',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           'Tax',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisSize: MainAxisSize.max,
          //                       children: [
          //                         Text(
          //                           '2%',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          //                 child: Container(
          //                   width: screen.width,
          //                   height: 38,
          //                   decoration: BoxDecoration(
          //                     color: Color(0xFFFDE7EB),
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.max,
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Padding(
          //                         padding: EdgeInsetsDirectional.fromSTEB(
          //                             10, 0, 0, 0),
          //                         child: Text(
          //                           'Grand Total',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             color: Color(0xFF14181B),
          //                             fontSize: 16,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: EdgeInsetsDirectional.fromSTEB(
          //                             0, 0, 10, 0),
          //                         child: Text(
          //                           'Rs 1.585.5',
          //                           style: TextStyle(
          //                             fontFamily: 'Inter',
          //                             fontSize: 14,
          //                             letterSpacing: 0.0,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
