import 'package:flutter/material.dart';

import '../../../global/constants/app_colors.dart';
import '../../../global/constants/theme.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onTab,
  }) : super(key: key);
  final String text;
  final Function() onTab;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.colorBlackButton,
          onSurface: Theme.of(context).primaryColor,
        ),
        onPressed: onTab,
        child: Text(
          text,
          style: MoneyTheme.lightTextTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
