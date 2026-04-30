import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanagment/model/studentmodel.dart';
import 'package:studentmanagment/screens/Home/studentcard.dart';
import 'package:studentmanagment/screens/login/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Student> studentdata = [];

  File? image;

  @override
  void initState() {
    super.initState();

    loadStudentData();
  }

  // IMAGE PICKER
  Future<void> getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage == null) return;

    setState(() {
      image = File(pickedImage.path);
    });
  }

  Future<void> savestudentData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> studentList =
        studentdata.map((student) {
          return jsonEncode({
            "studentimage": student.studentimage,

            "name": student.name,

            "age": student.age,

            "course": student.course,
          });
        }).toList();

    await prefs.setStringList("studentdata", studentList);

    print("Student Data Saved");
  }

  Future<void> loadStudentData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? studentList = prefs.getStringList("studentdata");

    if (studentList != null) {
      setState(() {
        studentdata =
            studentList.map((student) {
              final decodedData = jsonDecode(student);

              return Student(
                studentimage: decodedData["studentimage"],

                name: decodedData["name"],

                age: decodedData["age"],

                course: decodedData["course"],
              );
            }).toList();
      });

      print(studentdata);
    }
  }

  Future<void> Logoutopeartion() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("email");

    print("Logout is successfull");

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Management"),

        actions: [
          IconButton(
            onPressed: () {
              showStudentdataAlert(context);
            },

            icon: const Icon(Icons.add),
          ),

          IconButton(onPressed: () {
            Logoutopeartion();
          }, icon: const Icon(Icons.logout)),
        ],
      ),

      body: ListView.builder(
        itemCount: studentdata.length,

        itemBuilder: (context, index) {
          return Studentcard(
            studentdata: studentdata[index],

            deleteonTap: () async {
              setState(() {
                studentdata.removeAt(index);
              });

              await savestudentData();
            },

            editonTap: () {
              showStudentdataAlert(context, isEdit: true, index: index);
            },
          );
        },
      ),
    );
  }

  void showStudentdataAlert(
    BuildContext context, {
    bool isEdit = false,
    int? index,
  }) {
    final nameController = TextEditingController();

    final ageController = TextEditingController();

    final courseController = TextEditingController();

    // RESET IMAGE
    if (!isEdit) {
      image = null;
    }

    // EDIT DATA
    if (isEdit && index != null) {
      nameController.text = studentdata[index].name;

      ageController.text = studentdata[index].age.toString();

      courseController.text = studentdata[index].course;

      if (studentdata[index].studentimage.isNotEmpty) {
        image = File(studentdata[index].studentimage);
      }
    }

    showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: Text(isEdit ? "Edit Student" : "Add Student"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // IMAGE PICKER
                    GestureDetector(
                      onTap: () async {
                        final pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedImage != null) {
                          dialogSetState(() {
                            image = File(pickedImage.path);
                          });
                        }
                      },

                      child: CircleAvatar(
                        radius: 40,

                        backgroundImage:
                            image != null ? FileImage(image!) : null,

                        child:
                            image == null
                                ? const Icon(Icons.camera_alt, size: 30)
                                : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NAME
                    TextField(
                      controller: nameController,

                      decoration: const InputDecoration(
                        labelText: "Student Name",

                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // AGE
                    TextField(
                      controller: ageController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Age",

                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // COURSE
                    TextField(
                      controller: courseController,

                      decoration: const InputDecoration(
                        labelText: "Course",

                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      if (isEdit && index != null) {
                        // UPDATE
                        studentdata[index] = Student(
                          studentimage: image?.path ?? "",

                          name: nameController.text,

                          age: int.parse(ageController.text),

                          course: courseController.text,
                        );
                      } else {
                        // ADD
                        studentdata.add(
                          Student(
                            studentimage: image?.path ?? "",

                            name: nameController.text,

                            age: int.parse(ageController.text),

                            course: courseController.text,
                          ),
                        );
                      }
                    });

                    await savestudentData();

                    print(studentdata);

                    Navigator.pop(context);
                  },

                  child: Text(isEdit ? "Update" : "Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
