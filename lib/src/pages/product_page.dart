import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/utils/functions.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  ProductsBloc productsBloc;
  ProductModel product = new ProductModel();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);

    final ProductModel productData = ModalRoute.of(context).settings.arguments;
    if (productData != null) {
      product = productData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _uploadPicture,
          ),
          SizedBox(
            width: 13.0,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 13.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showImage(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                SizedBox(
                  height: 13.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createSaveButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.0),
      child: TextFormField(
        initialValue: product.title,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Product'),
        onSaved: (value) => product.title = value,
        validator: (value) {
          if (value.length < 3) {
            return 'Product must contains more than 3 letters';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _createPrice() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.0),
      child: TextFormField(
        initialValue: product.price.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Price'),
        onSaved: (value) => product.price = double.parse(value),
        validator: (value) {
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Price only accepts numbers';
          }
        },
      ),
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      activeColor: Color.fromRGBO(90, 70, 178, 1.0),
      value: product.available,
      title: Text('Available'),
      onChanged: (value) {
        setState(() {
          product.available = value;
        });
      },
    );
  }

  Widget _createSaveButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      color: Color.fromRGBO(90, 70, 178, 1.0),
      label: Text(
        'Save',
      ),
      textColor: Colors.white,
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      onPressed: (_saving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.urlPhoto = await productsBloc.uploadPhoto(photo);
    }

    if (product.id == null) {
      productsBloc.addProduct(product);
    } else {
      productsBloc.editProduct(product);
    }

    setState(() {
      _saving = false;
    });

    // showSnackbar('Saved');

    Navigator.pop(context);
    
  }

  // void showSnackbar(String message) {
  //   final snackbar = SnackBar(
  //     content: Text(message),
  //     duration: Duration(milliseconds: 1500),
  //   );
  //   scaffoldKey.currentState.showSnackBar(snackbar);
  // }

  _uploadPicture() async {
    _processsPicture(ImageSource.gallery);
  }

  _takePhoto() async {
    _processsPicture(ImageSource.camera);
  }

  _processsPicture(ImageSource origin) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: origin,
    );

    photo = File(pickedFile.path);

    if (photo != null) {
      product.urlPhoto = null;
    }

    setState(() {});
  }

  Widget _showImage() {
    if (product.urlPhoto != null) {
      return ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        ),
        child: FadeInImage(
          placeholder: AssetImage('assets/images/original1.gif'),
          image: NetworkImage(product.urlPhoto),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        ),
        child: Container(
          width: double.infinity,
          child: Image(
            image: AssetImage(photo?.path ?? 'assets/images/no_image2.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      );
    }
  }
}
