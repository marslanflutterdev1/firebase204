import 'package:firebase204/firebase/firestore_database/show_firestore_data.dart';
import 'package:firebase204/firebase/real_time_database/add_student_screen.dart';
import 'package:firebase204/firebase/real_time_database/update_student_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase204/widgets/reuseTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../firebase/storage/image_storage.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('students');
  TextEditingController searchController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool onTabSearch = false;

  signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
  // This is reuse Text Function,
  Padding reuseText(String? text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("$text", style: Utils.customTextStyle(fontSize: 20, fontFamily: 'airstrike'),),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        appBar: AppBar(
          title: IconButton(onPressed: (){setState(() {
            onTabSearch = !onTabSearch;
          });},icon: onTabSearch? reuseTextFormField(
              hintText: 'Search...',
              controller: searchController,
              textInputAction: TextInputAction.done,
              suffixIcon: const Icon(Icons.search_sharp,color: Colors.white,size: 30,),
              onChanged: (String value){setState(() {});},
            ): Row(children: [
              Text('home screen', style: Utils.customTextStyle(fontFamily: 'airstrike')),
              const Spacer(),
              IconButton(onPressed: (){setState(() {onTabSearch = !onTabSearch;});}, icon: const Icon(Icons.search_sharp,color: Colors.white,size: 30,),)
            ],
          ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Utils.bgColor,
          centerTitle: true,
        ),

        backgroundColor: Utils.primaryColor,
        body: StreamBuilder<DatabaseEvent>(
          stream: databaseReference.onValue,
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> asyncSnapshot) {
            if (asyncSnapshot.hasError) {
              Utils.flutterToastMsg(text: asyncSnapshot.error.toString());
              return const Center(child: Text('Something went wrong!'));
            } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Utils.bgColor, strokeWidth: 4),);
            } else if (asyncSnapshot.hasData && asyncSnapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> map = asyncSnapshot.data!.snapshot.value as dynamic;
              List<dynamic> studentDataList = [];
              studentDataList.clear();
              studentDataList = map.values.toList();

              // Filter the student data based on the search content.
              if (searchController.text.isNotEmpty) {
                 studentDataList = studentDataList.where((student) {
                  String rollNo = student['RollNo'].toString().toLowerCase();
                  String name = student['Name'].toString().toLowerCase();
                  String degree = student['Degree'].toString().toLowerCase();
                  String year = student['Year'].toString().toLowerCase();
                 // String searchText = searchController.text.toLowerCase();
                  return rollNo.contains(searchController.text.toLowerCase().toString()) ||
                         name.contains(searchController.text.toLowerCase().toString()) ||
                         degree.contains(searchController.text.toLowerCase().toString()) ||
                         year.contains(searchController.text.toLowerCase().toString());
                }).toList();
              }
              if (studentDataList.isEmpty) {
                return const Center(child: Text('No students found.'));
              }
              return ListView.separated(
                itemCount: studentDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Utils.bgColor,
                      border: Border.all(width: 2, color: Utils.textColor!),
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reuseText("RollNo :  ${studentDataList[index]['RollNo']}"),
                        reuseText("Name :  ${studentDataList[index]['Name']}"),
                        reuseText("Degree :  ${studentDataList[index]['Degree']}"),
                        reuseText("Year :  ${studentDataList[index]['Year']}"),
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(onPressed: ()async{
                              // this for update
                              String rollNo = studentDataList[index]['RollNo'].toString();
                              String name = studentDataList[index]['Name'].toString();
                              String degree = studentDataList[index]['Degree'].toString();
                              String year = studentDataList[index]['Year'].toString();
                              String id = studentDataList[index]['id'].toString();
                            await  Navigator.pushReplacement(context,MaterialPageRoute(builder: (e)=>UpdateStudentScreen(
                                rollNo: rollNo,
                                name: name,
                                degree: degree,
                                year: year,
                                id: id,
                              )));
                            }, icon: const Icon(Icons.edit,color: Colors.yellowAccent,size: 30,),),
                            const SizedBox(width: 20,),
                            IconButton(onPressed: (){
                              String id = studentDataList[index]['id'].toString();
                              setState(()async {
                                await databaseReference.child(id).remove();
                              });
                            }, icon: const Icon(Icons.delete,color: Colors.red,size: 30,),)
                          ],
                        )
                      ],
                    ),
                  );

                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 4, color: Utils.primaryColor, thickness: 5.0);
                },
              );
            } else {
              return const Center(child: Text('No students found.'));
            }
          },
        ),
        // For more floating action button use Flutter_speed_dial package.
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 25.0),
          curve: Curves.bounceIn,
          overlayColor: Utils.primaryColor,
          overlayOpacity: 0.5,
          backgroundColor: Utils.bgColor,
          foregroundColor: Utils.textColor,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
                child:const Icon(Icons.add,color: Colors.white,size: 25,),
                backgroundColor: Utils.bgColor,
                label: 'Add Student',
                shape: const CircleBorder(),
                labelStyle: Utils.customTextStyle(color: Utils.bgColor,fontSize: 16, fontFamily: 'airstrike'),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (e) => const AddStudentScreen()));
                }
            ),
            SpeedDialChild(
              child:const Icon(Icons.navigate_next,color: Colors.white,size: 25,),
              backgroundColor: Utils.bgColor,
              shape: const CircleBorder(),
              label: 'Firestore Database',
              labelStyle: Utils.customTextStyle(color: Utils.bgColor,fontSize: 16, fontFamily: 'airstrike'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (e) => const ShowFirestoreData()));
              },
            ),
            SpeedDialChild(
              child:const Icon(Icons.navigate_next,color: Colors.white,size: 25,),
              backgroundColor: Utils.bgColor,
              shape: const CircleBorder(),
              label: 'Image Storage',
              labelStyle: Utils.customTextStyle(color: Utils.bgColor,fontSize: 16, fontFamily: 'airstrike'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (e) => const ImageStorage()));
              },
            ),
          ],
        ) ,

      ),
    );
  }

}
