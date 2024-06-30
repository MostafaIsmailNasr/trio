import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../conustant/toast_class.dart';
import '../../data/model/ListOrderModel/ListOrderResponse.dart';
import '../../data/model/addressModel/deleteModel/DeleteResponse.dart';
import '../../data/model/rateOrderModel/RateOrderResponse.dart';
import '../../data/model/updatePaymentModel/UpdatePaymentResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../../ui/screens/drowerMenu/drower.dart';

class ListOrdersController extends GetxController {
  Repo repo = Repo(WebService());
  var listOrderResponse = ListOrderResponse().obs;
  var deleteResponse = DeleteResponse().obs;
  var rateOrderResponse = RateOrderResponse().obs;
  var updatePaymentResponse = UpdatePaymentResponse().obs;
  Rx<bool> isVisable = false.obs;
  RxList<dynamic> orderList=[].obs;
  var isLoading = false.obs;
  TextEditingController NotesController=TextEditingController();
  double? orderRate = 0.0;
  double? driverRate = 0.0;
  var phone,name,email;
  final SharedPreferencesService sharedPreferencesService = instance<SharedPreferencesService>();

  getListOrders()async{
    isLoading.value=true;
    phone=sharedPreferencesService.getString("phone_number");
    name=sharedPreferencesService.getString("fullName");
    email=sharedPreferencesService.getString("email");
    listOrderResponse.value = await repo.listOrders();
    if(listOrderResponse.value.success==true){
      isLoading.value=false;
      orderList.value=listOrderResponse.value.data as List;
    }
    return listOrderResponse.value;
  }

  cancelOrder(int orderId,BuildContext context)async{
    isLoading.value=true;
    deleteResponse.value = await repo.deleteOrder(orderId);
    if(deleteResponse.value.success==true){
      isLoading.value=false;
      Get.back();
      getListOrders();
      return deleteResponse.value;
    } else {
      isLoading.value=false;
      Get.back();
      ToastClass.showCustomToast(context, deleteResponse.value.message, 'error');
    }
    return listOrderResponse.value;
  }

  RateOrder(int orderId,BuildContext context)async{
    rateOrderResponse.value = await repo.rateOrder(orderId,orderRate.toString(),driverRate.toString(),NotesController.text);
    if(rateOrderResponse.value.success==true){
      isVisable.value=false;
      Get.back();
      getListOrders();
      NotesController.clear();
      orderRate=0.0;
      driverRate=0.0;
      return rateOrderResponse.value;
    } else {
      isVisable.value=false;
      //Get.back();
      ToastClass.showCustomToast(context, rateOrderResponse.value.message??"", 'error');
    }
    return listOrderResponse.value;
  }

  updatePaymentStatus(int orderId,String status,BuildContext context,String transactionReference)async{
    updatePaymentResponse.value = await repo.updatePaymentStatus(orderId,status,transactionReference);
    if(updatePaymentResponse.value.success==true){

    } else {
      isVisable.value=false;
      ToastClass.showCustomToast(context, updatePaymentResponse.value.message??"", 'error');
    }
    return updatePaymentResponse.value;
  }

  onAlertButtonsPressed(context,tittle,des,image) {
    Alert(
      context: context,
      image: SvgPicture.asset(image,width: 7.h,height: 7.h,),
      title: tittle,
      style:  AlertStyle(
          titleStyle:TextStyle(fontSize: 16.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w800,
              color: MyColors.Dark1),
          descStyle: TextStyle(fontSize: 16.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w800,
              color: MyColors.Dark1)
      ),
      desc: des,
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(50),
          height: 7.h,
          onPressed: ()  {

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return DrowerPage(index: 0,);
                }));
          },
          color: MyColors.MainColor,
          child: Text('home'.tr(), style:  TextStyle(fontSize: 12.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.white)),
        ),
        DialogButton(
          height: 7.h,
          radius: BorderRadius.circular(50),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return DrowerPage(index: 2,);
                }));
            // Navigator.pushNamed(context, '/my_orders_screen');
          },
          color: MyColors.SecondryColor,
          child: Text('my_orders'.tr(), style:  TextStyle(fontSize: 12.sp,
              fontFamily: 'legend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.white)),

        )
      ],
    ).show();
  }
}