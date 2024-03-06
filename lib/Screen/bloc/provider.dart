

import 'package:near_me/Screen/Cart/prodotti_item_En.dart';

import '../Cart/prodotti_item_it.dart';

class CartProvider {
  //couterProvider only consists of a counter and a method which is responsible for increasing the value of count
  List<ProdottiItem> prodottiItems = [];

  List<ProdottiItem> addToList(ProdottiItem foodItem) {
    bool isPresent = false;

    if (prodottiItems.length > 0) {
      for (int i = 0; i < prodottiItems.length; i++) {
        if (prodottiItems[i].id == foodItem.id) {
          increaseItemQuantity(foodItem);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        prodottiItems.add(foodItem);
      }
    } else {
      prodottiItems.add(foodItem);
    }

    return prodottiItems;
  }

  List<ProdottiItem> removeFromList(ProdottiItem foodItem) {
    if (foodItem.quantity > 1) {
      //only decrease the quantity
      decreaseItemQuantity(foodItem);
    } else {
      //remove it from the list
      prodottiItems.remove(foodItem);
    }
    return prodottiItems;
  }

  void increaseItemQuantity(ProdottiItem foodItem) =>
      foodItem.incrementQuantity();
  void decreaseItemQuantity(ProdottiItem foodItem) =>
      foodItem.decrementQuantity();
}


class CartProvider_En {
  //couterProvider only consists of a counter and a method which is responsible for increasing the value of count
  List<ProdottiItem_En> prodottiItems_En = [];

  List<ProdottiItem_En> addToList(ProdottiItem_En foodItem_En) {
    bool isPresent = false;

    if (prodottiItems_En.length > 0) {
      for (int i = 0; i < prodottiItems_En.length; i++) {
        if (prodottiItems_En[i].id == foodItem_En.id) {
          increaseItemQuantity(foodItem_En);
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        prodottiItems_En.add(foodItem_En);
      }
    } else {
      prodottiItems_En.add(foodItem_En);
    }

    return prodottiItems_En;
  }

  List<ProdottiItem_En> removeFromList(ProdottiItem_En foodItem) {
    if (foodItem.quantity > 1) {
      //only decrease the quantity
      decreaseItemQuantity(foodItem);
    } else {
      //remove it from the list
      prodottiItems_En.remove(foodItem);
    }
    return prodottiItems_En;
  }

  void increaseItemQuantity(ProdottiItem_En foodItem) =>
      foodItem.incrementQuantity();
  void decreaseItemQuantity(ProdottiItem_En foodItem) =>
      foodItem.decrementQuantity();
}
