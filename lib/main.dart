import 'package:flutter/material.dart';
import 'screens/vacancies_list.dart';

void main() {
  runApp(const UNHCR());
}

class UNHCR extends StatelessWidget {
  const UNHCR({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const VacanciesList(),
    );
  }
}
