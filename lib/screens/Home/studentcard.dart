import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentmanagment/model/studentmodel.dart';

class Studentcard extends StatelessWidget {
final Student studentdata;
final VoidCallback? deleteonTap;
final VoidCallback? editonTap;


const Studentcard({
   super.key,
  required this.studentdata,
  required this.deleteonTap,
  required this.editonTap
});
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(
                File(studentdata.studentimage),
              ),
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentdata.name,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 5),
                Text("Age: ${studentdata.age}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800,color: Colors.grey),),
                SizedBox(height: 5),
                Text("Course: ${studentdata.course}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800,color: Colors.grey),),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: deleteonTap,
                      child: Container(
                        width: 120,
                          height: 37,
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text("Delete",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),))
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: editonTap,
                      child: Container(
                          width: 120,
                          height: 37,
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text("Edit",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),))
                      ),
                    )
                  ],
                )
              ],
            )

          ],
        ),

      ),
    );
  }
}
