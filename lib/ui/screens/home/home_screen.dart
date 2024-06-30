import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import '../../../business/homeController/HomeController.dart';
import '../../../conustant/my_colors.dart';
import '../../widget/OfferHomeItem.dart';
import '../buttomSheets/addressBottomSheet/choose_address.dart';
import '../buttomSheets/orderTypeBottomSheet/choose_order_type.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';


class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>{
  final homeController = Get.put(HomeController());
  int currentIndex = 0;
  var con=true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: MyColors.MainColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ));

  @override
  void initState() {
    //homeController.getData();
    check();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Execute the code after the widget is built
      homeController.getHomeData();
    });
    super.initState();
  }

  Future<void> check()async{
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    setState(() {
      con = hasInternet;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.BackGroundColor,
        body:  con? RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: MyColors.MainColor,
            strokeWidth: 4.0,
            onRefresh: () async {
              await check();
              con?
              homeController.getHomeData():NoIntrnet();
            },
          child: Obx(() =>!homeController.isLoading.value?
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin:  EdgeInsetsDirectional.only(start: 2.h,end: 2.h,top: 1.h),
                child: Column(
                  children: [
                    appCustomBar(),
                    SizedBox(height: 2.h,),
                    homeController.offersList.isNotEmpty?
                    Column(
                      children: [
                        GestureDetector(
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
                                          child: ChooseOrderType(null)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 10.h,
                                  padding: EdgeInsetsDirectional.all(1.h),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                        color: MyColors.SecondryColor, width: 1.0,),
                                      color:  MyColors.SecondryColor),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${'total_orders'.tr()} ${homeController.homeResponse.value.data?.ordersCount.toString()??""}",
                                          style:  TextStyle(fontSize: 8.sp,
                                              fontFamily: 'lexend_regular',
                                              fontWeight: FontWeight.w400,
                                              color:MyColors.Dark5)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('add_new_order'.tr(), style:   TextStyle(fontSize: 12.sp,
                                              fontFamily: 'lexend_regular',
                                              fontWeight: FontWeight.w400,
                                              color:Colors.white)),
                                          SvgPicture.asset('assets/add_circle.svg',width: 4.h,height: 4.h,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        SizedBox(height: 2.h,),
                        homeController.sliderList.isNotEmpty?
                        dots():Container(),
                        SizedBox(height: 2.h,),
                        Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('offers'.tr(),
                                    style:  TextStyle(fontSize: 16.sp,
                                        fontFamily: 'lexend_medium',
                                        fontWeight: FontWeight.w800,
                                        color: MyColors.Dark1),),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, '/offers_screen');
                                    },
                                    child: Text('show_all'.tr(),
                                      style:  TextStyle(fontSize: 12.sp,
                                          fontFamily: 'lexend_light',
                                          fontWeight: FontWeight.w300,
                                          color: MyColors.Dark2),),
                                  ),
                                ],
                              ),
                        offerList(),
                      ],
                    ):Container(margin: EdgeInsetsDirectional.only(top: 40.h),
                        child: Text('not_covered'.tr(),textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp,
                            fontFamily: 'lexend_medium',
                            fontWeight: FontWeight.w500,
                            color:MyColors.Dark1)))

                  ],
                ),
              ),
            ),
          ) :const Center(child: CircularProgressIndicator(color: MyColors.MainColor,))),
        ):NoIntrnet()
    );
  }



  Widget NoIntrnet(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SvgPicture.asset('assets/no_internet.svg'),
          Image.asset('assets/no_internet.png'),
          SizedBox(height: 10,),
          Text('there_are_no_internet'.tr(),
            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,color: MyColors.Dark1),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            height: 6.h,
            margin:  EdgeInsetsDirectional.only(start: 1.5.h, end: 1.5.h),
            child: TextButton(
              style: flatButtonStyle,
              onPressed: () async{
                await check();
                homeController.getHomeData();
              },
              child: Text('internet'.tr(),
                style:  TextStyle(fontSize: 12.sp,
                    fontFamily: 'lexend_bold',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
            ),
          ),
        ],
      ),

    );
  }


  Widget dots(){
    if (homeController.sliderList.isEmpty) {
      // Display alternative design here
      return Text('No sliders available');
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            itemCount: homeController.sliderList.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MyColors.MainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(image: NetworkImage(homeController.sliderList[itemIndex].image),fit: BoxFit.fill,)
                    )
                ),
            options: CarouselOptions(
                height: 20.h,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) => {
                  setState(() => {currentIndex = index})
                }),
          ),
          DotsIndicator(
            dotsCount: homeController.sliderList.length,
            position: currentIndex.toDouble(),
            decorator: DotsDecorator(
              size:  Size.square(1.h),
              activeSize:  Size(2.h, 1.h),
              activeColor: MyColors.MainColor,
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],

      );
    }
  }

  Widget appCustomBar(){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 6.h,
          height: 6.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.network(
              homeController.profileImg??"",
              loadingBuilder: (context, child,
                  loadingProgress) =>
              (loadingProgress == null)
                  ? child
                  : Center(
                  child: CircularProgressIndicator()),
            ),
          ),
        ),
         SizedBox(width: 2.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(homeController.profileName??"", style:  TextStyle(fontSize: 14.sp,
                fontFamily: 'lexend_medium',
                fontWeight: FontWeight.w500,
                color:MyColors.Dark1)),
            Row(
              children: [
                SvgPicture.asset('assets/location2.svg',width: 2.h,height: 2.h,),
                 SizedBox(width: 2.w,),
                 GestureDetector(
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
                             child: ChooseAddress(from: "home",)));
                  },
                   child: SizedBox(
                     width: 26.h,
                     child: Text(homeController.currentAddress.toString(), style:  TextStyle(fontSize: 10.sp,
                        fontFamily: 'lexend_light',
                        fontWeight: FontWeight.w300,
                        color:MyColors.Dark3)),
                   ),
                 ),
              ],
            ),
          ],
        ),
        Spacer(),
         GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, '/notificatio_screen');
          },
            child:  Image(image: AssetImage('assets/notifi.png'),width: 6.h,height: 6.h,)),
      ],
    );
  }

  Widget offerList() {
    return Container(
      height: 85.w,
        margin: EdgeInsetsDirectional.only(bottom: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: homeController.offersList.length,
          itemBuilder: (context,int index){
            return OfferHomeItem(
               "home",
               homeController.offersList[index],null
            );
          }
      ),
    );
  }

   getCurrentLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the scenario when the user denies permission
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the scenario when the user denies permission forever
      return;
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

     homeController.lat=position.latitude;
     homeController.lng=position.longitude;

    // Convert the position into an address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract the address name from the placemark
    Placemark placemark = placemarks.first;
    String address = placemark.name ?? '';

    // Update the UI with the current address
    setState(() {
      homeController.currentAddress = address;
    });
     homeController.getHomeData();
  }

}
