import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

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

const names = [
  'Bob',
  'Rob',
  'Maddie',
  'Ron',
  'Kitty',
  'Ben',
  'Frank',
  'Melisa',
  'Susan'
];

final tickerProvider = StreamProvider((ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1,
    ));

final namesProvider =
    StreamProvider((ref) => ref.watch(tickerProvider.stream).map(
          (count) => names.getRange(0, count),
        ));

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home page',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: names.when(
          data: ((names) {
            return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(names.elementAt(index)),
                );
              },
            );
          }),
          error: ((error, stackTrace) =>
              const Text('Reached the end of the list!')),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
