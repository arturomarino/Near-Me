import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:near_me/Screen/Cart/prodotti_item_En.dart';
import 'package:near_me/Screen/Cart/prodotti_item_it.dart';
import 'package:near_me/Screen/bloc/provider.dart';
import 'package:rxdart/rxdart.dart';

class CartListBloc extends BlocBase {
  CartListBloc();

  var _listController = BehaviorSubject<List<ProdottiItem>>.seeded([]);

//provider class
  CartProvider provider = CartProvider();

//output
  Stream<List<ProdottiItem>> get listStream => _listController.stream;

//input
  Sink<List<ProdottiItem>> get listSink => _listController.sink;

  addToList(ProdottiItem foodItem) {
    listSink.add(provider.addToList(foodItem));
  }

  removeFromList(ProdottiItem foodItem) {
    listSink.add(provider.removeFromList(foodItem));
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}


class CartListBloc_En extends BlocBase {
  CartListBloc_En();

  var _listController = BehaviorSubject<List<ProdottiItem_En>>.seeded([]);

//provider class
  CartProvider_En provider = CartProvider_En();

//output
  Stream<List<ProdottiItem_En>> get listStream => _listController.stream;

//input
  Sink<List<ProdottiItem_En>> get listSink => _listController.sink;

  addToList(ProdottiItem_En foodItem) {
    listSink.add(provider.addToList(foodItem));
  }

  removeFromList(ProdottiItem_En foodItem) {
    listSink.add(provider.removeFromList(foodItem));
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}