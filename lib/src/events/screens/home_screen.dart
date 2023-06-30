import 'package:flutter/material.dart';
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

  Widget _buildEventList(EventController eventController, ThemeData theme) {
    return eventController.loading
        ? const AspectRatio(
            aspectRatio: 1,
            child: LoadingWidget(
              color: Colors.white,
            ),
          )
        : eventController.listings.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  final listings = eventController.listings[index];
                  return ListingCard(
                    listing: listings,
                    onFavourite: () {
                      _user = ref.read(loginProviderRef).user;
                      eventController.addRemoveFavourite(
                        postId: listings.id.toString(),
                        userId: _user!.id,
                        status: !listings.alreadyBookmarked,
                      );
                    },
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
                  );
                },
                itemCount: eventController.listings.length,
              )
            : Center(
                child: Text(
                  eventController.selectedCategory!.id == 0 ? 'empty\nNo favourites' : 'empty\nNo events',
                  textAlign: TextAlign.center,
                ),
              );
  }
}
