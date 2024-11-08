import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepvent_reward/Model/NotificationModel.dart';
import 'package:nepvent_reward/Utils/Global.dart';
import 'package:nepvent_reward/Utils/Urls.dart';

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
      // debugPrint(" *********** Notification Body ***********  $body");

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
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        _markAsSeen(notification.id.toString());
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  notification.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isSeen)
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Icon(
                                MdiIcons.circle,
                                size: 10,
                                color: Color(0xFFD50032),
                              ),
                            ),
                        ],
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
