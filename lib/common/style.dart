import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class Styles {
  static const double otpFieldWidth = 45.0;
  static const double otpFieldHeight = 60.0;

  static const Size textButtonSize = Size(double.infinity, 40);

  static const sizedBox = SizedBox();
  static const sizedBoxH02 = SizedBox(height: 2);
  static const sizedBoxW02 = SizedBox(width: 2);
  static const sizedBoxH04 = SizedBox(height: 4);
  static const sizedBoxW04 = SizedBox(width: 4);
  static const sizedBoxH08 = SizedBox(height: 8);
  static const sizedBoxW08 = SizedBox(width: 8);
  static const sizedBoxH10 = SizedBox(height: 10);
  static const sizedBoxW10 = SizedBox(width: 10);
  static const sizedBoxH15 = SizedBox(height: 15);
  static const sizedBoxW15 = SizedBox(width: 15);
  static const sizedBoxH20 = SizedBox(height: 20);
  static const sizedBoxW20 = SizedBox(width: 20);
  static const sizedBoxH30 = SizedBox(height: 30);
  static const sizedBoxW30 = SizedBox(width: 30);
  static const sizedBoxH40 = SizedBox(height: 40);
  static const sizedBoxW40 = SizedBox(width: 40);
  static const sizedBoxH50 = SizedBox(height: 50);
  static const sizedBoxW50 = SizedBox(width: 50);
  static const sizedBoxH60 = SizedBox(height: 60);
  static const sizedBoxW60 = SizedBox(width: 60);
  static const sizedBoxH100 = SizedBox(height: 100);
  static const sizedBoxW100 = SizedBox(width: 100);
  static const sizedBoxW06 = SizedBox(width: 6);
  static const sizedBoxH06 = SizedBox(height: 6);
  static const sizedBoxH35 = SizedBox(height: 35);

  static const edgeInsetsZero = EdgeInsets.zero;
  static const edgeInsetsAll04 = EdgeInsets.all(04);
  static const edgeInsetsAll05 = EdgeInsets.all(05);
  static const edgeInsetsAll08 = EdgeInsets.all(08);
  static const edgeInsetsAll10 = EdgeInsets.all(10);
  static const edgeInsetsAll13 = EdgeInsets.all(13);
  static const edgeInsetsAll15 = EdgeInsets.all(15);
  static const edgeInsetsAll20 = EdgeInsets.all(20);
  static const edgeInsetsAll25 = EdgeInsets.all(25);

  // Padding Vertical
  static const edgeInsetsOnlyH04 = EdgeInsets.symmetric(vertical: 04);
  static const edgeInsetsOnlyH06 = EdgeInsets.symmetric(vertical: 06);
  static const edgeInsetsOnlyH08 = EdgeInsets.symmetric(vertical: 08);
  static const edgeInsetsOnlyH10 = EdgeInsets.symmetric(vertical: 10);
  static const edgeInsetsOnlyH15 = EdgeInsets.symmetric(vertical: 15);
  static const edgeInsetsOnlyH20 = EdgeInsets.symmetric(vertical: 20);

  // Padding Horizontal
  static const edgeInsetsOnlyW04 = EdgeInsets.symmetric(horizontal: 04);
  static const edgeInsetsOnlyW06 = EdgeInsets.symmetric(horizontal: 06);
  static const edgeInsetsOnlyW08 = EdgeInsets.symmetric(horizontal: 08);
  static const edgeInsetsOnlyW10 = EdgeInsets.symmetric(horizontal: 10);
  static const edgeInsetsOnlyW15 = EdgeInsets.symmetric(horizontal: 15);
  static const edgeInsetsOnlyW20 = EdgeInsets.symmetric(horizontal: 20);
  static const edgeInsetsOnlyW22 = EdgeInsets.symmetric(horizontal: 22);
  static const edgeInsetsOnlyW30 = EdgeInsets.symmetric(horizontal: 30);
  static const edgeInsetsOnlyH15V4 =
      EdgeInsets.symmetric(vertical: 4, horizontal: 15);

  //Padding custom
  static EdgeInsets customEdgeInsets(int horizontal, int vertical) =>
      EdgeInsets.symmetric(vertical: vertical.h, horizontal: horizontal.w);

  // Border Radius
  static final borderRadiusCircular04 = BorderRadius.circular(04);
  static final borderRadiusCircular08 = BorderRadius.circular(08);
  static final borderRadiusCircular10 = BorderRadius.circular(10);
  static final borderRadiusCircular12 = BorderRadius.circular(12);
  static final borderRadiusCircular15 = BorderRadius.circular(15);
  static final borderRadiusCircular20 = BorderRadius.circular(20);
  static final borderRadiusCircular25 = BorderRadius.circular(25);
  static final borderRadiusCircular40 = BorderRadius.circular(40);
  static final borderRadiusCircular50 = BorderRadius.circular(50);
  static final borderRadiusCircular200 = BorderRadius.circular(200);
  static const radiusCircular04 = Radius.circular(04);
  static const radiusCircular08 = Radius.circular(08);
  static const radiusCircular12 = Radius.circular(12);
  static const radiusCircular25 = Radius.circular(25);
  static const visualCardBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20));

  // Decoration Underline input border
  static const underlineInputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white));
  static final inputBorderWithBorderRadius12 = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.grey600, width: 2),
      borderRadius: borderRadiusCircular12);

  static const outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.grey600),
  );
  static const outlineInputBorderFocus = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.primary),
  );
  static const outlineInputBorderExpenseFocus = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.alert),
  );
  static const outlineInputBorderIncomeFocus = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.primary),
  );
  static const outlineInputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.alertButtonColor),
  );
  static const outlineBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: AppColors.alertButtonColor),
  );
  static final outlineInputBorderNone = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  );
  static const outlineInputBorderOnlyNone = OutlineInputBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    borderSide: BorderSide.none,
  );

  static const edgeInsetsSV06 = EdgeInsets.symmetric(vertical: 6.0);
  static const edgeInsetsHeaderSearch = EdgeInsets.only(left: 15, right: 30);
  static const edgeInsetsAZList = EdgeInsets.only(left: 10, right: 25);
}
