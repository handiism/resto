// To parse this JSON data, do
//
//     final restaurantList = restaurantListFromJson(jsonString);

import 'dart:convert';

import 'package:resto/model/resraurant.dart';

RestaurantList restaurantListFromJson(String str) =>
    RestaurantList.fromJson(json.decode(str));

String restaurantListToJson(RestaurantList data) => json.encode(data.toJson());

class RestaurantList {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  RestaurantList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}
