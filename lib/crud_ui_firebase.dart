import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CRUDModelFB extends StatefulWidget {
  CRUDModelFB({Key? key}) : super(key: key);

  @override
  _CRUDModelFBState createState() => _CRUDModelFBState();
}

class _CRUDModelFBState extends State<CRUDModelFB> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  CollectionReference _productss =
      FirebaseFirestore.instance.collection('products');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 5,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text(action == 'create' ? 'Create' : 'Update'),
                    onPressed: () async {
                      final String? name = _nameController.text;
                      final double? price =
                          double.tryParse(_priceController.text);
                      if (name != null && price != null) {
                        if (action == 'create') {
                          // Persist a new product to Firestore
                          await _productss.add({"name": name, "price": price});
                        }

                        if (action == 'update') {
                          // Update the product
                          await _productss
                              .doc(documentSnapshot!.id)
                              .update({"name": name, "price": price});
                        }

                        // Clear the text fields
                        _nameController.text = '';
                        _priceController.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('You have successfully deleted a product'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Live update'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _productss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  color: Colors.redAccent[100],
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: Icon(Icons.add),
      ),
    );
  }
}
