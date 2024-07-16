import 'package:controlbs_mobile/core/utils/capitalize.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/users/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarBreak extends StatefulWidget {
  const CalendarBreak({
    super.key,
  });

  @override
  State<CalendarBreak> createState() => _CalendarBreakState();
}

class _CalendarBreakState extends State<CalendarBreak> {
  late final UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userProvider.getListBreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.calendar_month,
                  size: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SubTitleWidget(text: "Calendario de la semana"),
            const SizedBox(
              height: 10,
            ),
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              return userProvider.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: userProvider.listBreak.reversed
                              .take(5)
                              .toList()
                              .map((day) {
                            if (day!.pebrDay.day == DateTime.now().day) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                  Text(
                                    capitalize(day.pebrDays),
                                    style: const TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day.pebrDay),
                                    style: const TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    day.pewbrName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (day.pebrDay.day < DateTime.now().day) {
                              return Column(
                                children: [
                                  Text(
                                    capitalize(day.pebrDays),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day.pebrDay),
                                    style: TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    day.pewbrName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Text(day.pebrDays);
                          }).toList(),
                        ),
                        const SizedBox(height: 20), // Espacio entre las semanas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: userProvider.listBreak.reversed
                              .toList()
                              .skip(5)
                              .map((day) {
                            if (day!.pebrDay.day == DateTime.now().day) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                  Text(
                                    capitalize(day.pebrDays),
                                    style: const TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day.pebrDay),
                                    style: const TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    day.pewbrName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (day.pebrDay.day < DateTime.now().day) {
                              return Column(
                                children: [
                                  Text(
                                    capitalize(day.pebrDays),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('d').format(day.pebrDay),
                                    style: TextStyle(
                                      // color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  Text(
                                    day.pewbrName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                Text(
                                  capitalize(day.pebrDays),
                                  style: const TextStyle(
                                      // color: Colors.green,
                                      // fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  DateFormat('d').format(day.pebrDay),
                                  style: const TextStyle(
                                      // color: Colors.green,
                                      // fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  day.pewbrName,
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    );
            }),

            const SizedBox(height: 20), // Espacio entre las semanas
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: nextWeekDays.map((day) {
            //     return Text(DateFormat('EEE\nd').format(day));
            //   }).toList(),
            // ),
          ],
        )));
  }
}
