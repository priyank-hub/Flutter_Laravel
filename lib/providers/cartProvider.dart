import 'dart:convert';

import 'package:auth_flutter/models/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {

  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  List<Cart> getItems() {
    notifyListeners();
    return cart;
  }


  // void _setPrefsItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('cart_items', _counter);
  //   prefs.setInt('item_quantity', _quantity);
  //   prefs.setDouble('total_price', _totalPrice);
  //   notifyListeners();
  // }

  // void _getPrefsItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _counter = prefs.getInt('cart_items') ?? 0;
  //   _quantity = prefs.getInt('item_quantity') ?? 1;
  //   _totalPrice = prefs.getDouble('total_price') ?? 0;
  // }

  void addCounter() {
    _counter++;
    notifyListeners();
  }

  // void removeCounter() {
  //   _counter--;
  //   _setPrefsItems();
  //   notifyListeners();
  // }

  int getCounter() {
    // _getPrefsItems();
    return _counter;
  }

  void addItem(Cart cartItem) {
    if (!cart.isEmpty && (cart[0].restaurantId != cartItem.restaurantId)) {
      cart.clear();
      _counter = 0;
    }
    cart.add(cartItem);
    addCounter();
    notifyListeners();
  }

  // void addQuantity(int id) {
  //   final index = cart.indexWhere((element) => element.id == id);
  //   cart[index].quantity!.value = cart[index].quantity!.value + 1;
  //   _setPrefsItems();
  //   notifyListeners();
  // }

  // void deleteQuantity(int id) {
  //   final index = cart.indexWhere((element) => element.id == id);
  //   final currentQuantity = cart[index].quantity!.value;
  //   if (currentQuantity <= 1) {
  //     currentQuantity == 1;
  //   } else {
  //     cart[index].quantity!.value = currentQuantity - 1;
  //   }
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  //
  // void removeItem(int id) {
  //   final index = cart.indexWhere((element) => element.id == id);
  //   cart.removeAt(index);
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  //
  // int getQuantity(int quantity) {
  //   _getPrefsItems();
  //   return _quantity;
  // }
  //
  // void addTotalPrice(double productPrice) {
  //   _totalPrice = _totalPrice + productPrice;
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  //
  // void removeTotalPrice(double productPrice) {
  //   _totalPrice = _totalPrice - productPrice;
  //   _setPrefsItems();
  //   notifyListeners();
  // }
  //
  // double getTotalPrice() {
  //   _getPrefsItems();
  //   return _totalPrice;
  // }
}