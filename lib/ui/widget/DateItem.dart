import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../conustant/my_colors.dart';
import '../../data/model/pickupDateModel/PickupDateResponse.dart';



class DateItem extends StatelessWidget {
  bool is_selected;
  GestureTapCallback? onTap;
  PickUpDate pickUpDate;

  DateItem({required this.is_selected,required this.onTap,required this.pickUpDate});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 14.h,
        padding: EdgeInsets.all(1.h),
        margin: EdgeInsetsDirectional.only(end: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          border: Border.all(color: MyColors.Dark5, width: 1.0,),
            color:is_selected?MyColors.SecondryColor: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(pickUpDate.date??"",
              style:  TextStyle(fontSize: 11.sp,
                  fontFamily: 'lexend_light',
                  fontWeight: FontWeight.w300,
                  color:is_selected?Colors.white: MyColors.Dark3),
            ),
            SizedBox(height: 1.h,),
            // Text("jun 21",
            //   style:  TextStyle(fontSize: 12.sp,
            //       fontFamily: 'lexend_regular',
            //       fontWeight: FontWeight.w400,
            //       color:is_selected?Colors.white: MyColors.Dark1),
            // ),
          ],
        ),
      ),
    );
  }


}