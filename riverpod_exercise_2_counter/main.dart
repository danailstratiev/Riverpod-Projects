import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  ((ref) => Counter()),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: HomePage(),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

const JSON<int> myJson = {
  'age': 1,
};

typedef JSON<T> = Map<String, T>;

void testIt() {
  final int? int1 = 1;
  final int? int2 = null;
  final result = int1 + int2;
}

final currentDate = Provider<DateTime>(
  (ref) => DateTime.now(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home page',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: (() {
              ref.read(counterProvider.notifier).increment();
            }),
            child: const Text('Increment'),
          ),
          Center(child: Consumer(
            builder: ((context, ref, child) {
              final count = ref.watch(counterProvider);
              final text =
                  count == null ? 'Press the button' : count.toString();
              return Text(text);
            }),
          ))
        ],
      ),
    );
  }
}
