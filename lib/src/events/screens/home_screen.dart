import 'package:flutter/material.dart';
import 'package:gem_dubi/common/widgets/animated_list.dart';
import 'package:gem_dubi/common/widgets/blue_background.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/entities/category.dart';
import 'package:gem_dubi/src/events/widgets/event_card.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventsHomeScreen extends StatefulHookConsumerWidget {
  const EventsHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EventsHomeScreen> createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends ConsumerState<EventsHomeScreen> with SingleTickerProviderStateMixin {
  bool _isInit = true;
  bool _isLoading = true;
  User? _user;
  Category? _currentCategory;
  List<Category> categories = [];

  TabController? _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _user = ref.read(loginProviderRef).user;
      ref.watch(eventControllerRef).init(_user!).then((_) {
        final eventController = ref.read(eventControllerRef);
        _tabController = TabController(
          length: eventController.categories.length,
          vsync: this,
        );
        _currentCategory = eventController.categories[0];
        _tabController?.addListener(() {
          if (_tabController!.indexIsChanging) {
            _user = ref.read(loginProviderRef).user;
            _currentCategory = eventController.categories[_tabController!.index];
            eventController.updateSelectedCategory(_user!, eventController.categories[_tabController!.index]);
          }
        });
        _isLoading = false;
        setState(() {});
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventController = ref.watch(eventControllerRef);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset(
            R.ASSETS_GEM_LOGO_PNG,
            width: 36,
            height: 36,
            color: Colors.white,
            // color: Theme.of(context).primaryColor,
          ),
        ),
        bottom: _tabController != null
            ? PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TabBar(
                        controller: _tabController,
                        tabs: eventController.categories.map((e) => Tab(text: e.name)).toList(),
                        indicator: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        isScrollable: true,
                        indicatorPadding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                        onTap: (index) {
                          _user = ref.read(loginProviderRef).user;
                          _currentCategory = eventController.categories[index];
                          eventController.updateSelectedCategory(_user!, eventController.categories[index]);
                        },
                      ),
                    ),
                  ],
                ),
              )
            : null,
        flexibleSpace: const BlurBackground(),
      ),
      extendBodyBehindAppBar: true,
      body: !_isLoading && _tabController != null
          ? TabBarView(
              controller: _tabController,
              children: eventController.categories.map((e) {
                return _buildEventList(eventController, theme);
              }).toList(),
            )
          : const LoadingWidget(
              color: Colors.white60,
            ),
    );
  }

  AnimationList _buildEventList(EventController eventController, ThemeData theme) {
    return AnimationList(
      children: [
        const SizedBox(height: 20),
        // Card(
        //   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(300),
        //   ),
        //   color: Colors.white,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         const Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: true ? SizedBox(width: 10) : Icon(Icons.search),
        //         ),
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               Text(
        //                 'Where to go?',
        //                 style: theme.textTheme.titleSmall?.copyWith(color: Colors.black),
        //               ),
        //               Text(
        //                 'Any where Where to go',
        //                 style: theme.textTheme.labelMedium?.copyWith(color: Colors.black),
        //               ),
        //             ],
        //           ),
        //         ),
        //         const Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Icon(Icons.tune_rounded),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 5),
        // SizedBox(
        //   height: 60,
        //   child: AnimationList(
        //     delay: 1000,
        //     scrollDirection: Axis.horizontal,
        //     padding: const EdgeInsets.all(10),
        //     children: [
        //       for (var category in eventController.categories)
        //         Padding(
        //           padding: const EdgeInsets.only(right: 8.0),
        //           child: ChoiceChip(
        //             label: Text(category.name),
        //             onSelected: (i) {
        //               _user = ref.read(loginProviderRef).user;
        //               eventController.updateSelectedCategory(_user!, i ? category : null);
        //             },
        //             selected: false,
        //             shadowColor: theme.primaryColor,
        //             elevation: category == eventController.selectedCategory ? 6 : 0,
        //             backgroundColor: category == eventController.selectedCategory ? theme.primaryColor : null,
        //           ),
        //         ),
        //     ],
        //   ),
        // ),
        if (eventController.loading)
          const AspectRatio(
            aspectRatio: 1,
            child: LoadingWidget(
              color: Colors.white,
            ),
          ),
        for (var listings in eventController.listings)
          ListingCard(
            listing: listings,
            refreshEventList: () {
              setState(() {
                _isLoading = true;
              });
              _user = ref.read(loginProviderRef).user;
              eventController.updateSelectedCategory(_user!, _currentCategory);
              setState(() {
                _isLoading = false;
              });
            },
          ),
        const SizedBox(height: 50),
      ],
    );
  }
}
