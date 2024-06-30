import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/termsAndConditionController/TermsAndConditionController.dart';
import '../../../../conustant/my_colors.dart';
import '../../../widget/TermsAndContitionItem.dart';
import 'dart:math' as math;

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreen();
}

class _PrivacyPolicyScreen extends State<PrivacyPolicyScreen> {
  final privacyPolicyController = Get.put(TermsAndConditionController());
  final changeLanguageController = Get.put(ChangeLanguageController());

  @override
  void initState() {
    privacyPolicyController.getTermsAndConditions("privacy_policy");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.BackGroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.BackGroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))),
        title: Center(
          child: Text('privacy_policy'.tr(),
              style:  TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w400,
                  color: MyColors.MainColor)),
        ),
      ),
      body: Obx(() =>!privacyPolicyController.isLoading.value? Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Padding(
                            padding:  EdgeInsets.only(left: 2.h, right: 2.h),
                            child: Text(
                              textAlign: TextAlign.start,
                              'Welcome_to_app'.tr(),
                              style:  TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'lexend_bold',
                                  fontWeight: FontWeight.w800,
                                  color: MyColors.Dark1),
                            )),
                        Container(width: MediaQuery.of(context).size.width,
                          margin: EdgeInsetsDirectional.only(end: 1.h,start: 1.h,top: 2.h),
                          height: 0.2.h,
                          color: MyColors.Dark5,),
                        SizedBox(
                          height: 2.h,
                        ),
                        //termList(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: kk(),
                        ),
                      ]))),
          SizedBox(
            height: 3.h,
          )
        ],
      )
          :const Center(child: CircularProgressIndicator(color: MyColors.MainColor),)),
    );
  }

  Widget NoIntrnet(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/no_internet.png'),
          SizedBox(height: 10,),
          Text('there_are_no_internet'.tr(),
            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: MyColors.Dark1),
            textAlign: TextAlign.center,
          ),
        ],
      ),

    );
  }

  Widget termList(){
    return ListView.builder(
        physics:NeverScrollableScrollPhysics() ,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, int index) {
          return TermsAndContitionItem();
        });
  }

  Widget kk(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Flexible(
          child: Html(
            data: privacyPolicyController.termsAndConditionsResponse.value.data!.content??"",
          ),
        ),
      ],
    );
  }
}
