import 'package:crt_monitor_effect/scanline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

const Color primaryColor = Color(0xFFffffff);
const Color secondaryColor = Color(0xFF00FF7F);
const Color backgroundColor = Color(0xFF090A0C);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRT Monitor',
      theme: ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        highlightColor: Colors.white,
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        textTheme: GoogleFonts.spaceMonoTextTheme(),
      ),
      builder: (context, child) {
        return Scanline(
          enabled: true,
          child: child!,
        );
      },
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ChromaticText(
          text: "CRT Monitor effect".toUpperCase(),
        ),
      ),
    );
  }
}
