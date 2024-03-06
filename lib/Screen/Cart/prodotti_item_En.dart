import 'package:flutter/foundation.dart';

ProdottiitemList_En prodottiItemsList_En = ProdottiitemList_En(prodottiItems_En: [
  ProdottiItem_En(
    id: 1,
    name: "Manicure",
    price: 45,
  ),
  ProdottiItem_En(
    id: 2,
    name: "Curative pedicure",
    price: 85,
  ),
  ProdottiItem_En(
    id: 3,
    name: "Aestetic pedicure",
    price: 65,
  ),
  ProdottiItem_En(
    id: 4,
    name: "Facial cleaning",
    price: 75,
  ),
  ProdottiItem_En(
    id: 5,
    name: "Legs waxing",
    price: 75,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Bikini",
    price: 45,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Arms waxing",
    price: 30,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Underarm waxing",
    price: 25,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Eyebrows",
    price: 25,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Mustache",
    price: 25,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Total body relax massage",
    price: 85,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Lymphatic drainage legs massage",
    price: 60,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Full lymphatic drainage massage",
    price: 110,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Firming anti-cellulite massage",
    price: 95,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Decontracting leg massage",
    price: 120,
  ),
  ProdottiItem_En(
    id: 6,
    name: "Decontracting back and neck massage",
    price: 120,
  ),
]);

class ProdottiitemList_En {
  List<ProdottiItem_En> prodottiItems_En;

  ProdottiitemList_En({required this.prodottiItems_En});
}

class ProdottiItem_En {
  int id;
  String name;
  int price;
  int quantity;

  ProdottiItem_En({
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
