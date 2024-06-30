import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trio_app/ui/screens/auth/changeLanguage/change_language_screen.dart';
import 'package:trio_app/ui/screens/auth/createAccount/create_account_screen.dart';
import 'package:trio_app/ui/screens/auth/intro/into_slider_screen.dart';
import 'package:trio_app/ui/screens/auth/location/location_screen.dart';
import 'package:trio_app/ui/screens/auth/login/Login_screen.dart';
import 'package:trio_app/ui/screens/auth/splash/splash_screen.dart';
import 'package:trio_app/ui/screens/auth/verifyCode/Verfiy_code_screen.dart';
import 'package:trio_app/ui/screens/drowerMenu/drower.dart';
import 'package:trio_app/ui/screens/drowerMenu/myOrders/my_orders_screen.dart';
import 'package:trio_app/ui/screens/drowerMenu/price/price_screen.dart';
import 'package:trio_app/ui/screens/home/home_screen.dart';
import 'package:trio_app/ui/screens/more/aboutApp/about_app_screen.dart';
import 'package:trio_app/ui/screens/more/changePhoneNumber/change_phone_number_screen.dart';
import 'package:trio_app/ui/screens/more/deliveryPolicy/delivery_policy_screen.dart';
import 'package:trio_app/ui/screens/more/faqs/faqs.dart';
import 'package:trio_app/ui/screens/more/more_screen.dart';
import 'package:trio_app/ui/screens/more/myLocation/editeLocation/edit_location_screen.dart';
import 'package:trio_app/ui/screens/more/myLocation/my_address_screen.dart';
import 'package:trio_app/ui/screens/more/privacyPolicy/privacy_policy_screen.dart';
import 'package:trio_app/ui/screens/more/profile/profile_screen.dart';
import 'package:trio_app/ui/screens/more/returnAndRefundPolicy/return_and_refund_policy.dart';
import 'package:trio_app/ui/screens/more/shareCode/share_code_screen.dart';
import 'package:trio_app/ui/screens/more/successDialog/success_dialog_screen.dart';
import 'package:trio_app/ui/screens/more/termsAndConditions/terms_and_condition.dart';
import 'package:trio_app/ui/screens/more/wallet/wallet_screen.dart';
import 'package:trio_app/ui/screens/notification/notification_screen.dart';
import 'package:trio_app/ui/screens/offers/offers_screen.dart';
import 'package:trio_app/ui/screens/orders/newOrder/new_order_screen.dart';
import 'package:trio_app/ui/screens/orders/rateOrder/rate_order_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case'/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case'/change_language_screen':
        return MaterialPageRoute(builder: (_) => ChangeLanguageScreen());
      case'/into_slider_screen':
      return MaterialPageRoute(builder: (_) => IntoSliderScreen());
      case'/Login_screen':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case'/Verfiy_code_screen':
        final code=settings.arguments as int;
        return MaterialPageRoute(builder: (_) => VerfiyCodeScreen(code: code,));
      case'/create_account_screen':
        return MaterialPageRoute(builder: (_) => CreateAccountScreen());
      case'/location_screen':
        final from=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => LocationScreen(from));
      case'/home_screen':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case'/notificatio_screen':
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case'/drower':
        return MaterialPageRoute(builder: (_) => DrowerPage());
      case'/new_order_screen':
        final code=settings.arguments as String;
        final code2=settings.arguments as String;
        final code3=settings.arguments as String;
        return MaterialPageRoute(builder: (_) => NewOrderScreen(code,code2,code3));
      case'/offers_screen':
        return MaterialPageRoute(builder: (_) => OffersScreen());
      case'/price_screen':
        return MaterialPageRoute(builder: (_) => PriceScreen());
      case'/more_screen':
        return MaterialPageRoute(builder: (_) => MoreScreen());
      case'/profile_screen':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case'/wallet_screen':
        return MaterialPageRoute(builder: (_) => WalletScreen());
      case'/my_address_screen':
        return MaterialPageRoute(builder: (_) => MyAddressScreen());
      case'/share_code_screen':
        return MaterialPageRoute(builder: (_) => ShareCodeScreen());
      case'/about_app_screen':
        return MaterialPageRoute(builder: (_) => AboutAppScreen());
      case'/terms_and_condition_screen':
        return MaterialPageRoute(builder: (_) => TermsAndConditionScreen());
      case'/return_and_refund_policy':
        return MaterialPageRoute(builder: (_) => ReturnAndRefundPolicyScreen());
      case'/privacy_policy_policy':
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case'/delivery_policy_policy':
        return MaterialPageRoute(builder: (_) => DeliveryPolicyScreen());
      case'/faqs':
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case'/change_phone_number_screen':
        return MaterialPageRoute(builder: (_) => ChangePhoneNumberScreen());
      case'/success_dialog_screen':
        return MaterialPageRoute(builder: (_) => SuccessDialogScreen());
      case'/my_orders_screen':
        return MaterialPageRoute(builder: (_) => MyOrdersScreen());
      case'/edit_location_screen':
        final lant=settings.arguments as String;
        final lngt=settings.arguments as String;
        final street=settings.arguments as String;
        final id=settings.arguments as int;
        final type=settings.arguments as String;

        return MaterialPageRoute(builder: (_) => EditLocationScreen(lngedit: lant,latedit: lngt,addressEdit: street,id: id,typeEd: type,));
      case'/rate_order_screen':
        final orderId=settings.arguments as int;
        return MaterialPageRoute(builder: (_) => RateOrderScreen(id: orderId,));
    }
  }
}

