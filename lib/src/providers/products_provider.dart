import 'dart:convert';
import 'dart:io';
import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/user_preferences/user_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class ProductsProvider {
  final String _url = "https://instaflutter-87a27.firebaseio.com";
  final _preferences = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async{
    final url = '$_url/products.json?auth=${_preferences.token}';
    final response = await http.post(url, body: productModelToJson(product));
    final decodedData = json.decode(response.body);
    
    return true;
  }

  Future<bool> editProduct(ProductModel product) async{
    final url ='$_url/products/${product.id}.json?auth=${_preferences.token}';
    final response = await http.put(url, body: productModelToJson(product));
    final decodedData = json.decode(response.body);
    
    return true;
  }

  Future<List<ProductModel>> showProducts() async{
    final url ='$_url/products.json?auth=${_preferences.token}';
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> products = new List();
    
    if (decodedData == null) return [];
    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, product) {
      final temporalProduct = ProductModel.fromJson(product);
      temporalProduct.id = id;
      products.add(temporalProduct);
    });
    
    return products;
  }

  Future<int> deleteProduct(String id) async{
    final url ='$_url/products/$id.json?auth=${_preferences.token}';
    final response = await http.delete(url);
    return 1;
  }

  Future<String> uploadImage(File image) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/mashd3v/image/upload?upload_preset=s7s9ppqu');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if(response.statusCode != 200 && response.statusCode != 201){
      return null;
    }

    final responseData = json.decode(response.body);
    return responseData['secure_url'];
  }

}