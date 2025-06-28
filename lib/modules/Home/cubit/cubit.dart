import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eftkdny/models/Answers/answers_model.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../../../models/Children/children_model.dart';
import '../../../models/User/user_model.dart';
import '../../../shared/components/constants.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<String> classNames = [];

  void getClassNames() {
    emit(getClassNamesLoadingState());
    FirebaseFirestore.instance.collection('className').get().then((value) {
      classNames.clear();
      classItems.clear();
      for (var element in value.docs) {
        classNames.add(element['name']);
        classItems.add(element['name']);
      }
      print(classItems);
      print(classNames);
      emit(getClassNamesSuccessState());
    }).catchError((error) {
      emit(getClassNamesErrorState(error));
    });
  }

  void changeChildData(ChildrenModel model) {
    childrenModel = model;
    emit(changeChildDataState());
  }

  UserModel? userModel;

  void getUserData() {
    emit(getUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(getUserDataSuccessState());
      getChildrenData();
    }).catchError((error) {
      emit(getUserDataErrorState());
    });
  }

  void updateEmailVerificationStatus(bool isVerified) {
    emit(updateEmailVerificationStatusLoadingState());
    if (userModel != null && userModel!.isEmailVerified != isVerified) {
      userModel!.isEmailVerified = isVerified;
      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'isEmailVerified': isVerified,
      }).then((value) {
        emit(updateEmailVerificationStatusSuccessState());
      }).catchError((error) {
        emit(updateEmailVerificationStatusErrorState(error.toString()));
      });
    }
  }

  ChildrenModel? childrenModel;

  List<ChildrenModel>? childrenList = [];

  void getChildrenData() {
    emit(getChildrenDataLoadingState());
    Children.clear();
    FirebaseFirestore.instance
        .collection('children')
        .where('className', isEqualTo: userModel!.className)
        .get()
        .then((value) {
      for (var element in value.docs) {
        childrenList!.add(ChildrenModel.fromJson(element.data()));
        Children.add(ChildrenModel.fromJson(element.data()));
      }
      emit(getChildrenDataSuccessState());
      getAttendance('Friday');
      getAttendance('Hymns');
    }).catchError((error) {
      emit(getChildrenDataErrorState());
    });
  }

  void toggleChildSelection(ChildrenModel model) {
    if (model.isSelected == true) {
      model.isSelected = false;
    } else {
      model.isSelected = true;
    }
    emit(toggleChildSelectionState());
  }

  void clearSelectedChildren() {
    for (var element in childrenList!) {
      element.isSelected = false;
    }
    emit(clearSelectedChildrenState());
  }

  List<ChildrenModel> selectedChildren = [];
  List<ChildrenModel> Children = [];

  void getAttendance(String attendanceType) {
    emit(getAttendanceLoadingState());
    selectedChildren.clear();
    FirebaseFirestore.instance
        .collection('attendance')
        .where('type', isEqualTo: attendanceType)
        .where('attended', isEqualTo: true)
        .where('date',
            isEqualTo: DateFormat('yyyy/MM/dd').format(DateTime.now()))
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        selectedChildren.add(ChildrenModel.fromJson(element.data()));
        Children.removeWhere((child) => child.name == element['name']);
      }
      emit(getAttendanceSuccessState());
    });
  }

  Future<void> getAttendanceByMonth(int month, String attendanceType) async {
    emit(getAttendanceByMonthLoadingState());
    selectedChildren.clear();
    // Calculate the start and end dates for the selected month in the current year
    final now = DateTime.now();
    final start = DateTime(now.year, month, 1);
    final end = DateTime(now.year, month + 1, 1).subtract(const Duration(days: 1));
    FirebaseFirestore.instance
        .collection('attendance')
        .where('type', isEqualTo: attendanceType)
        .where('attended', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy/MM/dd').format(start))
        .where('date', isLessThanOrEqualTo: DateFormat('yyyy/MM/dd').format(end))
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        selectedChildren.add(ChildrenModel.fromJson(element.data()));
        Children.removeWhere((child) => child.name == element['name']);
      }
      emit(getAttendanceByMonthSuccessState());
    });
  }

  Future<void> takeAttendance(selectedChildren, String attendanceType) async {
    emit(takeAttendanceLoadingState());
    selectedChildren =
        selectedChildren.where((child) => child.isSelected == true).toList();
    if (selectedChildren.isNotEmpty) {
      for (var element in selectedChildren) {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          //Save locally if no internet connection
          var box = await Hive.openBox('attendance');
          await box.add({
            'children': selectedChildren.map((e) => e.toMap()).toList(),
            'type': attendanceType,
            'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
          });
          emit(takeAttendanceSuccessState());
        } else {
          FirebaseFirestore.instance
            .collection('attendance')
            .doc()
            .set({
              'name': element.name,
              'image': element.image,
              'className': element.className,
              'attended': element.isSelected,
              'type': attendanceType,
              'date': DateFormat('yyyy/MM/dd').format(DateTime.now()),
              'metadata': {
                'recordedBy': uId, // Add your user ID if available
              }
            })
            .then((value) {})
            .catchError((error) {
              emit(takeAttendanceErrorState());
            });
        }
      }
      emit(takeAttendanceSuccessState());
    } else {
      emit(takeAttendanceErrorState());
    }
  }

  void listenForConnectivityAndSync(){
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        var box = await Hive.openBox('attendance');
        if (box.isNotEmpty) {
          for (var item in box.values) {
            var childrenData = item['children'] as List;
            for (var childData in childrenData) {
              await FirebaseFirestore.instance
                  .collection('attendance')
                  .doc()
                  .set({
                    'name': childData['name'],
                    'image': childData['image'],
                    'className': childData['className'],
                    'attended': childData['isSelected'],
                    'type': item['type'],
                    'date': item['date'],
                    'metadata': {
                      'recordedBy': uId, // Add your user ID if available
                    }
                  })
                  .catchError((error) {
                    emit(takeAttendanceErrorState());
                    print('Error syncing attendance: $error');
                  });
            }
          }
          await box.clear(); // Clear the local cache after syncing
        }
      }
    });
  }

  List<AnswersModel> answersList = [];

  void getAnswers(String childId) {
    emit(getAnswersLoadingState());
    FirebaseFirestore.instance
        .collection('answers')
        .where('childId', isEqualTo: childId)
        .get()
        .then((value) {
      answersList.clear();
      for (var element in value.docs) {
        answersList.add(AnswersModel.fromJson(element.data()));
      }
      emit(getAnswersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(getAnswersErrorState(error.toString()));
    });
  }

  var image = '';

  Future<void> pickImageFromGallery() async {
    emit(PickImageLoadingState());
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      // Reduce image file size
      final File originalFile = File(imageFile.path);
      final bytes = await originalFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        // Compress to 70% quality and resize if needed
        final compressedBytes = img.encodeJpg(decodedImage, quality: 70);
        final compressedFile = await originalFile.writeAsBytes(compressedBytes, flush: true);
        image = compressedFile.path;
        print(image);
        emit(PickImageSuccessState());
      } else {
        emit(PickImageErrorState('Failed to decode image'));
      }
    } else {
      emit(PickImageErrorState('No image selected'));
      return;
    }
  }

  Future<void> captureImage() async {
    emit(PickImageLoadingState());
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      // Reduce image file size
      final File originalFile = File(imageFile.path);
      final bytes = await originalFile.readAsBytes();
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        final compressedBytes = img.encodeJpg(decodedImage, quality: 70);
        final compressedFile = await originalFile.writeAsBytes(compressedBytes, flush: true);
        image = compressedFile.path;
        print(image);
        emit(PickImageSuccessState());
      } else {
        emit(PickImageErrorState('Failed to decode image'));
      }
    } else {
      emit(PickImageErrorState('No image selected'));
      return;
    }
  }

  String? imageUrl;

  Future<void> updateChildData({
    required String childId,
    required String name,
    required String birthDate,
    required String phone,
    required String address,
    required String className,
    String? imagePath,
  }) async {
    emit(updateChildDataLoadingState());

    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('children').doc(childId);

      // Check if a new image is provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('children').child('$name.jpg');

        final UploadTask uploadTask = storageReference.putFile(File(imagePath));
        final TaskSnapshot storageSnapshot = await uploadTask;
        imageUrl = await storageSnapshot.ref.getDownloadURL();
      }

      // Create an updated model
      ChildrenModel updatedModel = ChildrenModel(
        childId: childId,
        name: name,
        birthDate: birthDate,
        phone: phone,
        address: address,
        className: className,
        image:
            imageUrl, // Will use new image URL or retain old one if imagePath is null
      );

      // Update the document in Firestore
      await docRef.update(updatedModel.toMap());

      emit(updateChildDataSuccessState());
    } catch (error) {
      emit(updateChildDataErrorState(error.toString()));
      print(error);
    }
  }

  // Generates and previews a PDF of the attendance table
  Future<void> generateAttendancePdf(context, String attendanceType, int month) async {
    if (attendanceType == friday_attendance) {
      await getAttendanceByMonth(month, 'Friday').then((value) async {
        emit(generateAttendancePdfLoadingState());
        final pdf = pw.Document();
        // Load an Arabic font (Cairo is included in your assets)
        final font = pw.Font.ttf(await rootBundle.load('assets/fonts/cairo/Cairo-Regular.ttf'));
        final List<ChildrenModel> data = [];
        if (attendanceType == friday_attendance) {
          data.addAll(selectedChildren);
        } else if (attendanceType == hymns_attendance) {
          data.addAll(Children.where((child) => child.isSelected == true).toList());
        }
        if (data.isEmpty) {
          emit(generateAttendancePdfErrorState('لا يوجد بيانات للحضور'));
          return;
        }
        pdf.addPage(
          pw.Page(
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير  الحضور: $attendanceType', style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20.0),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // For horizontal table, each column is a vertical list
                    for (int col = 0; col < 3; col++)
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            pw.Container(
                              color: PdfColors.grey300,
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                ['الاسم', 'الأسرة', 'حضر'][col],
                                style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            // Data
                            ...data.map((child) {
                              final row = [
                                child.name ?? '',
                                child.className ?? '',
                                selectedChildren.any((selectedChild) => selectedChild.name == child.name) ? 'نعم' : 'لا',
                              ];
                              return pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                                  ),
                                ),
                                child: pw.Text(
                                  row[col],
                                  style: pw.TextStyle(font: font),
                                  textAlign: pw.TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
        emit(generateAttendancePdfSuccessState());
        await Printing.layoutPdf(onLayout: (format) async => pdf.save());
      });
    } else if (attendanceType == hymns_attendance) {
      await getAttendanceByMonth(month, 'Hymns').then((value) async {
        emit(generateAttendancePdfLoadingState());
        final pdf = pw.Document();
        // Load an Arabic font (Cairo is included in your assets)
        final font = pw.Font.ttf(await rootBundle.load('assets/fonts/cairo/Cairo-Regular.ttf'));
        final List<ChildrenModel> data = [];
        if (attendanceType == friday_attendance) {
          data.addAll(selectedChildren);
        } else if (attendanceType == hymns_attendance) {
          data.addAll(Children.where((child) => child.isSelected == true).toList());
        }
        if (data.isEmpty) {
          emit(generateAttendancePdfErrorState('لا يوجد بيانات للحضور'));
          return;
        }
        pdf.addPage(
          pw.Page(
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('تقرير  الحضور: $attendanceType', style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20.0),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // For horizontal table, each column is a vertical list
                    for (int col = 0; col < 3; col++)
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            pw.Container(
                              color: PdfColors.grey300,
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                ['الاسم', 'الأسرة', 'حضر'][col],
                                style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            // Data
                            ...data.map((child) {
                              final row = [
                                child.name ?? '',
                                child.className ?? '',
                                selectedChildren.any((selectedChild) => selectedChild.name == child.name) ? 'نعم' : 'لا',
                              ];
                              return pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                    bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                                  ),
                                ),
                                child: pw.Text(
                                  row[col],
                                  style: pw.TextStyle(font: font),
                                  textAlign: pw.TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
        emit(generateAttendancePdfSuccessState());
        await Printing.layoutPdf(onLayout: (format) async => pdf.save());
      });
    }
  }

  Future<List<ChildrenModel>> uploadAndParseChildrenCsv({bool saveToDatabase = false}) async {
    emit(readCsvFileLoadingState());
    try {
      // Pick CSV file
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result == null || result.files.single.path == null) {
        emit(readCsvFileErrorState('لم يتم اختيار ملف'));
        return [];
      }
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();
      final List<List<dynamic>> csvTable = CsvToListConverter(eol: '\n',shouldParseNumbers: false).convert(csvString);
      // Assuming first row is header
      final headers = csvTable.first.map((e) => e.toString()).toList();
      final dataRows = csvTable.skip(1);
      List<ChildrenModel> children = [];
      for (var row in dataRows) {
        if (row.every((cell) => cell == null || cell.toString().trim().isEmpty)) {
          continue; // Skip empty or null rows
        }
        Map<String, dynamic> rowMap = {};
        for (int i = 0; i < headers.length && i < row.length; i++) {
          final header = headers[i].toString().trim();
          rowMap[header] = row[i]?.toString().trim();
        }
        final child = ChildrenModel(
          name: rowMap['name'],
          birthDate: rowMap['birthDate'],
          phone: rowMap['phone'],
          AdditionalPhone: rowMap['AdditionalPhone'],
          address: rowMap['address'],
          className: rowMap['className'] ?? rowMap['ClassName'] ?? rowMap['class'] ?? rowMap['Class'],
        );
        children.add(child);
        if (saveToDatabase) {
          await FirebaseFirestore.instance.collection('children').add(child.toMap());
        }
      }
      emit(uploadAndParseCsvSuccessState());
      return children;
    } catch (e) {
      emit(uploadAndParseCsvErrorState('خطأ في قراءة الملف: $e'));
      return [];
    }
  }







}
