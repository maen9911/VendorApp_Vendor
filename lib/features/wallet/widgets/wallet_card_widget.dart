import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WalletCardWidget extends StatelessWidget {
  final String? amount;
  final String? title;
  final Color? color;
  const WalletCardWidget({Key? key, this.amount, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),),
      color: color,
      child: Stack(children: [

        Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount.toString(), style: robotoBold.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontSize: Dimensions.fontSizeExtraLargeTwenty,
                )),

                Text(title!,textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontSize: Dimensions.fontSizeLarge,
                )),
              ],
            ),
          ),
        ),

        Positioned(
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha:.15),
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100))
            ),
          ),
        ),
      ]),
    );
  }
}