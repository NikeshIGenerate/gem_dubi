// import 'package:gem_dubi/common/converter/converter.dart';
//
// class ListingBooking {
//   final String id;
//   final String title;
//   final String featuredImage;
//   final String status;
//   final String price;
//   final String createdDate;
//   final String startData;
//   final String endDate;
//   final String orderId;
//   final String orderStatus;
//   final Map<String, String> adults;
//
//   final List<String> services;
//
//   final String customerId;
//   final String customerName;
//   final String customerEmail;
//   final String customerPhone;
//   final String customerMessage;
//
//   /// nullable
//   final String area;
//   final String listingId;
//
//   final bool arrived;
//
//   DateTime get startDateTime => DateTime.parse(startData);
//
//   String get guestsCount => adults['adults'] ?? adults['tickets'] ?? '';
//
// //<editor-fold desc="Data Methods">
//
//   const ListingBooking({
//     required this.id,
//     required this.title,
//     required this.featuredImage,
//     required this.status,
//     required this.price,
//     required this.createdDate,
//     required this.startData,
//     required this.endDate,
//     required this.orderId,
//     required this.orderStatus,
//     required this.adults,
//     required this.services,
//     required this.customerId,
//     required this.customerName,
//     required this.customerEmail,
//     required this.customerPhone,
//     required this.customerMessage,
//     required this.area,
//     required this.listingId,
//     required this.arrived,
//   });
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is ListingBooking &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           title == other.title &&
//           featuredImage == other.featuredImage &&
//           status == other.status &&
//           price == other.price &&
//           createdDate == other.createdDate &&
//           startData == other.startData &&
//           endDate == other.endDate &&
//           orderId == other.orderId &&
//           orderStatus == other.orderStatus &&
//           adults == other.adults &&
//           services == other.services &&
//           customerId == other.customerId &&
//           customerName == other.customerName &&
//           customerEmail == other.customerEmail &&
//           customerPhone == other.customerPhone &&
//           customerMessage == other.customerMessage &&
//           area == other.area &&
//           listingId == other.listingId &&
//           arrived == other.arrived);
//
//   @override
//   int get hashCode =>
//       id.hashCode ^
//       title.hashCode ^
//       featuredImage.hashCode ^
//       status.hashCode ^
//       price.hashCode ^
//       createdDate.hashCode ^
//       startData.hashCode ^
//       endDate.hashCode ^
//       orderId.hashCode ^
//       orderStatus.hashCode ^
//       adults.hashCode ^
//       services.hashCode ^
//       customerId.hashCode ^
//       customerName.hashCode ^
//       customerEmail.hashCode ^
//       customerPhone.hashCode ^
//       customerMessage.hashCode ^
//       area.hashCode ^
//       listingId.hashCode ^
//       arrived.hashCode;
//
//   @override
//   String toString() {
//     return 'ListingBooking{ id: $id, title: $title, featuredImage: $featuredImage, status: $status, price: $price, createdDate: $createdDate, startData: $startData, endDate: $endDate, orderId: $orderId, orderStatus: $orderStatus, adults: $adults, services: $services, customerId: $customerId, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone, customerMessage: $customerMessage, area: $area, listingId: $listingId, arrived: $arrived,}';
//   }
//
//   ListingBooking copyWith({
//     String? id,
//     String? title,
//     String? featuredImage,
//     String? status,
//     String? price,
//     String? createdDate,
//     String? startData,
//     String? endDate,
//     String? orderId,
//     String? orderStatus,
//     Map<String, String>? adults,
//     List<String>? services,
//     String? customerId,
//     String? customerName,
//     String? customerEmail,
//     String? customerPhone,
//     String? customerMessage,
//     String? area,
//     String? listingId,
//     bool? arrived,
//   }) {
//     return ListingBooking(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       featuredImage: featuredImage ?? this.featuredImage,
//       status: status ?? this.status,
//       price: price ?? this.price,
//       createdDate: createdDate ?? this.createdDate,
//       startData: startData ?? this.startData,
//       endDate: endDate ?? this.endDate,
//       orderId: orderId ?? this.orderId,
//       orderStatus: orderStatus ?? this.orderStatus,
//       adults: adults ?? this.adults,
//       services: services ?? this.services,
//       customerId: customerId ?? this.customerId,
//       customerName: customerName ?? this.customerName,
//       customerEmail: customerEmail ?? this.customerEmail,
//       customerPhone: customerPhone ?? this.customerPhone,
//       customerMessage: customerMessage ?? this.customerMessage,
//       area: area ?? this.area,
//       listingId: listingId ?? this.listingId,
//       arrived: arrived ?? this.arrived,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'featuredImage': featuredImage,
//       'status': status,
//       'price': price,
//       'createdDate': createdDate,
//       'startData': startData,
//       'endDate': endDate,
//       'orderId': orderId,
//       'orderStatus': orderStatus,
//       'adults': adults,
//       'services': services,
//       'customerId': customerId,
//       'customerName': customerName,
//       'customerEmail': customerEmail,
//       'customerPhone': customerPhone,
//       'customerMessage': customerMessage,
//       'area': area,
//       'listingId': listingId,
//       'arrived': arrived,
//     };
//   }
//
//   factory ListingBooking.fromMap(Map<String, dynamic> map) {
//     return ListingBooking(
//       id: map.from('id'),
//       title: map.from('title'),
//       featuredImage: map.from('featuredImage'),
//       status: map.from('status'),
//       price: map.from('price'),
//       createdDate: map.from('createdDate'),
//       startData: map.from('startData'),
//       endDate: map.from('endDate'),
//       orderId: map.from('orderId'),
//       orderStatus: map.from('orderStatus'),
//       adults: map.from('adults'),
//       services: map.from('services'),
//       customerId: map.from('customerId'),
//       customerName: map.from('customerName'),
//       customerEmail: map.from('customerEmail'),
//       customerPhone: map.from('customerPhone'),
//       customerMessage: map.from('customerMessage'),
//       area: map.from('area'),
//       listingId: map.from('listingId'),
//       arrived: map.from('arrived'),
//     );
//   }
//
// //</editor-fold>
// }
