import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/product_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProduct();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          _createButton(context),
        ],
      ),
      body: _createList(productsBloc),      
    );
  }

  Widget _createList(ProductsBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if (snapshot.hasData) {
          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) => _createItem(context, productsBloc, products[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductsBloc productsBloc, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.0),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => productsBloc.deleteProduct(product.id),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.0),      
        ),
        margin: EdgeInsets.symmetric(vertical: 11.0, horizontal: 11.0),    
        elevation: 1.0,
        semanticContainer: true,
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (product.urlPhoto == null)
                  ? Image(image: AssetImage('assets/images/no_image2.png'), )
                  : FadeInImage(
                      placeholder: AssetImage('assets/images/original1.gif'),
                      image: NetworkImage(product.urlPhoto),
                      // height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,                      
                  ),
              ListTile(
                  title: Text(
                    '${product.title}'
                  ),
                  subtitle: Text(
                    '\$${product.price}'
                  ),
                  trailing: Icon(Icons.edit),                  
                  onTap: () => Navigator.pushNamed(context, 'product', arguments: product).then((value){ setState(() {}); }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product').then((value) { setState(() {}); }),
    );
  }
}
