import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/events/controllers/event_repository.dart';
import 'package:gem_dubi/src/events/entities/booking.dart';
import 'package:gem_dubi/src/events/entities/category.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/login/user.dart';

final eventControllerRef = ChangeNotifierProvider((ref) => EventController());

class EventController extends ChangeNotifier {
  final repo = EventsRepository.instance();

  bool loading = false;

  List<Listing> listings = [];
  List<Category> categories = [];

  bool loadingBookings = false;
  List<Booking> upComingBookings = [];
  List<Booking> previousBookings = [];

  Category? selectedCategory;

  updateSelectedCategory(User user, Category? category) async {
    loading = true;
    selectedCategory = category;
    listings = [];
    notifyListeners();

    listings = await repo.fetchListing(user: user, category: category?.id);
    listings.sort((a, b) => a.startDate.difference(DateTime.now()).abs().compareTo(b.startDate.difference(DateTime.now()).abs()));
    loading = false;
    notifyListeners();
  }

  Future<void> init(User user) async {
    loading = true;
    categories = await repo.fetchCategories();
    selectedCategory = selectedCategory ?? categories[0];
    listings = await repo.fetchListing(user: user, category: selectedCategory!.id);
    listings.sort((a, b) => a.startDate.difference(DateTime.now()).abs().compareTo(b.startDate.difference(DateTime.now()).abs()));
    loading = false;
    notifyListeners();
  }

  Future<void> getUpComingBooking({bool isLoading = false}) async {
    loadingBookings = true;
    notifyListeners();

    final response = await repo.getMyBookings(pastEvents: false);
    upComingBookings = response.where((element) => element.status == BookingStatus.waiting || element.status == BookingStatus.confirmed || element.status == BookingStatus.paid).toList();
    loadingBookings = false;
    notifyListeners();
  }

  Future<void> getPreviousBooking() async {
    loadingBookings = true;
    notifyListeners();

    final response = await repo.getMyBookings(pastEvents: true);
    previousBookings = response;
    loadingBookings = false;

    notifyListeners();
  }

  Future<void> bookATicket({
    required Listing listing,
    required User user,
    int tickets = 1,
  }) async {
    await repo.requestBooking(
      userId: user.id,
      listing: listing,
      tickets: tickets,
    );
  }

  Future<void> cancelBooking(int id, {bool pastEvents = true}) async {
    loadingBookings = true;
    notifyListeners();

    await repo.cancelBooking(id);

    if (pastEvents) {
      previousBookings.removeWhere((element) => element.id == id);

      // if (index != -1) {
      //   previousBookings[index] = previousBookings[index].copyWith(
      //     status: BookingStatus.cancelled,
      //   );
      // }
    } else {
      upComingBookings.removeWhere((element) => element.id == id);
      // if (index != -1) {
      //   upComingBookings[index] = upComingBookings[index].copyWith(
      //     status: BookingStatus.cancelled,
      //   );
      // }
    }
    loadingBookings = false;
    notifyListeners();
  }
}
