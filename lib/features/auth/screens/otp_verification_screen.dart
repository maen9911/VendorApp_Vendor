import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/main.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/auth/widgets/reset_password_widget.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class VerificationScreen extends StatelessWidget {
  final String mobileNumber;

  const VerificationScreen(this.mobileNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        _onWillPop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox( width: 1170,
                  child: Consumer<AuthController>(
                    builder: (context, authProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 55),
                        Image.asset(Images.logo, width: 100, height: 100,),
                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Center(child: Text('${getTranslated('please_enter_4_digit_code', context)}\n$mobileNumber',
                            textAlign: TextAlign.center, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))),),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                          child: PinCodeTextField(
                            length: 4,
                            appContext: context,
                            obscureText: false,
                            showCursor: true,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            textStyle: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeExtraLarge),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 63,
                              fieldWidth: 55,
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: ColorHelper.darken(Theme.of(context).colorScheme.secondary, 0.2),
                              selectedFillColor: Colors.white,
                              inactiveFillColor: Theme.of(context).cardColor,
                              inactiveColor: ColorHelper.darken(Theme.of(context).colorScheme.secondary, 0.2),
                              activeColor: ColorHelper.darken(Theme.of(context).colorScheme.secondary, 0.1),
                              activeFillColor: Theme.of(context).cardColor,
                            ),
                            animationDuration: const Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            onChanged: authProvider.updateVerificationCode,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),

                        Center(child: Text(getTranslated('i_didnt_receive_the_code', context)!, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color))),

                        Center(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              Provider.of<AuthController>(context, listen: false).forgotPassword(mobileNumber).then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBarWidget('Resent code successful', Get.context!, isError: false,  sanckBarType: SnackBarType.success);
                                } else {
                                  showCustomSnackBarWidget(value.message, Get.context!);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Text(getTranslated('resend_code', context)!, style: TextStyle(color: Theme.of(context).primaryColor))),
                          ),
                        ),
                        const SizedBox(height: 48),

                        authProvider.isEnableVerificationCode ? !authProvider.isPhoneNumberVerificationButtonLoading ?
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: CustomButtonWidget(
                            btnTxt: getTranslated('verify', context),

                            onTap: () {
                              bool phoneVerification = Provider.of<SplashController>(context,listen: false).
                              configModel!.forgotPasswordVerification =='phone';
                              if(phoneVerification){
                                Provider.of<AuthController>(context, listen: false).verifyOtp(mobileNumber).then((value) {
                                  if(value.isSuccess) {
                                    Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(
                                        builder: (_) => ResetPasswordWidget(mobileNumber: mobileNumber,
                                            otp: authProvider.verificationCode)), (route) => false);
                                    }else {
                                    showCustomSnackBarWidget(getTranslated('input_valid_otp', Get.context!), Get.context!,  sanckBarType: SnackBarType.error);
                                  }
                                });
                              }
                            },
                          ),
                        ):  Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<bool> _onWillPop(BuildContext context) async {
    showAnimatedDialogWidget(context,  ConfirmationDialogWidget(icon: Images.logOut,
      title: getTranslated('exit_app', context),
      description: getTranslated('do_you_want_to_exit_the_app', context), onYesPressed: (){
        SystemNavigator.pop();
      }), isFlip: true);
    return true;
  }
}
