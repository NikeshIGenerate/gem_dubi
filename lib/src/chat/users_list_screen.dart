import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/utils/string_extension.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/conversation_screen.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  bool _isSearch = false;
  final _searchTextEditingController = TextEditingController();

  List<ApprovedUsers> _userList = [];
  List<ApprovedUsers> _searchUserList = [];

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() {
      if (_searchTextEditingController.text.isNotEmpty) {
        startSearch();
      }
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      ref.read(messageControllerRef).fetchAllUsers().then((value) {
        _userList = ref.read(messageControllerRef).allUsersList;
        _userList.sort((a, b) => a.displayName.compareTo(b.displayName));
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  void startSearch() {
    _isSearch = true;
    _searchUserList = _userList.where((element) => element.displayName.toLowerCase().contains(_searchTextEditingController.text.toLowerCase())).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearch
            ? const Text('Select User')
            : TextFormField(
                controller: _searchTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Search Users',
                  fillColor: Colors.black,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchTextEditingController.clear();
                          _isSearch = false;
                          _searchUserList.clear();
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        centerTitle: false,
        actions: !_isSearch
            ? [
                IconButton(
                  onPressed: () {
                    startSearch();
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 10),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _isSearch = false;
                _searchUserList.clear();
                setState(() {
                  _isLoading = true;
                });
                await ref.refresh(messageControllerRef).fetchAllUsers();
                _userList = ref.read(messageControllerRef).allUsersList;
                _userList.sort((a, b) => a.displayName.compareTo(b.displayName));
                setState(() {
                  _isLoading = false;
                });
              },
              child: !_isSearch
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        final user = _userList[index];
                        String tagType = '';
                        final tagTypeArr = user.tagTypeName != null ? user.tagTypeName!.split('-') : <String>[];
                        if (user.tagTypeName != null) {
                          tagType = '${tagTypeArr[0].capitalize()} ${tagTypeArr[1].capitalize()}';
                        }
                        return ListTile(
                          onTap: () => onTapUser(user),
                          leading: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: user.image ?? '',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: tagType == 'Girl A'
                                          ? Colors.green
                                          : tagType == 'Girl B'
                                              ? Colors.blue
                                              : Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      user.displayName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            tagType,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                      itemCount: _userList.length,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        final user = _searchUserList[index];
                        String tagType = '';
                        final tagTypeArr = user.tagTypeName != null ? user.tagTypeName!.split('-') : <String>[];
                        if (user.tagTypeName != null) {
                          tagType = '${tagTypeArr[0].capitalize()} ${tagTypeArr[1].capitalize()}';
                        }
                        return ListTile(
                          onTap: () => onTapUser(user),
                          leading: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: user.image ?? '',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: tagType == 'Girl A'
                                          ? Colors.green
                                          : tagType == 'Girl B'
                                              ? Colors.blue
                                              : Colors.red,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      user.displayName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            tagType,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                      itemCount: _searchUserList.length,
                    ),
            ),
    );
  }

  void onTapUser(ApprovedUsers approvedUser) async {
    final user = ref.read(loginProviderRef).user;
    var participants = [
      ParticipantModel(
        id: approvedUser.id.toString(),
        email: approvedUser.email,
        displayName: approvedUser.displayName,
        phone: null,
        image: approvedUser.image,
        tagTypeId: approvedUser.tagTypeId,
        tagTypeName: approvedUser.tagTypeName,
      ),
      ParticipantModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        phone: user.phone,
        image: user.image,
        tagTypeId: user.tagTypeId,
        tagTypeName: user.tagTypeName,
      ),
    ];
    String convId = await ref.read(messageControllerRef).isConversationExists(participants);
    if (convId == '') {
      convId = await ref.read(messageControllerRef).createPrivateConversation(participants, user);
    }
    final conversationModel = await ref.read(messageControllerRef).getConversation(convId);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return ConversationScreen(
            conversationId: convId,
            conversationModel: conversationModel!,
          );
        },
      ),
    );
  }
}
