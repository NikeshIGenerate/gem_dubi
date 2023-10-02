import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gem_dubi/common/models/local_notification.dart';
import 'package:gem_dubi/common/utils/local_db.dart';
import 'package:gem_dubi/common/utils/timeago.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isInit = true;
  List<GroupLocalNotification> _groupNotificationList = [];
  List<LocalNotification> _notificationList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      LocalDatabaseProvider.getAllNotifications(page: 1).then((list) {
        _notificationList = list;
        print('getAllNotifications data');
        print(jsonEncode(list.map((e) => e.toMap()).toList()));
        _processGroupNotifications();
      });
      _isInit = false;
    }
  }

  void _processGroupNotifications() {
    _groupNotificationList.clear();
    for (var element in _notificationList) {
      if (!_groupNotificationList.any((ele) => ele.date.isAtSameMomentAs(DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day)))) {
        var list = _notificationList
            .where((e) => DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day).isAtSameMomentAs(DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day)))
            .toList();
        _groupNotificationList.add(
          GroupLocalNotification(
            date: DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day),
            notifications: list,
          ),
        );
      }
    }
    _groupNotificationList.sort((a, b) => DateTime(b.date.year, b.date.month, b.date.day).compareTo(DateTime(a.date.year, a.date.month, a.date.day)));
    setState(() {});
  }

  Future<void> _refresh() async {
    _notificationList = await LocalDatabaseProvider.getAllNotifications(page: 1);
    print('getAllNotifications data');
    print(jsonEncode(_notificationList.map((e) => e.toMap()).toList()));
    _processGroupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _groupNotificationList.isNotEmpty
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(TimeAgoFormat.timeAgo(_groupNotificationList[index].date)),
                      const SizedBox(height: 20),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _groupNotificationList[index].notifications.length,
                        itemBuilder: (context, cIndex) {
                          var notification = _groupNotificationList[index].notifications[cIndex];
                          return Dismissible(
                            key: ValueKey(notification.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, size: 28),
                            ),
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                bool isDelete = await LocalDatabaseProvider.deleteNotification(notification.id);
                                if(isDelete) {
                                  _groupNotificationList[index].notifications.removeAt(cIndex);
                                  if(_groupNotificationList[index].notifications.isEmpty) _groupNotificationList.removeAt(index);
                                  setState(() {});
                                }
                              }
                            },
                            confirmDismiss: (direction) {
                              return showDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                      'Do you really want to delete this notification ?',
                                      style: TextStyle(height: 1.5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Theme.of(context).cardColor,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  notification.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.body,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      DateFormat('hh:mm a').format(notification.createdAt),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 15);
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemCount: _groupNotificationList.length,
              ),
            )
          : const Center(
              child: Text('No Notifications'),
            ),
    );
  }
}
