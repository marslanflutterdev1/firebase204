// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase204/firebase/firestore_database/add_firestore_data.dart';
// import 'package:firebase204/firebase/firestore_database/update_firestore_data.dart';
// import 'package:firebase204/ui/home/home_screen.dart';
// import 'package:firebase204/widgets/reuseTextFormField.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import '../../utils/utils.dart';
// class ShowFirestoreData extends StatefulWidget {
//   const ShowFirestoreData({super.key});
//
//   @override
//   State<ShowFirestoreData> createState() => _ShowFirestoreDataState();
// }
//
// class _ShowFirestoreDataState extends State<ShowFirestoreData> {
//   Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('student').snapshots();
//   TextEditingController searchController = TextEditingController();
//   bool isSearch = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: IconButton(
//           onPressed: (){setState(() {isSearch = !isSearch;});},
//           icon:isSearch ? reuseTextFormField(
//             controller: searchController,
//             textInputAction: TextInputAction.done,
//             hintText: 'search...',
//             suffixIcon:const Icon(Icons.search_sharp,color: Colors.white,size: 30,),
//             onChanged: (v){setState(() {});},
//           ): Row(
//             children: [
//               Text('Firestore data', style: Utils.customTextStyle(fontFamily: 'airstrike'),),
//               const Spacer(),
//               IconButton(onPressed: (){setState(() {isSearch = !isSearch;});}, icon: const Icon(Icons.search_sharp,color: Colors.white,size: 30,),),
//             ],)
//           ),
//         backgroundColor: Utils.bgColor,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//       ),
//       backgroundColor: Utils.primaryColor,
//       body: StreamBuilder<QuerySnapshot>(
//         stream: stream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
//           if (asyncSnapshot.hasError) {
//             return Center(child: Text('Error: ${asyncSnapshot.error}'));
//           } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator(color: Utils.bgColor, strokeWidth: 4));
//           } else if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
//             List<QueryDocumentSnapshot> newStudentDataList = asyncSnapshot.data!.docs;
//             // searching
//             if(searchController.text.isNotEmpty){
//               newStudentDataList = newStudentDataList.where((student){
//                 String rollNo = student['RollNo'].toString().toLowerCase();
//                 String name = student['Name'].toString().toLowerCase();
//                 return  rollNo.contains(searchController.text.toLowerCase())||
//                         name.contains(searchController.text.toLowerCase());
//               }).toList();
//             }else{
//               Utils.flutterToastMsg(text: 'No Found Student');
//             }
//
//
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: DataTable(
//                   headingRowHeight: 70,
//                   headingTextStyle: Utils.customTextStyle(color: Utils.textColor,fontSize: 18),
//                   headingRowColor:WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return Utils.bgColor;}),
//                   dataRowHeight: 60,
//                   dataTextStyle: Utils.customTextStyle(fontSize: 16),
//                   dataRowColor:WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {return Utils.bgColor;}),
//                  dividerThickness: 4,
//                   columns: [
//                     DataColumn(label: Text('RollNo', style: Utils.customTextStyle(fontFamily: 'airstrike', fontSize: 18))),
//                     DataColumn(label: Text('Name', style: Utils.customTextStyle(fontFamily: 'airstrike'))),
//                     DataColumn(label: Text('Action', style: Utils.customTextStyle(fontFamily: 'airstrike'))),
//                   ],
//                   rows: List<DataRow>.generate(
//                     newStudentDataList.length,
//                         (int index) {
//                       return DataRow(
//                         cells: [
//                           DataCell(Text(newStudentDataList[index]['RollNo'])),
//                           DataCell(Text(newStudentDataList[index]['Name'])),
//                            DataCell(
//                             Row(
//                               children: [
//                                 IconButton(onPressed: ()async{
//                                   String rollNo = newStudentDataList[index]['RollNo'].toString() ;
//                                   String name = newStudentDataList[index]['Name'].toString();
//                                   String id = newStudentDataList[index]['id'].toString();
//                                 await Navigator.pushReplacement(context, MaterialPageRoute(builder: (e)=> UpdateFirestoreData(
//                                    rollNo: rollNo,
//                                    name: name,
//                                    id: id,
//                                  )));
//                                 }, icon: const Icon(Icons.edit,color: Colors.yellowAccent,size: 30,),),
//                                // IconButton(onPressed: (){}, icon: const Icon(Icons.delete,color: Colors.red,size: 30,),)
//                               ],
//                             )
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//       floatingActionButton: SpeedDial(
//         animatedIcon: AnimatedIcons.menu_close,
//         animatedIconTheme: const IconThemeData(size: 22.0),
//         curve: Curves.bounceIn,
//         overlayColor: Utils.primaryColor,
//         overlayOpacity: 0.5,
//         backgroundColor: Utils.bgColor,
//         foregroundColor: Utils.textColor,
//         elevation: 8.0,
//         shape: const CircleBorder(),
//         children: [
//           SpeedDialChild(
//             child: const Icon(Icons.add, color: Colors.white, size: 25),
//             backgroundColor: Utils.bgColor,
//             label: 'Add Student',
//             shape: const CircleBorder(),
//             labelStyle: Utils.customTextStyle(color: Utils.bgColor, fontSize: 16, fontFamily: 'airstrike'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (e) => const AddFirestoreData()),
//               );
//             },
//           ),
//           SpeedDialChild(
//             child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
//             backgroundColor: Utils.bgColor,
//             shape: const CircleBorder(),
//             label: 'Back to Database',
//             labelStyle: Utils.customTextStyle(color: Utils.bgColor, fontSize: 16, fontFamily: 'airstrike'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (e) => const HomeScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

//llllllllllllllllll
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase204/firebase/firestore_database/add_firestore_data.dart';
import 'package:firebase204/firebase/firestore_database/update_firestore_data.dart';
import 'package:firebase204/ui/home/home_screen.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../utils/utils.dart';

class ShowFirestoreData extends StatefulWidget {
  const ShowFirestoreData({super.key});

  @override
  State<ShowFirestoreData> createState() => _ShowFirestoreDataState();
}

class _ShowFirestoreDataState extends State<ShowFirestoreData> {
  Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('student').snapshots();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('student');
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          onPressed: () {
            setState(() {
              isSearch = !isSearch;
            });
          },
          icon: isSearch
              ? reuseTextFormField(
                  controller: searchController,
                  textInputAction: TextInputAction.done,
                  hintText: 'search...',
                  suffixIcon: const Icon(Icons.search_sharp,
                      color: Colors.white, size: 30),
                  onChanged: (v) {
                    setState(() {});
                  },
                )
              : Row(
                  children: [
                    Text(
                      'Firestore data',
                      style: Utils.customTextStyle(fontFamily: 'airstrike'),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSearch = !isSearch;
                        });
                      },
                      icon: const Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
        ),
        backgroundColor: Utils.bgColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Utils.primaryColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Error: ${asyncSnapshot.error}'));
          } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Utils.bgColor, strokeWidth: 4));
          } else if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
            List<QueryDocumentSnapshot> newStudentDataList =
                asyncSnapshot.data!.docs;
            // searching
            if (searchController.text.isNotEmpty) {
              newStudentDataList = newStudentDataList.where((student) {
                String rollNo = student['RollNo'].toString().toLowerCase();
                String name = student['Name'].toString().toLowerCase();
                return rollNo.contains(searchController.text.toLowerCase()) ||
                    name.contains(searchController.text.toLowerCase());
              }).toList();
            } else {
              Utils.flutterToastMsg(text: 'No Found Student');
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  headingRowHeight: 70,
                  headingTextStyle: Utils.customTextStyle(
                      color: Utils.textColor, fontSize: 18),
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    return Utils.bgColor;
                  }),
                  dataRowHeight: 60,
                  dataTextStyle: Utils.customTextStyle(fontSize: 16),
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    return Utils.bgColor;
                  }),
                  dividerThickness: 4,
                  columns: [
                    DataColumn(
                        label: Text('RollNo',
                            style: Utils.customTextStyle(
                                fontFamily: 'airstrike', fontSize: 18))),
                    DataColumn(
                        label: Text('Name',
                            style: Utils.customTextStyle(
                                fontFamily: 'airstrike'))),
                    DataColumn(
                        label: Text('Action',
                            style: Utils.customTextStyle(
                                fontFamily: 'airstrike'))),
                  ],
                  rows: List<DataRow>.generate(
                    newStudentDataList.length,
                    (int index) {
                      return DataRow(
                        cells: [
                          DataCell(Text(newStudentDataList[index]['RollNo'])),
                          DataCell(Text(newStudentDataList[index]['Name'])),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    String rollNo = newStudentDataList[index]
                                            ['RollNo']
                                        .toString();
                                    String name = newStudentDataList[index]
                                            ['Name']
                                        .toString();
                                    String id = newStudentDataList[index].id;
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (e) => UpdateFirestoreData(
                                          rollNo: rollNo,
                                          name: name,
                                          id: id,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.yellowAccent,
                                    size: 30,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    String id = newStudentDataList[index].id;
                                    collectionReference.doc(id).delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Utils.primaryColor,
        overlayOpacity: 0.5,
        backgroundColor: Utils.bgColor,
        foregroundColor: Utils.textColor,
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white, size: 25),
            backgroundColor: Utils.bgColor,
            label: 'Add Student',
            shape: const CircleBorder(),
            labelStyle: Utils.customTextStyle(
                color: Utils.bgColor, fontSize: 16, fontFamily: 'airstrike'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (e) => const AddFirestoreData()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
            backgroundColor: Utils.bgColor,
            shape: const CircleBorder(),
            label: 'Back to Database',
            labelStyle: Utils.customTextStyle(
                color: Utils.bgColor, fontSize: 16, fontFamily: 'airstrike'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (e) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
