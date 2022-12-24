// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  List completedData = [];

  TextEditingController _textcontroller = new TextEditingController();

  addTask() async {
    if (_textcontroller.text.toString() != "") {
      await FirebaseFirestore.instance.collection("data").add({
        "task": _textcontroller.text.toString(),
        "isCompleted": false
      }).then((value) =>
          data.add([_textcontroller.text.toString(), false, false, value.id]));

      _textcontroller.clear();
      setState(() {});
    }
  }

  putData(String id, String task, bool isCompleted) async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(id)
        .update({"task": task, "isCompleted": isCompleted});
  }

  getData() async {
    setState(() {
      if (data.length > 0) {
        data = [data[0]];
      }
    });
    completedData = [];
    data = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("data").get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var snapshotData = querySnapshot.docs[i];
      if (snapshotData["isCompleted"]) {
        setState(() {
          completedData.add([
            snapshotData["task"],
            snapshotData["isCompleted"],
            false,
            snapshotData.id
          ]);
        });
      } else {
        setState(() {
          data.add([
            snapshotData["task"],
            snapshotData["isCompleted"],
            false,
            snapshotData.id
          ]);
        });
      }
    }
    print(data);

    await Future.delayed(Duration(milliseconds: 500));
    setState(() {});
    return "";
  }

  @override
  void initState() {
    future = getData();
    super.initState();
  }

  bool textEnable = true;
  late Future future;
  var textVal;
  late String taskdata = "saravanan";
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 212, 211, 211),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     addTask();
        //   },
        //   child: Icon(Icons.add),
        // ),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Container(
                    child: Text(
                      "To Do App",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          // ignore: sort_child_properties_last
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Type something here",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      // ignore: prefer_const_constructors
                                      BorderSide(
                                          color: Color.fromARGB(255, 2, 8, 13),
                                          width: 2.4),
                                ),
                                border: InputBorder.none,
                              ),
                              controller: _textcontroller,
                            ),
                          ),
                          margin: EdgeInsets.only(top: 30),
                          height: MediaQuery.of(context).size.height * .08,
                          width: MediaQuery.of(context).size.width * .70,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(61, 23, 24, 25)
                                    .withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 12,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          // ignore: prefer_const_constructors
                          child: Padding(
                            padding: const EdgeInsets.only(left: 17, top: 50),
                            // ignore: prefer_const_constructors
                            child: InkWell(
                              onTap: () {
                                addTask();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                child: Icon(
                                  Icons.add_box_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //     Snapshot.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .08,
                                      width: MediaQuery.of(context).size.width *
                                          .95,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(61, 23, 24, 25)
                                                    .withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 12,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () async {
                                                List Temp = data[index];
                                                await FirebaseFirestore.instance
                                                    .collection("data")
                                                    .doc(data[index][3])
                                                    .update(
                                                        {"isCompleted": true});
                                                getData();
                                                setState(() {});
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Color.fromARGB(
                                                      255, 14, 7, 7),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // color: Colors.red,
                                            height: 17,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            child: TextFormField(
                                              enabled: data[index][2],
                                              onEditingComplete: () {
                                                data[index][2] =
                                                    !data[index][2];
                                                node.unfocus();
                                                putData(
                                                    data[index][3],
                                                    data[index][0],
                                                    data[index][1]);
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  data[index][0] = value;
                                                });
                                              },
                                              initialValue: data[index][0],
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide:
                                                      // ignore: prefer_const_constructors
                                                      BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.4),
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 0.7),
                                            child: InkWell(
                                              onTap: () {
                                                node.unfocus();
                                                setState(() {
                                                  data[index][2] =
                                                      !data[index][2];
                                                });
                                              },
                                              child: Container(
                                                child: Icon(
                                                  size: 30,
                                                  Icons.edit,
                                                  color: Color.fromARGB(
                                                      255, 14, 7, 7),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  textEnable = true;
                                                });
                                              },
                                              child: InkWell(
                                                onTap: () async {
                                                  print(data[index][0]);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("data")
                                                      .doc(data[index][3])
                                                      .delete();
                                                  getData();

                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: Icon(
                                                    Icons.delete_outline_sharp,
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 14, 7, 7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: completedData.length,
                                itemBuilder: (context, index) {
                                  // final DocumentSnapshot documentSnapshot =
                                  //     Snapshot.data!.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .08,
                                      width: MediaQuery.of(context).size.width *
                                          .95,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 221, 17, 17),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(61, 23, 24, 25)
                                                    .withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 12,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                color: Color.fromARGB(
                                                    255, 14, 7, 7),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // color: Colors.red,
                                            height: 17,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            child: TextFormField(
                                              enabled: completedData[index][2],
                                              onEditingComplete: () {
                                                putData(
                                                    completedData[index][3],
                                                    completedData[index][0],
                                                    completedData[index][1]);
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  completedData[index][0] =
                                                      value;
                                                });
                                              },
                                              initialValue: completedData[index]
                                                  [0],
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide:
                                                      // ignore: prefer_const_constructors
                                                      BorderSide(
                                                          color: Colors.blue,
                                                          width: 2.4),
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 0.7),
                                            child: InkWell(
                                              onTap: () {
                                                // node.unfocus();
                                                // setState(() {
                                                //   completedData[index][2] =
                                                //       !completedData[index][2];
                                                // });
                                              },
                                              child: Container(
                                                child: Icon(
                                                  size: 30,
                                                  Icons.edit,
                                                  color: Color.fromARGB(
                                                      255, 14, 7, 7),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  textEnable = true;
                                                });
                                              },
                                              child: InkWell(
                                                onTap: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("data")
                                                      .doc(completedData[index]
                                                          [3])
                                                      .delete();
                                                  getData();

                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: Icon(
                                                    Icons.delete_outline_sharp,
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 14, 7, 7),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
