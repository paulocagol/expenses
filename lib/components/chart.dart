import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentsTransactions;

  const Chart({Key key, this.recentsTransactions}) : super(key: key);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));

        double totalSum = 0.0;

        for (var i = 0; i < recentsTransactions.length; i++) {
          bool sameDay = recentsTransactions[i].date.day == weekDay.day;
          bool sameMonth = recentsTransactions[i].date.month == weekDay.month;
          bool sameYer = recentsTransactions[i].date.year == weekDay.year;

          if (sameDay && sameMonth && sameYer) {
            totalSum += recentsTransactions[i].value;
          }
        }

        return {
          'day': DateFormat.E().format(weekDay)[0],
          'value': totalSum,
        };
      },
    ).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0, (acumulador, tr) {
      return acumulador + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage: _weekTotalValue == 0 ? 0 : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
