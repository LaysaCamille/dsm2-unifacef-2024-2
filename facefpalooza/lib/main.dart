import 'package:flutter/material.dart';
import 'widgets/act_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'facefpalooza', // Nome do projeto configurado no Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // ValueNotifier controla o estado do tema do aplicativo
  final ValueNotifier<ThemeMode> _themeNotifier =
      ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Facefpalooza',
          debugShowCheckedModeBanner: false, // Removendo a faixa "Debug"
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Tema claro baseado em uma cor principal
            useMaterial3: true, // Aplicando o Material Design 3
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark, // Tema escuro
            ),
            useMaterial3: true,
          ),
          themeMode: themeMode, // Tema dinâmico controlado pelo botão
          home: MyHomePage(
            title: 'Facefpalooza',
            themeNotifier: _themeNotifier, // Enviando o controlador do tema
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.themeNotifier,
  });

  final String title;
  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Column(
        children: [
          const Expanded(child: ActList()), // Lista dos atos do festival
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, themeMode, child) {
              return SwitchListTile(
                title: const Text("Ativar tema escuro"),
                value: themeMode == ThemeMode.dark, // Verifica o estado atual do tema
                onChanged: (value) {
                  // Alterna entre temas claro e escuro
                  themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}