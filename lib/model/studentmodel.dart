class Student {
  String studentimage;
  String name;
  int age;
  String course;

  Student({
    required this.studentimage,
    required this.name,
    required this.age,
    required this.course,
  });
  @override
  String toString() {
    return 'Student(name: $name, age: $age, course: $course, image: $studentimage)';
  }

factory Student.fromJson(Map<String,dynamic> json) {
    return Student(studentimage: json['studentimage'], name: json['name'], age: json['age'], course: json['course']);
}

Map<String,dynamic> tojson() {
return {
   "studentimage" : studentimage,
   "name" : name,
   "age" : age,
  "course" : course

  };
}
}