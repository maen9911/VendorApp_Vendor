
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/transaction/domain/models/transaction_model.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transactionModel;
  const TransactionWidget({Key? key, required this.transactionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,0, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(
            offset: const Offset(0, 6),
            blurRadius: 5,
            spreadRadius: -3,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
          )]
      ),
      child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingEye),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeExtraSmall), topRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 12,
                spreadRadius: -3,
                color: Colors.black.withValues(alpha: 0.05),
              )]
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text('${getTranslated('transaction_id', context)}# ${transactionModel.id}', style: titilliumBold.copyWith(
                color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7), fontSize: Dimensions.fontSizeDefault,
            )),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingEye, vertical: Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                  border: Border.all(color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
                  color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Theme.of(context).primaryColor.withValues(alpha:.05) :
                  Theme.of(context).primaryColor.withValues(alpha:.05),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
              ),
              child: Text(PriceConverter.convertPrice(context, transactionModel.amount), style: robotoBold.copyWith(
                    color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha:.7),
                    fontSize: Dimensions.fontSizeDefault,
              )),
            ),
          ]),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                DateConverter.isoStringToLocalDateAndTime(transactionModel.createdAt!),
                style: titilliumRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeSmall,
                ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(children: [

              SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(
                  transactionModel.approved == 1 ? Images.approveIcon:transactionModel.approved == 2? Images.declineIcon: Images.pendingIcon,
              )),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(getTranslated(transactionModel.approved == 2 ? 'denied' : transactionModel.approved == 1 ? 'approved' : 'pending', context)!,
                    style: titilliumRegular.copyWith(color: transactionModel.approved == 1 ? Colors.green : transactionModel.approved == 2 ?
                    Colors.red : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault),
                ),
              ),
            ]),
          ]),
        ),

      ]),
    );
  }
}
