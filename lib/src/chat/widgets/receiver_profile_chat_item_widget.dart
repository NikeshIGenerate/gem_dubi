import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiverChatProfileWidget extends StatefulWidget {
  final ChatMessage message;

  const ReceiverChatProfileWidget({super.key, required this.message});

  @override
  State<ReceiverChatProfileWidget> createState() => _ReceiverChatProfileWidgetState();
}

class _ReceiverChatProfileWidgetState extends State<ReceiverChatProfileWidget> {
  bool _isReceiverOnline = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseFirestore.instance.collection('users-availability').doc(widget.message.user.id).collection('availability').snapshots().listen((event) async {
      if (event.docChanges.isNotEmpty) {
        final statusDoc = await FirebaseFirestore.instance.collection('users-availability').doc(widget.message.user.id).collection('availability').doc('status').get();
        if (statusDoc.exists) {
          final data = statusDoc.data();
          print('#### USER Status : ${data?['status']}');
          if (data != null) {
            // ignore: avoid_bool_literals_in_conditional_expressions
            _isReceiverOnline = data['status'];
          }
          if (mounted) setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: widget.message.replyTo != null ? 8 : 4),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.user.profileImage ?? '',
                    fit: BoxFit.cover,
                    width: 30,
                    height: 30,
                    errorWidget: (context, url, error) {
                      return Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        alignment: Alignment.center,
                        child: Text(
                          widget.message.user.firstName!.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_isReceiverOnline)
                const Positioned(
                  right: -5,
                  bottom: -2,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Color.fromRGBO(28, 255, 23, 1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.message.user.firstName} ${widget.message.user.lastName}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 3),
              Text(
                DateFormat('HH:mm').format(widget.message.createdAt),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}
