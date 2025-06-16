// import 'package:hive_flutter/hive_flutter.dart';

// class HiveService {
//   var currentStudent;

//   Future<void> init() async {
//     // Initialize the database
//     var directory = await getApplicationDocumentsDirectory();
//     var path = '${directory.path}student_management.db';

//     Hive.init(path);

//     // Hive.registerAdapter(StudentHiveModelAdapter());

//     // Add Dummy Data
//     // await addBatchData();
//     // await addCourseData();

//     // clearAll();
//   }

//   // Login using username and password
//   Future<StudentHiveModel?> login(String username, String password) async {
//     var box = await Hive.openBox<StudentHiveModel>(
//       HiveTableConstant.studentBox,
//     );
//     var student = box.values.firstWhere(
//       (element) => element.username == username && element.password == password,
//       orElse: () => throw Exception('Invalid username or password'),
//     );
//     box.close();
//     currentStudent = student;
//     return student;
//   }

//   // Clear all data and delete database
//   Future<void> clearAll() async {
//     await Hive.deleteFromDisk();
//     await Hive.deleteBoxFromDisk(HiveTableConstant.batchBox);
//     await Hive.deleteBoxFromDisk(HiveTableConstant.courseBox);
//     await Hive.deleteBoxFromDisk(HiveTableConstant.studentBox);
//   }

//   Future<void> close() async {
//     await Hive.close();
//   }
// }
