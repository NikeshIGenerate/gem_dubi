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
  bool isFavouriteLoading = false;

  List<EventListing> listings = [];
  List<Category> categories = [];

  bool loadingBookings = false;
  List<Booking> upComingBookings = [];
  List<Booking> previousBookings = [];

  Category? selectedCategory;

  updateSelectedCategory(User user, Category? category) async {
    loading = true;
    selectedCategory = category;
    notifyListeners();
    listings = await repo.fetchListing(user: user, category: category!.id);
    listings.sort((a, b) => a.startDate.difference(DateTime.now()).abs().compareTo(b.startDate.difference(DateTime.now()).abs()));
    if (selectedCategory!.id == 0) {
      listings = listings.where((element) => element.alreadyBookmarked).toList();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> init(User user) async {
    loading = true;
    categories = await repo.fetchCategories();
    categories.add(const Category(id: 0, name: 'Favourites', slug: 'favourites', parent: 0, count: 0));
    selectedCategory = selectedCategory ?? categories[0];
    listings = await repo.fetchListing(user: user, category: selectedCategory!.id);
    listings.sort((a, b) => a.startDate.difference(DateTime.now()).abs().compareTo(b.startDate.difference(DateTime.now()).abs()));
    if (selectedCategory!.id == 0) {
      listings = listings.where((element) => element.alreadyBookmarked).toList();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addRemoveFavourite({required String postId, required String userId, required bool status}) async {
    int index = listings.indexWhere((element) => element.id.toString() == postId);
    EventListing listing = listings.removeAt(index);
    listing.alreadyBookmarked = status;
    if (selectedCategory!.id != 0) {
      listings.insert(index, listing);
    }
    notifyListeners();
    try {
      bool isSuccess = await repo.addRemoveFavourite(
        postId: postId,
        userId: userId,
        status: status,
      );
      if (!isSuccess) {
        int index = listings.indexWhere((element) => element.id.toString() == postId);
        EventListing listing = listings.removeAt(index);
        listing.alreadyBookmarked = !status;
        if (selectedCategory!.id != 0) {
          listings.insert(index, listing);
        }
        notifyListeners();
      }
    } catch (err) {
      int index = listings.indexWhere((element) => element.id.toString() == postId);
      EventListing listing = listings.removeAt(index);
      listing.alreadyBookmarked = !status;
      if (selectedCategory!.id != 0) {
        listings.insert(index, listing);
      }
      notifyListeners();
      print(err);
      rethrow;
    }
  }

  Future<void> getUpComingBooking({required User user, bool isLoading = false}) async {
    loadingBookings = true;
    notifyListeners();

    final response = await repo.getMyBookings(pastEvents: false, user: user);
    upComingBookings = response.where((element) => element.status == BookingStatus.waiting || element.status == BookingStatus.confirmed || element.status == BookingStatus.paid).toList();
    loadingBookings = false;
    notifyListeners();
  }

  Future<void> getPreviousBooking({required User user}) async {
    loadingBookings = true;
    notifyListeners();

    final response = await repo.getMyBookings(pastEvents: true, user: user);
    previousBookings = response;
    loadingBookings = false;

    notifyListeners();
  }

  Future<void> bookATicket({
    required EventListing listing,
    required User user,
    required DateTime eventDate,
    int tickets = 1,
  }) async {
    await repo.requestBooking(
      userId: user.id,
      listing: listing,
      tickets: tickets,
      eventDate: eventDate,
    );
  }

  Future<void> cancelBooking(int id, {bool pastEvents = true}) async {
    loadingBookings = true;
    notifyListeners();

    bool isCancelled = await repo.cancelBooking(id);

    if (!isCancelled) {
      loadingBookings = false;
      notifyListeners();
      return;
    }

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
