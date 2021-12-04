import 'package:flutter/material.dart';
import 'package:multifuncapp/sql_helper.dart';

class CrudModel extends StatefulWidget {
  CrudModel({Key? key}) : super(key: key);

  @override
  _CrudModelState createState() => _CrudModelState();
}

class _CrudModelState extends State<CrudModel> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  // Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted an item!'),
    ));
    _refreshJournals();
  }

// This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 5,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 600,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save new journal
                        if (_titleController.text.isNotEmpty) {
                          if (id == null) {
                            await _addItem();
                          }
                        }

                        if (id != null) {
                          await _updateItem(id);
                        }

                        // Clear the text fields
                        _titleController.text = '';
                        _descriptionController.text = '';

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    ),
                  ],
                ),
              ),
            ));
  }

  void filterSeach(String query) async {
    var dummySearchList = _journals;
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      dummySearchList.forEach((item) {
        String title = item['title'];
        if (title.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _journals = dummyListData;
      });
      return;
    } else {
      _refreshJournals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     tooltip: 'Search',
        //     onPressed: () {},
        //   ),
        // ],
      ),
      // body: _isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         itemCount: _journals.length,
      //         itemBuilder: (context, index) => Card(
      //           color: Colors.blueAccent,
      //           margin: const EdgeInsets.all(15),
      //           child: ListTile(
      //             title: Text(_journals[index]['title']),
      //             subtitle: Text(_journals[index]['description']),
      //             trailing: SizedBox(
      //                 width: 100,
      //                 child: Row(
      //                   children: [
      //                     IconButton(
      //                       icon: const Icon(Icons.edit),
      //                       onPressed: () => _showForm(_journals[index]['id']),
      //                     ),
      //                     IconButton(
      //                       icon: const Icon(Icons.delete),
      //                       onPressed: () =>
      //                           _deleteItem(_journals[index]['id']),
      //                     ),
      //                   ],
      //                 )),
      //           ),
      //         ),
      //       ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                filterSeach(val);
              },
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: 'Search...',
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  )),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.blueAccent[100],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_journals[index]['title']),
                  subtitle: Text(_journals[index]['description']),
                  trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
