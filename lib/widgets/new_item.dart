import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/category.dart';
import 'package:shopping_list/models/categories.dart';
import 'package:shopping_list/models/grocery.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  void _addItem(BuildContext context) {
    // Navigator.of(context).push(MaterialPageRoute(builder: builder))
  }

  final _formkey = GlobalKey<FormState>();
  // Global key is generic <dynamic> and is used to so that form mmaintains its internal
  // interanal state while build..
  // two types of keys global key and Value key
  // final _formkey = ValueKey();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables];

  void _saveitem() async {
    final url = Uri.https(
        'flutter-firebase-codelab-e8905-default-rtdb.firebaseio.com',
        'shopping-list.json');
    _formkey.currentState!.validate();
    _formkey.currentState!.save();
    // onSaved parameter will be executed whenever this method (save()) gets called...
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCategory!.title,
        },
      ),
    );

    print(response.body);
    print(response.statusCode);

    if (!context.mounted) { 
      return;
    }

    Navigator.of(context).pop();
    // Navigator.of(context).pop(
    //   GroceryItem(
    //     id: DateTime.now().toString(),

    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key:
              _formkey, // key parameter is added to form //it is for all input fields inside form
          child: Column(
            children: [
              TextFormField(
                // instead of TextField
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be between 1 and 50 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be between 1 and 50 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      // onSaved: (value) {
                      //   _selectedCategory = value ;
                      // },
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        // setState(() {

                        // });
                        _selectedCategory = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formkey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveitem,
                    child: const Text("Add Item"),
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
