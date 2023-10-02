import 'package:flutter/material.dart';
import 'package:gem_dubi/src/events/screens/booking_history_screen.dart';
import 'package:gem_dubi/src/events/screens/up_coming_booking_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  bool _isInit = true;
  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _tabController = TabController(length: 2, vsync: this);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
              indicator: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              onTap: (index) {

              },
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UpComingBookingsScreen(false),
          BookingHistoryScreen(false),
        ],
      ),
    );
  }
}
