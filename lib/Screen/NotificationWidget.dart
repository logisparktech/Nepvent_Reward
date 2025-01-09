import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepvent_reward/Model/NotificationModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late String currentUserId;
  late Future _future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _getNotificationData();
  }

  Future _getNotificationData() async {
    currentUserId = await secureStorage.read(key: 'userID') ?? '';
    try {
      final Response response = await dio.get(urls['Notification']!);
      final body = response.data['data']['data'];
      debugPrint(" *********** Notification Body ***********  $body");

      List<NotificationModel> newNotificationData = [];
      body.forEach((item) {
        List<NotificationPicture> pictures =
            (item['notificationPicture'] as List)
                .map((pic) => NotificationPicture(
                      id: pic['_id'],
                      url: pic['url'],
                    ))
                .toList();

        newNotificationData.add(
          NotificationModel(
            id: item['_id'],
            notificationPicture: pictures,
            viewedUser: item['viewedUser'],
            title: item['title'],
            content: item['content'],
            date: DateTime.parse(item['date']),
            time: item['time'],
            redirectedUrl:
                item.containsKey('redirectedUrl') ? item['redirectedUrl'] : '',
          ),
        );
      });

      setState(() {
        notificationModel = newNotificationData;
      });

      // log('****** notification Data  ******* : $notificationModel');
    } catch (e) {
      print("Error Fetching notification data: $e");
    }
  }

  void _markAsSeen(String id) async {
    debugPrint('id :$id');
    debugPrint('current user :$currentUserId');
    try {
      final Response response =
          await dio.post('${urls['ViewNotification']}/$id/$currentUserId');
      if (response.statusCode == 201) {
        setState(() {
          notificationModel = notificationModel.map((notification) {
            if (notification.id == id) {
              notification.viewedUser.add(currentUserId);
            }
            return notification;
          }).toList();
        });
      }
    } on DioException catch (err) {
      debugPrint('notification View Dio Error :$err');
    } catch (err) {
      debugPrint('notification View Error :$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Notifications'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:  CircularProgressIndicator(
                  color: const Color(0xFFDD143D),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading notifications"));
            } else {
              return notificationModel.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_sharp,
                            color: Color(0xFFDD143D),
                          ),
                          Text(
                            "No Notification found",
                            style: TextStyle(
                              color: Color(0xFFDD143D),
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: notificationModel.length,
                      itemBuilder: (context, index) {
                        final notification = notificationModel[index];
                        final bool isSeen =
                            notification.viewedUser.contains(currentUserId);
                        String filterDate =
                            DateFormat.yMMMMEEEEd().format(notification.date);
                        DateTime dateTime =
                            DateFormat("HH:mm").parse(notification.time);

                        // Convert to 12-hour AM/PM format
                        String formatedTime =
                            DateFormat("hh:mm a").format(dateTime);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: GestureDetector(
                            onTap: () async{
                              if(notification.redirectedUrl.isNotEmpty) {
                                // Open URL when tapped
                                final Uri uri = Uri.parse(
                                    notification.redirectedUrl);
                                if (!await launchUrl(
                                  uri,
                                  mode: LaunchMode.platformDefault,
                                  // Open in external browser
                                  webViewConfiguration: const WebViewConfiguration(
                                    enableJavaScript: true,
                                    enableDomStorage: true,
                                  ),
                                )) {
                                  throw Exception(
                                      'Could not launch ${ notification.redirectedUrl}');
                                }
                              }
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              color:
                                  isSeen ? Colors.white : Colors.blue.shade50,
                              elevation: 4.0,
                              child: ExpansionTile(
                                leading: Icon(
                                  isSeen
                                      ? Icons.notifications
                                      : Icons.notifications_active,
                                  color: isSeen ? Colors.grey : Colors.blue,
                                ),
                                title: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSeen
                                        ? Colors.grey.shade700
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  ' $filterDate, $formatedTime',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12.0,
                                  ),
                                ),
                                onExpansionChanged: (isExpanded) {
                                  if (isExpanded && !isSeen) {
                                    setState(() {
                                      _markAsSeen(notification.id.toString());
                                    });
                                  }
                                },
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        notification
                                                .notificationPicture.isNotEmpty
                                            ? SizedBox(
                                                height: 120,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: notification
                                                      .notificationPicture
                                                      .length,
                                                  itemBuilder:
                                                      (context, picIndex) {
                                                    final pic = notification
                                                            .notificationPicture[
                                                        picIndex];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child: Image.network(
                                                          pic.url,
                                                          width:
                                                              screen.width - 65,
                                                          height: 300,
                                                          fit: BoxFit.contain,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        (loadingProgress.expectedTotalBytes ??
                                                                            1)
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Material(),
                                        SizedBox(height: 4.0),
                                        Text(
                                          notification.content,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
