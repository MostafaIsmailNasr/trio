import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:trio_app/conustant/toast_class.dart';

import '../../conustant/di.dart';
import '../../conustant/my_colors.dart';
import '../../conustant/shared_preference_serv.dart';
import '../../data/model/addressModel/addAddressModel/AddAddressResponse.dart';
import '../../data/model/addressModel/addressListModel/AddressListResponse.dart';
import '../../data/model/copunModel/CopunResponse.dart';
import '../../data/model/createOrderModel/CreateOrderResponse.dart';
import '../../data/model/daySettingModel/DaySettingResponse.dart';
import '../../data/reposatory/repo.dart';
import '../../data/web_service/WebServices.dart';
import '../../ui/screens/drowerMenu/drower.dart';
import '../dropOffController/DropOffController.dart';
import '../homeController/HomeController.dart';
import '../pickUpController/PickUpController.dart';

class CreateOrderController extends GetxController {
  Repo repo = Repo(WebService());
  var createOrderResponse = CreateOrderResponse().obs;
  var copunResponse2 = copunResponse().obs;
  var daySettingResponse = DaySettingResponse().obs;
  var addAddressResponse = AddAddressResponse().obs;
  var addressListResponse = AddressListResponse().obs;
  var isLoading = false.obs;
  var isLoading2 = false.obs;
  var isLoading3 = false.obs;
  Rx<bool> isVisable = false.obs;
  Rx<bool> btnVisable = false.obs;
  RxList<dynamic> addressList=[].obs;

  final SharedPreferencesService sharedPreferencesService =
  instance<SharedPreferencesService>();
  var typeOfOrder;
  var addressId;
  var lat;
  var lng;
  var streetName="".obs;
  var payment="".obs;
  var offerId;
  var CopunID;
  var promocode="".obs;

  TextEditingController codeController = TextEditingController();
  TextEditingController NotesAddressController=TextEditingController();
  final homeController = Get.put(HomeController());



  createOrder(
      BuildContext context,
      String deliveryDate,
      String receivedDate,
      ) async {
    createOrderResponse.value = await repo.createOrder(
         addressId,
        CopunID??0,
         offerId??0,
        typeOfOrder,
         deliveryDate,
         receivedDate,
         payment.value,
        NotesAddressController.text);
    if (createOrderResponse.value.success == true) {
      isVisable.value=false;
      _onAlertButtonsPressed(context);
      offerId="";
      lng="";
      lat="";
      streetName.value="";
      payment.value="";
      typeOfOrder="";
      CopunID=0;
      codeController.clear();
      promocode.value="";
    } else {
      isVisable.value=false;
      print(createOrderResponse.value.message);
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(createOrderResponse.value.message.toString()),
        ),
      );
    }
  }

  validateCopune(BuildContext context)async{
    isLoading2.value=true;
    copunResponse2.value = await repo.validateCoupon(codeController.text);
    if(copunResponse2.value.success==true){
      isVisable.value=false;
      btnVisable.value=true;
      isLoading2.value=false;
      promocode.value=codeController.text;
      CopunID=copunResponse2.value.data!.id;
      Navigator.pop(context);
      ToastClass.showCustomToast(context, "Success", "sucess");
      codeController.clear();
    }else{
      isVisable.value=false;
      btnVisable.value=true;
      codeController.clear();
      // promocode.value="";
      ToastClass.showCustomToast(context, copunResponse2.value.message, "error");
    }
    return copunResponse2.value;
  }

  getOrderDays(BuildContext context)async{
    isLoading3.value=true;
    daySettingResponse.value = await repo.getOrderDays();
    if(daySettingResponse.value.success==true){
      isLoading3.value=false;
    }else{
      isLoading3.value=false;
      ToastClass.showCustomToast(context, daySettingResponse.value.message, "error");
    }
    return daySettingResponse.value;
  }

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      image: SvgPicture.asset('assets/checked.svg',width: 7.h,height: 7.h,),
      title: 'congratulations'.tr(),
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
      desc: 'the_order_was_made_successfully'.tr(),
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(50),
          height: 7.h,
          onPressed: ()  {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return DrowerPage(index: 0,);
                }));
            //Navigator.pushNamed(context, '/drower')
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
          child: Text('my_orders'.tr(), style:  TextStyle(fontSize: 12.sp,
              fontFamily: 'lexend_bold',
              fontWeight: FontWeight.w700,
              color: Colors.white)),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return DrowerPage(index: 2,);
                }));
            // Navigator.pushNamed(context, '/my_orders_screen');
          },
          color: MyColors.SecondryColor,

        )
      ],
    ).show();
  }

  getAddressList(BuildContext context)async{
    isLoading.value=true;
    //userName=sharedPreferencesService.getString("fullName");
    addressListResponse.value = await repo.getAddress();
    if(addressListResponse.value.success==true){
      isLoading.value=false;
      addressList.value=addressListResponse.value.data as List;
      if(addressListResponse.value.data!.isEmpty){
        print("innn");
        lat=homeController.lat;
        lng=homeController.lng;
        streetName.value=homeController.currentAddress;
        addAddress(context);
      }else{
        lat=addressListResponse.value.data?[0].lat;
        lng=addressListResponse.value.data?[0].lng;
        streetName.value=addressListResponse.value.data?[0].streetName??"";
        addressId=addressListResponse.value.data?[0].id;
      }
      print("outtt");

    }
    return addressListResponse.value;
  }

  addAddress(BuildContext context) async {
    addAddressResponse.value = await repo.addAddress(streetName.value,lat.toString(),lng.toString(),"home");
    if (addAddressResponse.value.success == true) {
      // isVisable.value = false;
      lat=addAddressResponse.value.data?.lat;
      lng=addAddressResponse.value.data?.lng;
      streetName.value=addAddressResponse.value.data?.streetName??"";
      addressId=addAddressResponse.value.data?.id;
     //addressId=addAddressResponse.value.data?.id;
    } else {
      isVisable.value = false;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(addAddressResponse.value.message!),
        ),
      );
    }
  }
}