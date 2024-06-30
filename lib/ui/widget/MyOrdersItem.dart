import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

import '../../business/listOrderController/ListOrderController.dart';
import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/ListOrderModel/ListOrderResponse.dart';
import '../screens/deleteDialog/DeleteScreen.dart';
import '../screens/orders/rateOrder/rate_order_screen.dart';
import 'DropDownDetaildItem.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionClass.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';

class MyOrdersItem extends StatefulWidget{
  OrdersList ordersList;
  MyOrdersItem({required this.ordersList});
  @override
  State<StatefulWidget> createState() {
    return _MyOrdersItem();
  }
}

class _MyOrdersItem extends State<MyOrdersItem>{
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));
  Rx<Color> statusColor=Color(0xffF05323).obs;
  Rx<Color> statusPaidColor=Color(0xffDB1D1D).obs;
  final listOrdersController = Get.put(ListOrdersController());


  void ColorStatus(){
    if(widget.ordersList.status=="pending"){
      statusColor.value=MyColors.SecondryColor;
    }else if(widget.ordersList.status=="accepted"){
      statusColor.value=Colors.green;
    }
    else if(widget.ordersList.status=="receipted"){
      statusColor.value=Colors.blue;
    }
    else if(widget.ordersList.status=="in_progress"){
      statusColor.value=Colors.blueAccent;
    }
    else if(widget.ordersList.status=="in_progress"){
      statusColor.value=Colors.blueAccent;
    }
    else if(widget.ordersList.status=="finished"){
      statusColor.value=Colors.green;
    }
    else if(widget.ordersList.status=="delivery_in_progress"){
      statusColor.value=Colors.green;
    }else if(widget.ordersList.status=="cancelled"){
      statusColor.value=Colors.red;
    }
  }

  void ColorPaidStatus(){
    if(widget.ordersList.is_paid=="unpaid"){
      statusColor.value=MyColors.STATUSEREDColor;
    }else{
      statusColor.value=Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorStatus();
    //ColorPaidStatus();
    return Container(
      margin:  EdgeInsetsDirectional.all(1.h),
      padding:  EdgeInsets.all(1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'order_no'.tr()+" ",
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark1),
              ),
               Text(
                "#${widget.ordersList.id??""}",
                style: TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark1),
              ),
               SizedBox(width: 2.w,),
               Container(
                width: 15.w,
                //height: 3.h,
                padding: EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: MyColors.SecondryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    widget.ordersList.typeLang??"",
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_light',
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 2.w,),
              Obx(() => Container(
                padding: EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: statusColor.value,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    widget.ordersList.statusLang!,
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_light',
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              )),
              /*SizedBox(width: 2.w,),
              Obx(() => Container(
                padding: EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: statusPaidColor.value,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    widget.ordersList.is_paid!,
                    style:  TextStyle(fontSize: 8.sp,
                        fontFamily: 'lexend_light',
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              )),*/
              Spacer(),
              widget.ordersList.status=="pending"?
              GestureDetector(
                onTap: (){
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor:MyColors.BackGroundColor,
                      builder: (BuildContext context)=> Padding(
                          padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: deleteDialog(id: widget.ordersList.id!,)
                      )
                  );

                },
                  child: SvgPicture.asset('assets/delete_order.svg',width: 6.w,height: 6.h))
                  :Container()
            ],
          ),
          Row(
            children: [
              SvgPicture.asset('assets/map.svg',width: 3.w,height: 3.h,),
               SizedBox(width: 2.w,),
               Container(
                 width: 30.h,
                 child: Text(
                   widget.ordersList.addressName??"",
                  style: TextStyle(fontSize: 10.sp,
                      fontFamily: 'lexend_regular',
                      fontWeight: FontWeight.w400,
                      color: MyColors.Dark2),maxLines: 2,
              ),
               ),
            ],
          ),
           SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/dollar_square.svg',width: 3.w,height: 3.h,),
               SizedBox(width: 2.w,),
               Text(
                "${'delivery_cost'.tr()}: ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.deliveryCost.toString()??"",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/dollar_square.svg',width: 3.w,height: 3.h,),
              SizedBox(width: 2.w,),
              Text(
                'discount'.tr()+": ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.discount.toString()??"",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/dollar_square.svg',width: 3.w,height: 3.h,),
              SizedBox(width: 2.w,),
              Text(
                'total_price'.tr()+": ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.totalAmount.toString()??"",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/moneys.svg',width: 3.w,height: 3.h,),
               SizedBox(width: 2.w,),
              Text(
                widget.ordersList.payment??"",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/moneys.svg',width: 3.w,height: 3.h,),
              SizedBox(width: 2.w,),
              Text(
                "${'payment_status'.tr()}: ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.is_paid??"-",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: statusColor.value),
              ),
            ],
          ),
           SizedBox(height: 1.h,),
          Row(
            children: [
              SvgPicture.asset('assets/moneys.svg',width: 3.w,height: 3.h,),
               SizedBox(width: 2.w,),
              Text(
                'Promotional_code'.tr()+": ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.couponCode??"-",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ),
           SizedBox(height: 1.h,),
          widget.ordersList.offerId!=null?Row(
            children: [
              SvgPicture.asset('assets/moneys.svg',width: 3.w,height: 3.h,),
              SizedBox(width: 2.w,),
              Text(
                'offers'.tr()+": ",
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
              Text(
                widget.ordersList.offerId.toString(),
                style:  TextStyle(fontSize: 10.sp,
                    fontFamily: 'lexend_regular',
                    fontWeight: FontWeight.w400,
                    color: MyColors.Dark2),
              ),
            ],
          ):Container(),
          SizedBox(height: 1.h,),
          Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        'order_rating'.tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark3),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/rating.svg'),
                           SizedBox(width: 1.h,),
                          Text(
                            widget.ordersList.orderRating.toString()??"",
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w400,
                                color: MyColors.Dark2),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        'driver_rating'.tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/rating.svg'),
                           SizedBox(width: 1.h,),
                          Text(
                            widget.ordersList.driverRating.toString()??"",
                            style:  TextStyle(fontSize: 10.sp,
                                fontFamily: 'lexend_regular',
                                fontWeight: FontWeight.w400,
                                color: MyColors.Dark2),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ],
          ),
          SizedBox(height: 1.h,),
          Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        'pick_up_date2'.tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark3),
                      ),
                      Text(
                        widget.ordersList.deliveryDate??"",
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w400,
                            color: MyColors.Dark2),
                      ),
                    ],
                  )
              ),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        'drop_off_date2'.tr(),
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_light',
                            fontWeight: FontWeight.w300,
                            color: MyColors.Dark3),
                      ),
                      Text(
                        widget.ordersList.receivedDate??"",
                        style:  TextStyle(fontSize: 10.sp,
                            fontFamily: 'lexend_regular',
                            fontWeight: FontWeight.w400,
                            color: MyColors.Dark2),
                      ),
                    ],
                  )
              ),
            ],
          ),
           SizedBox(height: 1.h,),
          Text(
            'notes'.tr()+": ",
            style:  TextStyle(fontSize: 12.sp,
                fontFamily: 'lexend_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.Dark2),
          ),
          Text(
            widget.ordersList.notes??"",
            style:  TextStyle(fontSize: 10.sp,
                fontFamily: 'lexend_regular',
                fontWeight: FontWeight.w300,
                color: MyColors.Dark3),
          ),
          //const SizedBox(height: 8,),
          Collaps(context),
          //const SizedBox(height: 8,),
          widget.ordersList.status=="accepted"
              &&widget.ordersList.is_paid=="unpaid"
              &&widget.ordersList.payment=="visa"&&widget.ordersList.totalAmount>0?Container(
            width: double.infinity,
            height: 6.h,
            margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                payPressed();
              },
              child: Text('pay_now'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ):Container(),
          widget.ordersList.status=="finished"
              &&widget.ordersList.driverRating==0&&widget.ordersList.orderRating==0?Container(
            width: double.infinity,
            height: 6.h,
            margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RateOrderScreen(id: widget.ordersList.id!,)),
                );
               // Navigator.pushNamed(context, '/rate_order_screen');
              },
              child: Text('rating'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ):Container(),
        ],
      ),
    );
  }



  Widget Collaps(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding:  EdgeInsets.only(top: 1.h,bottom: 1.h),
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  hasIcon: false,
                  iconPlacement: ExpandablePanelIconPlacement.right,
                  iconColor: Colors.black,
                  // collapseIcon: Icons.keyboard_arrow_up_outlined,
                  // expandIcon: Icons.keyboard_arrow_down_outlined,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.only(right: 1.h), // Adjust the padding as needed
                  child: Row(
                    children: [
                      Text(
                        'show_details'.tr(),
                        style:  TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'lexend_regular',
                          fontWeight: FontWeight.w400,
                          color: MyColors.MainColor,
                        ),
                      ),
                      SizedBox(width: 2.w,),
                      SvgPicture.asset('assets/arrow_circle_down2.svg'),
                     // const Icon(Icons.arrow_drop_down_sharp),
                    ],
                  ),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var _ in Iterable.generate(1))
                      Padding(
                        padding:  EdgeInsets.only(bottom: 1.h),
                        child: Column(
                          children: [
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 2,
                            //   color: MyColors.BackGroundColor,
                            // ),
                            DetailedList(),
                          ],
                        ),
                        //Text(answer!,),
                      ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DetailedList(){
    return Container(
      margin: EdgeInsetsDirectional.all( 2.h),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.ordersList.orderItems!.length,
          itemBuilder: (context,int index){
            return DropDownDetaildItem(
                orderItems: widget.ordersList.orderItems![index]
            );
          }
      ),
    );
  }

  /////////payTaps//////
  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails(
        (listOrdersController.name==null||listOrdersController.name=="null"||listOrdersController.name=="")?"trio":listOrdersController.name,
        (listOrdersController.email==null||listOrdersController.email=="null"||listOrdersController.email=="")?"trio@gmail.com":listOrdersController.email,
        listOrdersController.phone??"+97311111111",
        "st. 12", "eg", "egypt", "egypt", "1");
    var shippingDetails = ShippingDetails(
        listOrdersController.name??"trio",
        listOrdersController.email??"trio@gmail",
        listOrdersController.phone??"+97311111111",
        "st. 12", "eg", "egypt", "egypt", "1");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    final configuration = PaymentSdkConfigurationDetails(
        profileId: "135033",
        serverKey: "SLJ99LWTHJ-JHNJDZGL2N-L2WLT26KWR",
        clientKey: "C2K22M-HVTQ6H-Q6D9TB-72M2NR",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: double.parse(widget.ordersList.totalAmount.toString()),
        showBillingInfo: false,
        forceShippingInfo: false,
        currencyCode: "EGP",
        merchantCountryCode: "EG",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          var transactionDetails = event["data"];
          print(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            listOrdersController.updatePaymentStatus(widget.ordersList.id!,"paid",context,transactionDetails["transactionReference"]).then((_){
              if(listOrdersController.updatePaymentResponse.value.success==true){
                listOrdersController.onAlertButtonsPressed(context,"congratulations".tr(),
                    'successful_transaction'.tr(),'assets/checked.svg');
              }
            });
            if (transactionDetails["isPending"]) {
              print("transaction pending");
            }
          } else {
            listOrdersController.updatePaymentStatus(widget.ordersList.id!,"unpaid",context,transactionDetails["transactionReference"]).then((_){
              if(listOrdersController.updatePaymentResponse.value.success==true){
                listOrdersController.onAlertButtonsPressed(context,"failed".tr(),
                    'failed_transaction'.tr(),'assets/error_solid.svg');
              }
            });
          }
        } else if (event["status"] == "error") {
          Fluttertoast.showToast(
              msg: "Error in Transaction",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColors.STATUSEREDColor);
          // Handle error here.
        } else if (event["status"] == "event") {
          print("eventttttttt");
          // Handle events here.
        }
      });
    });
  }

}

class deleteDialog extends StatefulWidget{
  int id;

  deleteDialog({required this.id});
  @override
  State<StatefulWidget> createState() {
    return _deleteDialog();
  }
}

class _deleteDialog extends State<deleteDialog>{
  final listOrdersController = Get.put(ListOrdersController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SvgPicture.asset('assets/delete2.svg',width: 100,height: 100,),
          ),
          const SizedBox(height: 10,),
          Text('Cancel_order'.tr(),
              style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'lexend_bold',
                  fontWeight: FontWeight.w800,
                  color: MyColors.Dark1)),
          const SizedBox(height: 10,),
          Text('Are_you_sure_to_cancel_the_order'.tr(),
            style: TextStyle(fontSize: 10.sp,
                fontFamily: 'lexend_regular',
                fontWeight: FontWeight.w400,
                color: MyColors.Dark2),
            textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DialogButton(
                  radius: BorderRadius.circular(50),
                  height: 7.h,
                  child: Text('yes_cancel'.tr(), style:  TextStyle(fontSize: 12.sp,
                      fontFamily: 'lexend_bold',
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
                  onPressed: () => {
                    listOrdersController.cancelOrder(widget.id!, context)
                  },
                  color: MyColors.SecondryColor,
                ),
              ),
              Expanded(
                  child: DialogButton(
                    height: 7.h,
                    radius: BorderRadius.circular(50),
                    child: Text('no'.tr(), style:  TextStyle(fontSize: 12.sp,
                        fontFamily: 'lexend_bold',
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: MyColors.MainColor,

                  )
              )
            ],
          )
        ],
      ),
    );
  }

}