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

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: '⛅',
      City.paris: '🌤',
      City.tokyo: '🌞',
    }[city]!,
  );
}

///We are giving a map and we are saving the key for that with the key from
///this map that we are going to extract is the city and then we are
///unwrapping it if the city does not exist this will be an optional value.

// UI writes to this and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🪐';

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Column(
        children: [
          currentWeather.when(
              data: (data) => Text(data),
              error: (error, stackTrace) => Text(error.toString()),
              loading: (() => Text('Loading'))),
          Expanded(
              child: ListView.builder(
            itemCount: City.values.length,
            itemBuilder: ((context, index) {
              final city = City.values[index];
              final isSelected = city == ref.watch(currentCityProvider);
              return ListTile(
                title: Text(city.toString()),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  ref.read(currentCityProvider.notifier).state = city;
                },
              );
            }),
          ))
        ],
      ),
    );
  }
}
