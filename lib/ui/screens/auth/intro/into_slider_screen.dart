import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../../business/auth/introController/IntroController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../../data/model/auth/introModel/IntroResponse.dart';

class IntoSliderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntoSliderScreenState();
  }
}

class _IntoSliderScreenState extends State<IntoSliderScreen> {
  List<ContentConfig> slides = [];
  final introController = Get.put(IntroController());

  @override
  void initState() {
    super.initState();
    /*introController.getIntroData().then((response) {
      // if (response.statusCode == 200) {
        setState(() {
          introController.introList.forEach((intro) {
            slides.add(
              ContentConfig(
                title: intro.title!,
                description: intro.content!,
                pathImage: intro.image!,
              ),
            );
          });
        });
      // } else {
      //   // Handle error
      // }
    });*/
    slides.add(
       ContentConfig(
        title: 'fast'.tr(),
        description:
        'all_cleaning'.tr(),
        pathImage: "assets/intro1.svg",
      ),
    );
    slides.add(
      ContentConfig(
        title: 'easy'.tr(),
        description:
        'simply_login'.tr(),
        pathImage: "assets/intro2.svg",
      ),
    );
    slides.add(
      ContentConfig(
        title: 'better'.tr(),
        description:
        'our_experience'.tr(),
        pathImage: "assets/intro3.svg",
      ),
    );
  }

  List<Widget> generateListCustomTabs() {
    return slides.map((slide) {
      return Container(
        margin: const EdgeInsetsDirectional.only(start: 20, end: 20),
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 3.h),
            SvgPicture.asset(slide.pathImage!,width: MediaQuery.of(context).size.width,height: 50.h,),
            // Image.asset(
            //   slide.pathImage!,
            //   width: MediaQuery.of(context).size.width,
            //   height: 40.h,
            // ),
            SizedBox(height: 2.h),
            Center(
              child: Text(
                slide.title!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontFamily: 'lexend_extraBold',
                  fontWeight: FontWeight.w800,
                  color: MyColors.Dark1,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              slide.description!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'lexend_extraBold',
                fontWeight: FontWeight.w300,
                color: MyColors.Dark2,),
            ),
          ],
        ),
      );
    }).toList();
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(MyColors.MainColor),
      foregroundColor: MaterialStateProperty.all<Color>(MyColors.MainColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*if (slides.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }*/
    return Scaffold(
      body: Container(
        color: MyColors.BackGroundColor,
        margin: EdgeInsetsDirectional.only(start: 1.h, end: 1.h),
        child: IntroSlider(
          key: UniqueKey(),
          listContentConfig: slides,
          renderSkipBtn: Text(
            'skip'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'lexend_regular',
              fontWeight: FontWeight.w400,
              color: MyColors.Dark2,
            ),
          ),
          renderNextBtn: Text(
            'continue'.tr(),
            style: TextStyle(
              fontSize: 9.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          nextButtonStyle: myButtonStyle(),
          renderDoneBtn: Text(
            'login'.tr(),
            style: TextStyle(
              fontSize: 9.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          onDonePress: onDonePress,
          doneButtonStyle: myButtonStyle(),
          indicatorConfig: IndicatorConfig(
            sizeIndicator: 1.2.h,
            colorActiveIndicator: MyColors.SecondryColor,
            colorIndicator: MyColors.SecondryColor,
            typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
          ),
          listCustomTabs: generateListCustomTabs(),
          scrollPhysics: BouncingScrollPhysics(),
          backgroundColorAllTabs: Colors.white,
        ),
      ),
    );
  }

  void onDonePress() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/Login_screen",
      ModalRoute.withName('/Login_screen'),
    );
  }
}