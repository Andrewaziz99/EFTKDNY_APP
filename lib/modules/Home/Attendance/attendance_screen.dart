import 'package:cached_network_image/cached_network_image.dart';
import 'package:eftkdny/modules/Home/cubit/cubit.dart';
import 'package:eftkdny/modules/Home/cubit/states.dart';
import 'package:eftkdny/shared/components/components.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../../../shared/components/constants.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocConsumer<HomeCubit, HomeStates>(
        builder: (BuildContext context, state) {
          final cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 2.0,
              bottom: TabBar(
                physics: ClampingScrollPhysics(),
                labelColor: Colors.white,
                dividerColor: Colors.white,
                indicatorColor: Colors.white,
                automaticIndicatorColorAdjustment: true,
                isScrollable: true,
                tabAlignment: TabAlignment.start,

                tabs: [
                  Tab(
                    text: friday_attendance,
                  ),
                  Tab(
                    text: hymns_attendance,
                  ),
                  Tab(
                    text: bible_attendance,
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            body: TabBarView(
              children: [
                buildAttendanceScreen(cubit, 'Friday', friday_attendance),
                buildAttendanceScreen(cubit, 'Hymns', hymns_attendance),
                buildAttendanceScreen(cubit, 'Bible', bible_attendance),
              ],
            ),
          );
        },
        listener: (BuildContext context, state) {
          final cubit = HomeCubit.get(context);

          if (state is takeAttendanceLoadingState) {
            showDialog(
                context: context, builder: (context) => loadingDialog(context));
          }

          if (state is takeAttendanceSuccessState) {
            Toastification().show(
              context: context,
              style: ToastificationStyle.fillColored,
              showIcon: true,
              icon: Icon(Icons.check_circle, color: Colors.green),
              title: Text(attendanceDone),
              type: ToastificationType.success,
              autoCloseDuration: Duration(seconds: 2),
            );
            Navigator.pop(context);
            cubit.getAttendance('Friday');
            cubit.getAttendance('Hymns');
            cubit.getAttendance('Bible');
          }

          if (state is getAttendanceSuccessState) {
            // Navigator.pop(context);
          }

          if (state is getAttendanceErrorState ||
              state is takeAttendanceErrorState) {
            Navigator.pop(context);
            Toastification().show(
              context: context,
              style: ToastificationStyle.fillColored,
              showIcon: true,
              icon: Icon(Icons.error, color: Colors.red),
              title: Text(error),
              type: ToastificationType.error,
              autoCloseDuration: Duration(seconds: 2),
            );
          }
        },
      ),
    );
  }
}

Widget buildAttendanceScreen(HomeCubit cubit, String attendanceType, String Title) {
  final childrenList = cubit.Children;
  return Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        'assets/images/pattern.png',
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            if (childrenList.isEmpty)
              Center(
                child: Text(
                  noChildrenLeft,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: childrenList.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    ListTile(
                      title: Text(childrenList[index].name!),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            childrenList[index].image ?? ''),
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        child: childrenList[index].image != null
                            ? null
                            : Icon(
                                Icons.person,
                                size: 50.0,
                                color: Colors.blue,
                              ),
                      ),
                      trailing: IconButton(
                        icon: childrenList[index].isSelected!
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.circle_outlined),
                        onPressed: () {
                          cubit.toggleChildSelection(childrenList[index]);
                          if (childrenList[index].isSelected!) {
                            cubit.selectedChildren.add(childrenList[index]);
                          } else {
                            cubit.selectedChildren.remove(childrenList[index]);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    myDivider(color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            if (childrenList.isNotEmpty &&
                cubit.selectedChildren.isNotEmpty)
              defaultButton(
                function: () {
                  cubit.takeAttendance(cubit.selectedChildren, attendanceType);
                },
                text: '$submit $Title',
                background: Colors.blue,
                width: double.infinity,
                radius: 10.0,
                fSize: 20.0,
              ),
          ],
        ),
      ),
    ],
  );
}
