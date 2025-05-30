import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/cart_controller.dart';
import 'package:sixvalley_vendor_app/features/pos/domain/services/cart_service_interface.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/main.dart';


class CouponDiscountController extends ChangeNotifier{
  final CartServiceInterface cartServiceInterface;
  CouponDiscountController({required this.cartServiceInterface});


  final TextEditingController _couponController = TextEditingController();
  TextEditingController get couponController => _couponController;

  final TextEditingController _extraDiscountController = TextEditingController();
  TextEditingController get extraDiscountController => _extraDiscountController;

  double? _couponCodeAmount = 0;
  double? get couponCodeAmount =>_couponCodeAmount;

  double _extraDiscountAmount = 0;
  double get extraDiscountAmount =>_extraDiscountAmount;

  String? _selectedDiscountType = 'percent';
  String? get selectedDiscountType =>_selectedDiscountType;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;



  Future<void> getCouponDiscount(BuildContext context,String couponCode, int? userId, double orderAmount) async {
    ApiResponse response = await cartServiceInterface.getCouponDiscount(couponCode, userId, orderAmount);
    if(response.response!.statusCode == 200) {
      _couponController.clear();
      Map map = response.response!.data;
      _couponCodeAmount =  double.tryParse(map['coupon_discount_amount'].toString());

      Provider.of<CartController>(Get.context!, listen: false).setCouponCodeAndAmount(_couponCodeAmount, couponCode);

      showCustomSnackBarWidget('You got ${_couponCodeAmount.toString()} discount',Get.context!, isToaster: true, isError: false);
    }else if(response.response!.statusCode == 202){
      _couponController.clear();
      Map  map = response.response!.data;
      String? message = map['message'];
      showCustomSnackBarWidget(message,Get.context!, isToaster: true);
    }
    else {
      _couponController.clear();
      ApiChecker.checkApi( response);
    }
    notifyListeners();
  }


  void applyCouponCodeAndExtraDiscount(BuildContext context, double payable){
    _extraDiscountAmount = 0;
    String extraDiscount = _extraDiscountController.text.trim();
    _extraDiscountAmount = double.parse(extraDiscount);

    double extraDiscountPercent = double.parse(PriceConverter.discountCalculationWithOutSymbol(context, Provider.of<CartController>(context, listen: false).amount, _extraDiscountAmount, _selectedDiscountType));

    if(_selectedDiscountType == 'percent' ?
    extraDiscountPercent > double.tryParse(PriceConverter.convertPriceWithoutSymbol(Get.context!, payable))! :
    _extraDiscountAmount >  double.tryParse(PriceConverter.convertPriceWithoutSymbol(Get.context!, payable))!
    ) {
      showCustomSnackBarWidget(getTranslated('discount_cant_greater_than_order_amount', Get.context!), Get.context!, sanckBarType: SnackBarType.warning, isToaster: true, );
    } else {
      Provider.of<CartController>(Get.context!, listen: false).setExtraDiscountAmount(_extraDiscountAmount);
      showCustomSnackBarWidget(getTranslated('extra_discount_added_successfully', Get.context!), Get.context!, isToaster: true, isError: false);
    }
    notifyListeners();
  }

  void setSelectedDiscountType(String? type){
    _selectedDiscountType = type;
    _extraDiscountController.text = '';
    notifyListeners();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      notifyListeners();
    }
  }



}