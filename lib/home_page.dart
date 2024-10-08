import 'package:data_base_user_data_insert_quairy/data_base/dbhelper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DBHelper dbHelper = DBHelper.getInstance();

  List<Map<String, dynamic>> allNoteDB = [];
  @override
  void initState() {
    super.initState();

    getMyNotesDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("home"),
      ),
      body: allNoteDB.isNotEmpty
          ? ListView.builder(
              itemCount: allNoteDB.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(allNoteDB[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNoteDB[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Notes yet"),
                  OutlinedButton(
                       onPressed: () {
                        titleController.clear();
                        descController.clear();
                        showModalBottomSheet(
                            enableDrag: false,
                            isDismissible: false,
                            context: context,
                            builder: (_) {
                              return Container(
                                height: MediaQuery.of(context).size.height *
                                        0.8 +
                                    MediaQuery.of(context).viewInsets.bottom,
                                padding: EdgeInsets.only(
                                  left: 11,
                                  right: 11,
                                  bottom: 11 +
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Add Note",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 12, right: 12),
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            labelText: "Title",
                                            hintText: "Title Note"),
                                        controller: titleController,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 12, right: 12),
                                      child: TextField(
                                        controller: descController,
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            labelText: "Desc",
                                            hintText: "Enter Desc"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            child: OutlinedButton(
                                                onPressed: () async {
                                                  // dono Empty nahi hona chahiya tabhi add note call hoga
                                                  if (titleController
                                                          .text.isNotEmpty &&
                                                      descController
                                                          .text.isNotEmpty) {
                                                    // Add note mila hai to true hoga
                                                    bool check =
                                                        await dbHelper.addNote(
                                                            title:
                                                                titleController
                                                                    .text,
                                                            desc: descController
                                                                .text);

                                                    if (check) {
                                                      getMyNotesDB();
                                                      // agar getMyNotesDB hua hai to Navigator.pop karna hai bhar jane k liya
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                                child: Text("Add Note"))),
                                        Container(
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"))),
                                        SizedBox(
                                          width: 40,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: Text("Add first Note"))
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.clear();
          showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (_) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5 +
                        MediaQuery.of(context).viewInsets.bottom,
                    padding: EdgeInsets.only(
                      left: 11,
                      right: 11,
                      bottom: 11 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Add Note",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                labelText: "Title",
                                hintText: "Title Note"),
                            controller: titleController,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12, right: 12),
                          child: TextField(
                            controller: descController,
                            maxLines: 2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                labelText: "Description",
                                hintText: "Description"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                                child: OutlinedButton(
                                    onPressed: () async {
                                      if (titleController.text.isNotEmpty &&
                                          descController.text.isNotEmpty) {
                                        bool check = await dbHelper.addNote(
                                            title: titleController.text,
                                            desc: descController.text);

                                        if (check) {
                                          getMyNotesDB();

                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    child: Text("Add Note"))),
                            Container(
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"))),
                            SizedBox(
                              width: 40,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void getMyNotesDB() async {
    allNoteDB = await dbHelper.getAllNotes();

    setState(() {});
  }
}
