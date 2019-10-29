import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var isInit = true;
  var isLoading = false;
  final _pricefocusNode = FocusNode();
  final _descfocusNode = FocusNode();
  final _imageTextEditingController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  var _initvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _pricefocusNode.dispose();
    _descfocusNode.dispose();
    _imageTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _savedForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (err) {
        print(err);
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).errorColor,
                  title: Text('An Error has orccured'),
                  content: Text('Somthing went wrong.Please try again'),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        _editedProduct = Provider.of<Products>(context).findById(productID);
        _initvalues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageTextEditingController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savedForm,
          )
        ],
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initvalues['title'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_pricefocusNode),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descfocusNode),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      focusNode: _descfocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageTextEditingController.text.isEmpty
                              ? Text('Enter A URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageTextEditingController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            controller: _imageTextEditingController,
                            onFieldSubmitted: (_) => _savedForm(),
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
