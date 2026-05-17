import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_children/widgets/task_square_widget.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/parent_provider.dart';

class HistoryTilesListWidget extends StatefulWidget {
  const HistoryTilesListWidget({super.key, required this.snapshot});

  final List<Map<String, dynamic>> snapshot;

  @override
  State<HistoryTilesListWidget> createState() => _HistoryTilesListWidgetState();
}

class _HistoryTilesListWidgetState extends State<HistoryTilesListWidget> {
  final Set<String> _selectedKidNames = {};
  final Set<String> _selectedTaskTypes = {'long', 'normal'};
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ParentProvider>(
      builder: (context, data, _) {
        final parentHistory = widget.snapshot.where((history) {
          return history['parentEmail'].toLowerCase() == data.email;
        }).toList();
        final uniqueKidNames = parentHistory
            .map((h) => h['kidName'] as String).toSet().toList();
        if (!_isInitialized && uniqueKidNames.isNotEmpty) {
          _selectedKidNames.addAll(uniqueKidNames);
          _isInitialized = true;
        }
        final filteredHistory = parentHistory.where((history) {
          if (!_selectedKidNames.contains(history['kidName'])) {
            return false;
          }
          final hasDays = history['daysNumber'] != null;
          if (hasDays && !_selectedTaskTypes.contains('long')) return false;
          if (!hasDays && !_selectedTaskTypes.contains('normal')) return false;

          return true;
        }).toList();

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: kWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  if (uniqueKidNames.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8,
                        children: uniqueKidNames.map((kidName) {
                          final isSelected = _selectedKidNames.contains(kidName);
                          return FilterChip(
                            label: Text(kidName),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedKidNames.add(kidName);
                                } else {
                                  if (_selectedKidNames.length > 1) {
                                    _selectedKidNames.remove(kidName);
                                  }
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  Row(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: Text('multi'.tr()),
                        selected: _selectedTaskTypes.contains('long'),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTaskTypes.add('long');
                            } else {
                              if (_selectedTaskTypes.length > 1) {
                                _selectedTaskTypes.remove('long');
                              }
                            }
                          });
                        },
                      ),
                      FilterChip(
                        label: Text('single'.tr()),
                        selected: _selectedTaskTypes.contains('normal'),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTaskTypes.add('normal');
                            } else {
                              if (_selectedTaskTypes.length > 1) {
                                _selectedTaskTypes.remove('normal');
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        spacing: 18,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            parentHistory.isEmpty
                              ? 'assets/images/emptyList.png'
                              : 'assets/images/noShopping.png',
                            width: 180,),
                          Text(
                            parentHistory.isEmpty
                                ? 'emptyList'.tr()
                                : 'noResults'.tr(),
                            style: kTextStyle,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                itemCount: filteredHistory.length,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) {
                  final history = filteredHistory[index];
                  Size size = MediaQuery.sizeOf(context);
                  List<int> counts = [0, 0, 0, 0];

                  if (history['daysNumber'] != null) {
                    for (var n in history['daysNumber']) {
                      counts[n] += 1;
                    }
                  }

                  final originalIndex = widget.snapshot.indexOf(history);

                  return GestureDetector(
                    onTap: () => data.historyDescription(
                      context,
                      history['price'],
                      history['description'],
                      history,
                      originalIndex,
                    ),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      width: size.width,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(width: 1, color: kBlue.withValues(alpha: 0.2)),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: kGrey.withValues(alpha: 0.2),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Image.asset('assets/images/person.png', width: 14),
                                      Text(history['kidName'], style: kBigTextStyle),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 100,
                                    child: Divider(color: kBlue, thickness: 1),
                                  ),
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Image.asset('assets/images/todo.png', width: 16),
                                      Text(history['taskName'], style: kBigTextStyle),
                                    ],
                                  ),
                                  Row(
                                    spacing: 4,
                                    children: [
                                      const SizedBox(width: 16),
                                      Text(history['description'], style: kTextStyle),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      history['daysNumber'] != null ? 5 : 3,
                                          (i) => ((history['daysNumber'] != null ? 4 : 2) - i) < int.parse(history['expQty'])
                                          ? SvgPicture.asset(
                                        'assets/icons/pepper.svg',
                                        width: 12,
                                        colorFilter: const ColorFilter.mode(kRed, BlendMode.srcIn),
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 85,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 10,
                                          left: 0,
                                          child: Icon(
                                            double.parse(history['stars']).toInt() >= 1 ? Icons.star : Icons.star_border,
                                            color: kWhite,
                                            size: 40,
                                            shadows: const [
                                              BoxShadow(
                                                color: kBlue,
                                                blurRadius: 9,
                                                spreadRadius: 6,
                                                offset: Offset(0.5, 0.5),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Icon(
                                            double.parse(history['stars']).toInt() >= 2 ? Icons.star : Icons.star_border,
                                            color: kWhite,
                                            size: 45,
                                            shadows: const [
                                              BoxShadow(
                                                color: kBlue,
                                                blurRadius: 9,
                                                spreadRadius: 6,
                                                offset: Offset(0.5, 0.5),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 0,
                                          child: Icon(
                                            double.parse(history['stars']).toInt() >= 3 ? Icons.star : Icons.star_border,
                                            color: kWhite,
                                            size: 40,
                                            shadows: const [
                                              BoxShadow(
                                                color: kBlue,
                                                blurRadius: 9,
                                                spreadRadius: 6,
                                                offset: Offset(0.5, 0.5),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Image.asset('assets/images/medal.png', width: 14),
                                      Text(history['price'], style: kBigTextStyle),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          if (history['daysNumber'] != null)
                            Container(
                              height: 65,
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              decoration: BoxDecoration(
                                color: kBlue.withValues(alpha: 0.1),
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.46,
                                    child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: List.generate(
                                        history['daysNumber'].length,
                                            (i) {
                                          int number = history['daysNumber'][i];
                                          return TaskSquareWidget(number: number);
                                        },
                                      ),
                                    ),
                                  ),
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              TaskSquareWidget(number: 0),
                                              Text('-', style: kTextStyle),
                                              Text(counts[0].toString(), style: kTextStyle),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TaskSquareWidget(number: 1),
                                              Text('-', style: kTextStyle),
                                              Text(counts[1].toString(), style: kTextStyle),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            spacing: 4,
                            children: [
                              Image.asset('assets/images/deadline.png', width: 12),
                              Text(
                                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(history['time'])),
                                style: kTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}