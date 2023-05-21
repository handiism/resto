import 'dart:convert';

import 'package:resto/model/resraurant.dart';

RestaurantDetail baseFromJson(String str) =>
    RestaurantDetail.fromJson(json.decode(str));

String baseToJson(RestaurantDetail data) => json.encode(data.toJson());

class RestaurantDetail {
  bool error;
  String message;
  Restaurant restaurant;

  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        error: json["error"],
        message: json["message"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}
