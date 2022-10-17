import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../global/constants/app_colors.dart';
import '../../../global/constants/paths.dart';
import '../../../global/constants/strings.dart';
import '../../../global/constants/theme.dart';
import '../../../global/helper_methods/methods.dart';
import 'button_widget.dart';

class DailyLimitWidget extends StatelessWidget {
  DailyLimitWidget({Key? key}) : super(key: key);
  final dateController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Image(
                image: AssetImage(Paths.appWalletImage),
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Center(
              child: Text(Strings.spendText,
                  style: MoneyTheme.lightTextTheme.headline2),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
            decoration: const BoxDecoration(
              color: AppColors.spendDailyColor,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: TextFormField(
              controller: amountController,
              cursorColor: AppColors.greyColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Strings.dailyLimitText,
                labelStyle: MoneyTheme.lightTextTheme.subtitle1,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 37,
              right: 37,
            ),
            child: ButtonWidget(
                text: Strings.startButtonText,
                onTab: () {
                  if (amountController.text.isNotEmpty) {
                    if (isNumeric(amountController.text)) {
                      saveSP("dailyLimit", num.parse(amountController.text));

                      finishSplash(context);
                    } else {
                      showSnackBar(context, Strings.checkInput);
                    }
                  } else {
                    showSnackBar(context, Strings.fillInput);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
