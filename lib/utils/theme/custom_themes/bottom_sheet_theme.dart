import 'package:flutter/material.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  static BottomSheetThemeData lightButtonSheetStyle = BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    showDragHandle: true,
    modalBackgroundColor: Colors.white,
    constraints: BoxConstraints(minHeight: double.infinity),
  );

  static BottomSheetThemeData darkButtonSheetStyle = BottomSheetThemeData(
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    showDragHandle: true,
    modalBackgroundColor: Colors.black,
    constraints: BoxConstraints(minHeight: double.infinity),
  );
}
