
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:trio_app/conustant/my_colors.dart';
import 'package:trio_app/conustant/toast_class.dart';

import '../../../../business/addressListController/AddressListController.dart';
import '../../../../business/changeLanguageController/ChangeLanguageController.dart';
import '../../../../business/createOrderController/CreateOrderController.dart';
import '../../../../business/dropOffController/DropOffController.dart';
import '../../../../business/homeController/HomeController.dart';
import '../../../../business/pickUpController/PickUpController.dart';
import '../../../../conustant/di.dart';
import '../../../../conustant/shared_preference_serv.dart';
import '../../buttomSheets/addressBottomSheet/choose_address.dart';
import '../../buttomSheets/dropDownTimeButtomSheet/drop_down_time_buttomSheet.dart';
import '../../buttomSheets/noteBottomSheet/add_note.dart';
import '../../buttomSheets/paymentBottomSheet/choose_payment.dart';
import '../../buttomSheets/promotionalCodeButtomSheet/Add_promotional_code.dart';
import '../../buttomSheets/timeBottomSheet/pickUp_Time.dart';
import '../../drowerMenu/drower.dart';
import 'dart:math' as math;


class NewOrderScreen extends StatefulWidget{
  var orderType;
  var orderTextNormal;
  var orderTextUrgent;
  NewOrderScreen(this.orderType,this.orderTextNormal,this.orderTextUrgent);
  @override
  State<StatefulWidget> createState() {
    return _NewOrderScreen();
  }
}

class _NewOrderScreen extends State<NewOrderScreen>{
  var isSelected=false;
  int? itemId=0;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  final createOrderController = Get.put(CreateOrderController());
  final pickUpController = Get.put(PickUpController());
  final dropOffController = Get.put(DropOffController());
  final changeLanguageController = Get.put(ChangeLanguageController());



@override
  void initState() {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    setState(() {
      if(widget.orderType=="normal"){
        isSelected=true;
        itemId=1;
        createOrderController.typeOfOrder=widget.orderType;
      }else{
        isSelected=true;
        itemId=2;
        createOrderController.typeOfOrder=widget.orderType;
      }
      pickUpController.finalPickupTime.value="";
      dropOffController.finalDropOffTime.value="";
      createOrderController.getAddressList(context);


    });
  });
  print(changeLanguageController.lang);
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
              createOrderController.offerId="";
              createOrderController.lng="";
              createOrderController.lat="";
              createOrderController.streetName.value="";
              createOrderController.payment.value="";
              createOrderController.typeOfOrder="";
              createOrderController.CopunID="";
              createOrderController.addressId=null;
              createOrderController.codeController.clear();
              createOrderController.promocode.value="";
              pickUpController.PickDate="";
              pickUpController.PickDateHours="";
              dropOffController.dropDate="";
              dropOffController.dropDateHours="";
              Navigator.pop(context);
            },
            icon: Transform.rotate(
            angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/back.svg',))
        ),
        title: Center(
          child: Text(
              'new_order'.tr(), style:  TextStyle(fontSize: 14.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w400,
              color: MyColors.MainColor)),
        ),
      ),
      body:Obx(() => !createOrderController.isLoading.value? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 1.5.h,end: 1.5.h),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      orderType(),
                      SizedBox(height: 3.h,),
                      Text('pick_up_location'.tr(), style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.Dark2)),
                      pickUpLocation(),
                      SizedBox(height: 1.h,),
                      Text('pick_up_date2'.tr(), style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.Dark2)),
                      pickUpDate(),
                      SizedBox(height: 1.h,),
                      Text('drop_off_date2'.tr(), style:  TextStyle(fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.Dark2)),
                      dropOfDate(),
                      SizedBox(height: 3.h,),
                      bottomContent()
                    ],
                  ),
                ),
              ):const Center(child: CircularProgressIndicator(),))
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

  Widget orderType(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Expanded(
         child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=1;
                dropOffController.dropDate="";
                dropOffController.dropDateHours="";
                dropOffController.finalDropOffTime.value="";
                createOrderController.typeOfOrder="normal";
              });
            },
            child: Container(
               height: 20.h,
              padding:  EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color:isSelected==true && itemId==1?MyColors.SecondryColor: MyColors.Dark5, width: 2.0,),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: SvgPicture.asset('assets/normal_orders.svg',)),
                   SizedBox(width: 1.h,),
                  Text('normal'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'lexend_medium',
                        fontWeight: FontWeight.w500,
                        color: MyColors.Dark1),
                  ),
                   SizedBox(height: 1.h,),
                  Text("${'receive_your_order_within_hours'.tr()+widget.orderTextNormal} ${'day'.tr()}",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.Dark3),textAlign: TextAlign.center
                  ),
                ],
              ),
            ),
          ),
       ),
        SizedBox(width: 1.h,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected=true;
                itemId=2;
                dropOffController.dropDate="";
                dropOffController.dropDateHours="";
                dropOffController.finalDropOffTime.value="";
                createOrderController.typeOfOrder="urgent";
              });

            },
            child: Container(
               // width: 160,
              height: 20.h,
              padding:  EdgeInsetsDirectional.all(1.h),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color:isSelected==true && itemId==2?MyColors.SecondryColor: MyColors.Dark5, width: 2.0,),
                  color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: SvgPicture.asset('assets/urgent_orders.svg',)),
                   SizedBox(width: 1.h,),
                  Text('urgent'.tr(),
                    style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'lexend_medium',
                        fontWeight: FontWeight.w500,
                        color: MyColors.Dark1),
                  ),
                   SizedBox(height: 1.h,),
                  Text("${'receive_your_order_within_hours2'.tr()+widget.orderTextUrgent} ${'day'.tr()}",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.Dark3),textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pickUpLocation(){
    return GestureDetector(
      onTap: (){
        dropOffController.dropDate="";
        dropOffController.dropDateHours="";
        dropOffController.finalDropOffTime.value="";
        pickUpController.PickDate="";
        pickUpController.PickDateHours="";
        pickUpController.finalPickupTime.value="";

        showModalBottomSheet<void>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            context: context,
            backgroundColor: Colors.white,
            builder: (BuildContext context) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ChooseAddress(from: "newOrder",)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 8.5.h,
        padding:  EdgeInsetsDirectional.all(1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(color: Colors.white, width: 1.0,),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() =>createOrderController.streetName.value!=""
                ? Container(
                    width: 32.h,
                    child: Text(
                      createOrderController.streetName.value.toString(),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.Dark3),
                      maxLines: 2,
                    ),
                  )
                :Text('add_location'.tr(),
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark3),
            )),
            Spacer(),
            Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/arrow_right.svg',)),
          ],
        ),
      ),
    );
  }

  Widget pickUpDate(){
    return GestureDetector(
      onTap: (){
        dropOffController.dropDate="";
        dropOffController.dropDateHours="";
        dropOffController.finalDropOffTime.value="";
        pickUpController.PickDate="";
        pickUpController.PickDateHours="";
        pickUpController.finalPickupTime.value="";
        if(createOrderController.addressId!=null){
          showModalBottomSheet<void>(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PickUpTime(),
                    ],
                  )));
        }else{
          ToastClass.showCustomToast(context, 'please_choose_your_address_first'.tr(), "error");
        }

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 8.h,
        padding:  EdgeInsetsDirectional.all(1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(color: Colors.white, width: 1.0,),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => pickUpController.finalPickupTime.value!=""? Text(
                    pickUpController.finalPickupTime.value,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'lexend_regular',
                        fontWeight: FontWeight.w400,
                        color: MyColors.Dark3),
                  )
                :Text('pick_up_date'.tr(),
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark3),
            )),
            Spacer(),
            Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/arrow_right.svg',)),
          ],
        ),
      ),
    );
  }

  Widget dropOfDate(){
    return GestureDetector(
      onTap: (){
        if(createOrderController.addressId==null){
          ToastClass.showCustomToast(context, 'please_choose_your_address_first'.tr(), "error");
        }
        else if(pickUpController.finalPickupTime.value==""){
          ToastClass.showCustomToast(context, 'please_choose_pickUp_date'.tr(), "error");
        } else{
          showModalBottomSheet<void>(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) =>
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          dropDownTimeButtomSheet(
                              type: createOrderController.typeOfOrder,date: pickUpController.PickDate),
                        ],
                      )));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 8.h,
        padding:  EdgeInsetsDirectional.all(1.h),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            border: Border.all(color: Colors.white, width: 1.0,),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => dropOffController.finalDropOffTime.value!=""?
            Text(dropOffController.finalDropOffTime.value,
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark3),
            )
                :Text('drop_off_date2'.tr(),
              style:  TextStyle(fontSize: 12.sp,
                  fontFamily: 'lexend_regular',
                  fontWeight: FontWeight.w400,
                  color: MyColors.Dark3),
            )),
            Spacer(),
            Transform.rotate(
                angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                child: SvgPicture.asset('assets/arrow_right.svg',)),
          ],
        ),
      ),
    );
  }

  Widget bottomContent(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: (){
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ChoosePyment()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/card.svg',width: 4.h,height: 4.h),
                 SizedBox(width: 1.h,),
                Text('payment_method'.tr(), style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w300,
                    color: MyColors.Dark2)),
                Spacer(),
                Obx(() => createOrderController.payment.value!=""?
                Text(createOrderController.payment.value,
                        style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainColor))
                    : Text("",
                        style: TextStyle(
                            fontSize: 9.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.MainColor))),
                Transform.rotate(
                    angle:changeLanguageController.lang=="ar"? 180 *math.pi /180:0,
                    child: SvgPicture.asset('assets/arrow_right.svg',)),
              ],
            ),
          ),
           SizedBox(height: 1.h,),
          InkWell(
            onTap: ()async{
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddPromotionalCode()));

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/discount_circle.svg',width: 4.h,height: 4.h),
                 SizedBox(width: 1.h,),
                 Text('Add_promotional_code'.tr(), style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w300,
                    color: MyColors.Dark2)),
                Spacer(),
                Obx(()=>Text( createOrderController.promocode.value.toString(), style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w300,
                    color: MyColors.SecondryColor)))
              ],
            ),
          ),
           SizedBox(height: 1.h,),
          InkWell(
            onTap: (){
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddNote()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/note_2.svg',width: 4.h,height: 4.h,),
                 SizedBox(width: 1.h,),
                Text('add_notes'.tr(), style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w300,
                    color: MyColors.Dark2)),
                Spacer(),
                Text( createOrderController.NotesAddressController.text, style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_light',
                    fontWeight: FontWeight.w300,
                    color: MyColors.SecondryColor))
              ],
            ),
          ),
           SizedBox(height: 3.h,),
          Center(
            child: Obx(() =>
                Visibility(
                    visible: createOrderController.isVisable
                        .value,
                    child: const CircularProgressIndicator(color: MyColors.MainColor,)
                )),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsetsDirectional.only(bottom: 1.h),
            height: 8.h,
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                validation();
              },
              child: Text('confirm_order'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

  void validation(){
    if(createOrderController.typeOfOrder==null){
      ToastClass.showCustomToast(context, 'please_choose_order_type'.tr(), "error");
    }else if(createOrderController.addressId==null){
      //createOrderController.addAddress(context);
      ToastClass.showCustomToast(context, 'please_choose_your_address_first'.tr(), "error");
    }else if(createOrderController.payment.value==""){
      ToastClass.showCustomToast(context, 'please_choose_payment_method'.tr(), "error");
    }else if(pickUpController.finalPickupTime.value==""){
      ToastClass.showCustomToast(context, 'please_select_date_and_time_first'.tr(), "error");
    }else if(dropOffController.finalDropOffTime.value==""){
      ToastClass.showCustomToast(context, 'please_select_date_and_time_first'.tr(), "error");
    }else{
      createOrderController.isVisable.value=true;
      createOrderController.createOrder(context, pickUpController.finalPickupTime.value, dropOffController.finalDropOffTime.value);
    }
  }

}