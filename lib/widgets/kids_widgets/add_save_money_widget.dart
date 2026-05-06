import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/kid_provider.dart';
import 'kid_round_button.dart';

class AddSaveMoneyWidget extends StatelessWidget {
  const AddSaveMoneyWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<KidProvider>(builder: (context, data, _) {
      return Container(
        height: size.height * 0.55,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            data.totalBanknotesSum = data.savedMoney.entries.fold(0, (sum, entry) {
              int value = int.tryParse(entry.key) ?? 0;
              return sum + (value * entry.value);
            });
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: size.width * 0.65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(data.savedMoney.length, (i) {
                      String bankNote = data.savedMoney.keys.elementAt(i);
                      int count = data.savedMoney.values.elementAt(i);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Text('$count', style: kBigTextStyle),
                            const SizedBox(width: 8),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    data.updateBanknote(bankNote, count, false);
                                  });
                                },
                                icon: Icon(Icons.remove_circle_outline, color: kBlue.withValues(alpha: 0.5))),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kWhite,
                                border: Border.all(color: kGreen),
                              ),
                              child: Row(
                                spacing: 12,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/banknote.png', width: 24),
                                  Text(bankNote, style: kBigTextStyle),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    data.updateBanknote(bankNote, count, true);
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline, color: kBlue)),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('yourTotalSaving'.tr(), style: kSmallTextStyle),
                    Text('${data.totalBanknotesSum}', style: kBigTextStyle.copyWith(color: kBlue)),
                    const SizedBox(height: 12),
                    KidRoundButton(
                        onTap: () => data.updateMoney(context, id),
                        icon: Icons.check),
                  ],
                )
              ],
            );
          },
        ),
      );
    });
  }
}