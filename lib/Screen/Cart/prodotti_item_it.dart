import 'package:flutter/foundation.dart';

ProdottiitemList prodottiItemsList = ProdottiitemList(prodottiItems: [
  ProdottiItem(
    id: 1,
    name: "Manicure",
    price: 10,
  ),
  ProdottiItem(
    id: 2,
    name: "Curative pedicure",
    price: 85,
  ),
  ProdottiItem(
    id: 3,
    name: "Aestetic pedicure",
    price: 65,
  ),
  ProdottiItem(
    id: 4,
    name: "Facial cleaning",
    price: 75,
  ),
  ProdottiItem(
    id: 5,
    name: "Legs waxing",
    price: 75,
  ),
  ProdottiItem(
    id: 6,
    name: "Bikini",
    price: 45,
  ),
  ProdottiItem(
    id: 6,
    name: "Arms waxing",
    price: 30,
  ),
  ProdottiItem(
    id: 6,
    name: "Underarm waxing",
    price: 25,
  ),
  ProdottiItem(
    id: 6,
    name: "Eyebrows",
    price: 25,
  ),
  ProdottiItem(
    id: 6,
    name: "Mustache",
    price: 25,
  ),
  ProdottiItem(
    id: 6,
    name: "Tot body relax massage",
    price: 85,
  ),
  ProdottiItem(
    id: 6,
    name: "Lymphatic drainage legs massage",
    price: 60,
  ),
  ProdottiItem(
    id: 6,
    name: "Full lymphatic drainage massage",
    price: 110,
  ),
  ProdottiItem(
    id: 6,
    name: "Firming anti-cellulite massage",
    price: 95,
  ),
  ProdottiItem(
    id: 6,
    name: "Decontracting leg massage",
    price: 120,
  ),
  ProdottiItem(
    id: 6,
    name: "Decontracting back and neck massage",
    price: 120,
  ),
]);

class ProdottiitemList {
  List<ProdottiItem> prodottiItems;

  ProdottiitemList({required this.prodottiItems});
}

class ProdottiItem {
  int id;
  String name;
  int price;
  int quantity;

  ProdottiItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}
