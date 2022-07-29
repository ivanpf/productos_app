import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2cea7-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = false;
  late Product selectedProduct;
  bool isSaving = false;
  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final res = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(res.body);

    productsMap.forEach((key, value) {
      final tempProd = Product.fromMap(value);
      tempProd.id = key;
      products.add(tempProd);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) {
      return null;
    } else {
      isSaving = true;
      notifyListeners();
      final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/dtrujf0cp/image/upload?upload_preset=iqob11h2");

      final imageUploadRequest = http.MultipartRequest('POST', url);
      final file =
          await http.MultipartFile.fromPath('file', newPictureFile!.path);

      imageUploadRequest.files.add(file);
      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salió mal');
        print(resp.body);
        return null;
      }

      newPictureFile = null;

      final decodedData = json.decode(resp.body);
      return decodedData['secure_url'];
    }
  }
}
