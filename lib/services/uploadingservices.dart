import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:destination/modals/activitymodal.dart';
import 'package:destination/modals/dishmodal.dart';
import 'package:destination/modals/hotelmodal.dart';
import 'package:destination/modals/placemodal.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RecommendedService {
  /////////for place
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final path = 'place_images/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      ('Error uploading image to firebase storage: $e');
      return null;
    }
  }

  Future<void> createPlace(PlaceModal place) async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(place.placeName) // Use 'placeName' field as the document ID
          .set(place.toJson());
    } catch (e) {
      print('Error creating place: $e');
    }
  }

  Future<void> updatePlace(PlaceModal place) async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(place.placeName)
          .update(place.toJson());
    } catch (e) {
      print('Error updating place: $e'); // Added print statement
    }
  }

////////For Hotel
  Future<String?> uploadHotelImage(File imageFile) async {
    try {
      final path = 'hotels_images/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      ('Error uploading image to firebase storage: $e');
      return null;
    }
  }

  Future<void> createHotel(HotelModal hotel) async {
    try {
      final placeDocRef =
          FirebaseFirestore.instance.collection('places').doc(hotel.placeName);
      final hotelDocSnapshot = await placeDocRef.get();
      if (hotelDocSnapshot.exists) {
        await placeDocRef
            .collection('hotels')
            .doc(hotel.hotelName)
            .set(hotel.toJson());
        print('Hotel added successfully');
      } else {
        print('Error: Place does not exist');
      }
    } catch (e) {
      print('Error creating hotel: $e');
    }
  }

  Future<void> updateHotel(HotelModal hotel) async {
    print('.......');
    print(hotel.placeName);
    try {
      final placeDocRef =
          FirebaseFirestore.instance.collection('places').doc(hotel.placeName);
      final hotelDocRef = placeDocRef
          .collection('hotels')
          .doc(hotel.hotelName); // Assuming each hotel has an ID
      await hotelDocRef.update(hotel.toJson());
      print('Hotel updated successfully');
    } catch (e, stackTrace) {
      print('Error updating hotel: $e');
      print('Document path: ${hotel.hotelName}/hotels/${hotel.hotelName}');
      print('StackTrace: $stackTrace');
    }
  }

  // Future<void> updateHotel(HotelModal hotel) async {
  //   try {
  //     final placeDocRef =
  //         FirebaseFirestore.instance.collection('places').doc(hotel.placeName);
  //     final hotelDocRef = placeDocRef.collection('hotels').doc(hotel.placeName);

  //     await hotelDocRef.update(hotel.toJson());
  //     print('Hotel updated successfully');
  //   } catch (e) {
  //     print('Error updating hotel: $e');
  //   }
  // }

//For Activities
  Future<String?> uploadActivitiesImage(File imageFile) async {
    try {
      final path = 'activity_images/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      ('Error uploading image to firebase storage: $e');
      return null;
    }
  }

  Future<void> createActivities(ActivitiesModal activities) async {
    try {
      final placeDocRef = FirebaseFirestore.instance
          .collection('places')
          .doc(activities.placeName);
      final hotelDocSnapshot = await placeDocRef.get();
      if (hotelDocSnapshot.exists) {
        await placeDocRef.collection('activities').add(activities.toJson());
        print('Activity added successfully');
      } else {
        print('Error: Activity does not exist');
      }
    } catch (e) {
      print('Error creating activity: $e');
    }
  }

  Future<void> updateActivity(ActivitiesModal activity) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(activity.placeName)
          .update(activity.toJson());
    } catch (e) {
      print('Error updating place: $e'); // Added print statement
    }
  }

// For Dishes
  Future<String?> uploadDishImage(File imageFile) async {
    try {
      final path = 'dish_images/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      ('Error uploading image to firebase storage: $e');
      return null;
    }
  }

  Future<void> createDishes(DishModal dish) async {
    try {
      final placeDocRef =
          FirebaseFirestore.instance.collection('places').doc(dish.placeName);
      final hotelDocSnapshot = await placeDocRef.get();
      if (hotelDocSnapshot.exists) {
        await placeDocRef.collection('dishes').add(dish.toJson());
        print('Activity added successfully');
      } else {
        print('Error: Activity does not exist');
      }
    } catch (e) {
      print('Error creating activity: $e');
    }
  }

  Future<void> updateDish(DishModal dish) async {
    try {
      await FirebaseFirestore.instance
          .collection('dishes')
          .doc(dish.placeName)
          .update(dish.toJson());
    } catch (e) {
      print('Error updating place: $e'); // Added print statement
    }
  }
}
