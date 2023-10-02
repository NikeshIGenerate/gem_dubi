import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/girl_type_category.dart';
import 'package:gem_dubi/src/chat/entities/local_girl_type_group.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/chat/widgets/create_group_girl_type_widget.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';

class CreateGroupUserListScreen extends ConsumerStatefulWidget {
  const CreateGroupUserListScreen({super.key});

  @override
  ConsumerState<CreateGroupUserListScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupUserListScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  bool _isSearch = false;

  final _formKey = GlobalKey<FormState>();
  final _nameTextEditingController = TextEditingController();

  final _searchTextEditingController = TextEditingController();

  List<GirlTypeCategory> _girlTypeList = [];
  List<LocalGirlTypeGroup> _girlTypeGroupList = [];
  List<LocalGirlTypeGroup> _searchGirlTypeGroupList = [];
  List<ApprovedUsers> _userList = [];
  List<ApprovedUsers> _selectedUserList = [];
  List<GirlTypeCategory> _selectedGroupList = [];

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
      _girlTypeList = ref.read(messageControllerRef).girlTypesList;
      ref.read(messageControllerRef).fetchAllUsers().then((value) {
        _userList = ref.read(messageControllerRef).allUsersList;
        _createGroupListByUsers();
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  void _createGroupListByUsers() {
    _girlTypeGroupList.clear();
    for (var girlType in _girlTypeList) {
      final userList = _userList.where((element) => element.tagTypeId == girlType.id).toList();
      userList.sort((a, b) => a.displayName.compareTo(b.displayName));
      _girlTypeGroupList.add(LocalGirlTypeGroup(girlTypeCategory: girlType, userList: userList));
    }
  }

  void startSearch() {
    _isSearch = true;
    _searchGirlTypeGroupList.clear();
    for (var element in _girlTypeGroupList) {
      final userList = element.userList.where((ele) => ele.displayName.toLowerCase().contains(_searchTextEditingController.text.toLowerCase())).toList();
      userList.sort((a, b) => a.displayName.compareTo(b.displayName));
      _searchGirlTypeGroupList.add(LocalGirlTypeGroup(girlTypeCategory: element.girlTypeCategory, userList: userList));
    }
    setState(() {});
  }

  bool _isAllUsersExists(List<ApprovedUsers> userList) {
    var isExists = true;
    for (var element in userList) {
      if (!_selectedUserList.any((ele) => ele.id == element.id)) {
        isExists = false;
        break;
      }
    }
    return isExists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearch
            ? const Text('New Group')
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
                          _searchGirlTypeGroupList.clear();
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
                _searchGirlTypeGroupList.clear();
                setState(() {
                  _isLoading = true;
                });
                await ref.refresh(messageControllerRef).fetchAllUsers();
                _userList = ref.read(messageControllerRef).allUsersList;
                _createGroupListByUsers();
                setState(() {
                  _isLoading = false;
                });
              },
              child: !_isSearch
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final girlTypeGroup = _girlTypeGroupList[index];
                        return CreateGroupGirlTypeWidget(
                          key: ValueKey(girlTypeGroup.girlTypeCategory.id),
                          girlTypeGroup: girlTypeGroup,
                          selectedUserList: _selectedUserList,
                          isGroupExists: girlTypeGroup.userList.isNotEmpty ? _isAllUsersExists(girlTypeGroup.userList) : false,
                          onGroupSelect: (value) {
                            if (value!) {
                              _selectedUserList.addAll(girlTypeGroup.userList);

                              if (!_selectedGroupList.any((element) => element.id == girlTypeGroup.girlTypeCategory.id)) {
                                _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                              }

                            } else {

                              for (var element in girlTypeGroup.userList) {
                                _selectedUserList.removeWhere((ele) => ele.id == element.id);
                              }

                              if (_selectedGroupList.any((element) => element.id == girlTypeGroup.girlTypeCategory.id)) {
                                _selectedGroupList.removeWhere((element) => element.id == girlTypeGroup.girlTypeCategory.id);
                              }
                            }
                            setState(() {});
                          },
                          onUserSelect: (user, value) {
                            print('onUserSelect');
                            if (value!) {
                              _selectedUserList.add(user);
                            } else {
                              _selectedUserList.removeWhere((element) => element.id == user.id);
                            }

                            if (!_selectedUserList.any((element) => element.tagTypeId == girlTypeGroup.girlTypeCategory.id)) {
                              _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                            }
                            setState(() {});
                          },
                          onUserTap: (user, value) {
                            print('onUserSelect');
                            if (value! == false) {
                              _selectedUserList.add(user);
                            } else {
                              _selectedUserList.removeWhere((element) => element.id == user.id);
                            }

                            if (!_selectedUserList.any((element) => element.tagTypeId == girlTypeGroup.girlTypeCategory.id)) {
                              _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                            }
                            setState(() {});
                          },
                        );
                      },
                      itemCount: _girlTypeGroupList.length,
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final girlTypeGroup = _searchGirlTypeGroupList[index];
                        return CreateGroupGirlTypeWidget(
                          key: ValueKey(girlTypeGroup.girlTypeCategory.id),
                          girlTypeGroup: girlTypeGroup,
                          selectedUserList: _selectedUserList,
                          isGroupExists: girlTypeGroup.userList.isNotEmpty ? _isAllUsersExists(girlTypeGroup.userList) : false,
                          onGroupSelect: (value) {
                            if (value!) {
                              _selectedUserList.addAll(girlTypeGroup.userList);
                              if (!_selectedGroupList.any((element) => element.id == girlTypeGroup.girlTypeCategory.id)) {
                                _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                              }
                            } else {
                              for (var element in girlTypeGroup.userList) {
                                _selectedUserList.removeWhere((ele) => ele.id == element.id);
                              }
                              if (_selectedGroupList.any((element) => element.id == girlTypeGroup.girlTypeCategory.id)) {
                                _selectedGroupList.removeWhere((element) => element.id == girlTypeGroup.girlTypeCategory.id);
                              }
                            }
                            setState(() {});
                          },
                          onUserSelect: (user, value) {
                            setState(() {
                              if (value!) {
                                _selectedUserList.add(user);
                              } else {
                                _selectedUserList.removeWhere((element) => element.id == user.id);
                              }

                              if (!_selectedUserList.any((element) => element.tagTypeId == girlTypeGroup.girlTypeCategory.id)) {
                                _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                              }
                            });
                          },
                          onUserTap: (user, value) {
                            print('onUserSelect');
                            if (value! == false) {
                              _selectedUserList.add(user);
                            } else {
                              _selectedUserList.removeWhere((element) => element.id == user.id);
                            }

                            if (!_selectedUserList.any((element) => element.tagTypeId == girlTypeGroup.girlTypeCategory.id)) {
                              _selectedGroupList.add(girlTypeGroup.girlTypeCategory);
                            }
                            setState(() {});
                          },
                        );
                      },
                      itemCount: _searchGirlTypeGroupList.length,
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showNameBottomSheet();
        },
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
      ),
    );
  }

  void showNameBottomSheet() async {
    final response = await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Group Name',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter group name !!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(ctx).pop(true);
                          }
                        },
                        style: FilledButton.styleFrom(
                          fixedSize: const Size.fromWidth(150),
                        ),
                        child: const Text('CREATE'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    if (response != null) {
      final user = ref.read(loginProviderRef).user;
      final participants = _selectedUserList
          .map((e) => ParticipantModel(
                id: e.id.toString(),
                email: e.email,
                displayName: e.displayName,
                image: e.image,
                tagTypeId: e.tagTypeId,
                tagTypeName: e.tagTypeName,
                phone: null,
              ))
          .toList()
        ..add(ParticipantModel(
          id: user.id,
          email: user.email,
          displayName: user.displayName,
          phone: user.phone,
          image: user.image,
          tagTypeId: user.tagTypeId,
          tagTypeName: user.tagTypeName,
        ));

      await ref.read(messageControllerRef).createGroupConversations(
            _nameTextEditingController.text.trim(),
            participants,
            user,
            _selectedGroupList,
          );
      Navigator.of(context).pop();
    }
  }
}
