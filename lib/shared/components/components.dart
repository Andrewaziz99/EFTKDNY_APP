import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Current screen exit during push (uses secondaryAnimation)
      var currentScreenExit = SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-0.3, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      );

      // New screen enter (uses animation)
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: currentScreenExit,
      );
    },
  ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,

  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Current screen exit during push (uses secondaryAnimation)
      var currentScreenExit = SlideTransition(
      position: Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-0.3, 0.0),
      ).animate(secondaryAnimation),
      child: child,
      );

      // New screen enter (uses animation)
      return SlideTransition(
      position: Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
      ).animate(animation),
      child: currentScreenExit,
      );
    },
  ),
      (route) => false,
    );




Widget myDivider({color = Colors.amberAccent}) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: color,
      ),
    );

Widget myVerticalDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Container(
        width: 1.0,
        color: Colors.amberAccent,
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  double? fSize,
  Color tColor = Colors.white,
  required Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: tColor, fontSize: fSize),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? onTap,
  bool isPassword = false,
  IconData? prefix,
  IconData? suffix,
  bool isClickable = true,
  BorderRadius radius = BorderRadius.zero,
  Color borderColor = Colors.white,
  Color labelColor = Colors.white,
  Color textColor = Colors.white,
  Color prefixColor = Colors.white,
  Color suffixColor = Colors.white,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
        ),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix, color: suffixColor),
              )
            : null,
        border: OutlineInputBorder(borderRadius: radius),
      ),
    );

Widget newFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? suffixPressed,
  Function()? onTap,
  bool isPassword = false,
  IconData? prefix,
  IconData? suffix,
  bool isClickable = true,
  Color labelColor = Colors.white,
  Color textColor = Colors.white,
  Color prefixColor = Colors.white,
  BorderRadius radius = BorderRadius.zero,
  int? maxLines,
}) =>
    TextFormField(
      scrollPhysics: const BouncingScrollPhysics(),
      maxLines: maxLines,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
        ),
        prefixIcon: Icon(prefix, color: prefixColor),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
      ),
    );

buildSettingItem({
  required IconData icon,
  required String text,
  required Function function,
  Color textColor = Colors.white,
  Color iconColor = Colors.white,
}) =>
    InkWell(
      onTap: () {
        function();
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: iconColor,
            ),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: iconColor,
            ),
          ],
        ),
      ),
    );

Future showLoadingDialog(context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(loading),
          ],
        ),
      ),
    );

class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu({
    super.key,
    required this.controller,
    required this.screenWidth,
    required this.screenRatio,
    required this.entries,
    required this.onSelected,
    this.title = '',
    this.showTitle = true,
    this.textColor = Colors.black,
    this.titleColor = Colors.black,
    this.textSize = 20,
    this.titleSize = 20,
    this.space = 10,
  });

  final String title;
  final Color textColor;
  final Color titleColor;
  final double textSize;
  final double titleSize;
  final TextEditingController controller;
  final double screenWidth;
  final double screenRatio;
  final List<DropdownMenuEntry> entries;
  final bool showTitle;

  // ignore: prefer_typing_uninitialized_variables
  final onSelected;
  final double space;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (showTitle)
        Container(
            margin: const EdgeInsets.all(5),
            child: Text(title,
                style: TextStyle(fontSize: titleSize, color: titleColor))),
        SizedBox(
          height: space,
        ),
        SizedBox(
          width: max(screenWidth * screenRatio, 300),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: DropdownMenu(
                textStyle: TextStyle(
                    fontSize: textSize, fontFamily: "Cairo", color: textColor),
                requestFocusOnTap: true,
                controller: controller,
                menuHeight: 200,
                enableFilter: true,
                onSelected: onSelected,
                width: screenWidth * screenRatio - 2 * 10,
                dropdownMenuEntries: entries,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

Widget loadingDialog(BuildContext context) {
  return Center(
    child: AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0, // Removes shadow
      content: Column(
        mainAxisSize: MainAxisSize.min, // Makes the column take minimum space
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(
              image: AssetImage('assets/images/gifs/loading.gif'),
              width: 120,
              height: 120),
          SizedBox(height: 10),
          Text(
            loading,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Cairo'),
          ),
        ],
      ),
    ),
  );
}
