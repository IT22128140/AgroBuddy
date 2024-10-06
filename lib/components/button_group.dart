// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonGroup extends StatefulWidget {
  final bool isIncomeSelected;

  const ButtonGroup({
    super.key,
    required this.isIncomeSelected,
  });

  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'record_add_income');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isIncomeSelected
                        ? const Color(0xFFFAE623)
                        : const Color(0xFF28631F),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    side: BorderSide(color: const Color(0xFFFAE623), width: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.income,
                    style: TextStyle(
                        color: widget.isIncomeSelected
                            ? const Color(0xFF000000)
                            : const Color(0xFFFAE623),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'record_add_expense');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isIncomeSelected
                        ? const Color(0xFF28631F)
                        : const Color(0xFFFAE623),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    side: BorderSide(color: const Color(0xFFFAE623), width: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.expense,
                    style: TextStyle(
                        color: widget.isIncomeSelected
                            ? const Color(0xFFFAE623)
                            : const Color(0xFF000000),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
