import 'package:flutter/material.dart';
import 'package:todolist/pages/add.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:todolist/pages/update_todolist.dart';

class Todolist extends StatefulWidget {
  // const Todolist({ Key? key }) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List todolistitems = [];
  @override
  void initState() {
    // ทำทุกครั้งที่มีการเปิดหน้านี้
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Todolist'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getTodolist();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
      ),
      body: todolistCreate(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()))
              .then((value) {
            setState(() {
              getTodolist();
            });
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todolistitems[index]['title']),
              onTap: () {
                // print(todolistitems[index]['id'].runtimeType);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePage(
                            todolistitems[index]['id'],
                            todolistitems[index]['title'],
                            todolistitems[index]['detail']))).then((value) => {
                      setState(() {
                        if (value == 'delete') {
                          final snackBar = SnackBar(
                            content: const Text('ลบรายการเรียบร้อยแล้ว'),
                          );
                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        getTodolist();
                      })
                    });
              },
            ),
          );
        });
  }

  Future<void> getTodolist() async {
    List alltodo = [];
    var url = Uri.http('192.168.1.78:8000', '/api/all-todolist');
    var response = await http.get(url);
    var resultUtf8 = utf8.decode(response.bodyBytes);
    var resultJson = json.decode(resultUtf8);
    // print(resultJson);
    setState(() {
      todolistitems = resultJson;
      ;
    });
  }
}
