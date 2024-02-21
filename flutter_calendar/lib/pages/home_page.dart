import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, day);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  late DateTime selectedMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    selectedMonth = DateTime.now().monthStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Календарь',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(-1)),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                '${selectedMonth.year}-${selectedMonth.month}',
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(1)),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                final currentMonth = DateTime.now().monthStart;
                onChange(currentMonth);
              },
              child: const Text('Назад к текущему месяцу'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final firstDayOfWeek =
        DateTime(selectedMonth.year, selectedMonth.month, 1).weekday;

    final List<Widget> dayWidgets = [];

    for (int i = 0; i < firstDayOfWeek - 1; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      final isCurrentMonth = date.month == selectedMonth.month;
      final isSelected = selectedDate?.isSameDate(date) ?? false;
      final isToday = date.isToday;

      dayWidgets.add(
        GestureDetector(
          onTap: () => selectDate(date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.8)
                  : (isCurrentMonth ? Colors.white : Colors.grey),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isCurrentMonth
                        ? (isToday ? Colors.red : Colors.black)
                        : Colors.grey),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      children: dayWidgets,
    );
  }
}
