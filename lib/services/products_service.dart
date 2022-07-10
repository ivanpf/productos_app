import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2cea7-default-rtdb.firebaseio.com';
  final List<Products> products = [];
}
