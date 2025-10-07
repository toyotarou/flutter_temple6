import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../parts/error_dialog.dart';
import '../parts/temple_dialog.dart';
import 'route_display_alert.dart';

class RequiredTimeCalculateSettingAlert extends ConsumerStatefulWidget {
  const RequiredTimeCalculateSettingAlert({super.key});

  @override
  ConsumerState<RequiredTimeCalculateSettingAlert> createState() => _RequiredTimeCalculateSettingAlertState();
}

class _RequiredTimeCalculateSettingAlertState extends ConsumerState<RequiredTimeCalculateSettingAlert>
    with ControllersMixin<RequiredTimeCalculateSettingAlert> {
  String selectedTime = '';

  final TextEditingController speedTextController = TextEditingController();
  final TextEditingController spotStayTimeTextController = TextEditingController();
  final TextEditingController adjustPercentTextController = TextEditingController();

  ///
  @override
  void initState() {
    super.initState();

    final DateFormat timeFormat = DateFormat('HH:mm');

    selectedTime = timeFormat.format(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
      ),
    );

    speedTextController.text = '5';
    spotStayTimeTextController.text = '20';
    adjustPercentTextController.text = '20';
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                SizedBox(width: context.screenSize.width),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('計算値設定'), SizedBox.shrink()],
                ),

                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(flex: 7, child: Row(children: <Widget>[const Text('出発時刻：'), Text(selectedTime)])),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.blueGrey,
                                    ).copyWith(background: Colors.black.withOpacity(0.2)),
                                  ),
                                  child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  ),
                                );
                              },
                            );

                            if (time != null) {
                              setState(() {
                                selectedTime =
                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text('出発時刻を\n変更する', style: TextStyle(fontSize: 8, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: Row(
                    children: <Widget>[
                      const Expanded(flex: 7, child: Text('歩く速度（時速）：')),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),

                          controller: speedTextController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          ),
                          onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                      ),
                      const SizedBox(width: 40, child: Row(children: <Widget>[SizedBox(width: 20), Text('Km')])),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: Row(
                    children: <Widget>[
                      const Expanded(flex: 7, child: Text('施設滞在時間：')),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),

                          controller: spotStayTimeTextController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          ),
                          onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                      ),
                      const SizedBox(width: 40, child: Row(children: <Widget>[SizedBox(width: 20), Text('分')])),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3))),
                  ),
                  padding: const EdgeInsets.all(5),

                  child: Row(
                    children: <Widget>[
                      const Expanded(flex: 7, child: Text('調整率：')),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          style: const TextStyle(fontSize: 12),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),

                          controller: adjustPercentTextController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          ),
                          onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                      ),
                      const SizedBox(width: 40, child: Row(children: <Widget>[SizedBox(width: 20), Text('%')])),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () {
                    if (selectedTime == '' ||
                        speedTextController.text == '' ||
                        spotStayTimeTextController.text == '' ||
                        adjustPercentTextController.text == '') {
                      // ignore: always_specify_types
                      Future.delayed(
                        Duration.zero,
                        () => error_dialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          title: 'エラー',
                          content: '計算値が設定されていません。',
                        ),
                      );

                      return;
                    }

                    appParamNotifier.setStartTime(time: selectedTime);
                    appParamNotifier.setWalkSpeed(speed: speedTextController.text);
                    appParamNotifier.setStayTime(time: spotStayTimeTextController.text);
                    appParamNotifier.setAdjustPercent(percent: adjustPercentTextController.text);

                    TempleDialog(context: context, widget: RouteDisplayAlert());
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('設定結果を確認する'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
