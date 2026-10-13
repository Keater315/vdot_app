import 'package:flutter/material.dart';
import 'vdot_calculator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VDOT Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'PaceTuner'),
    );
  }
}

  // This widget is the root of your application.
  
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController inputController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController difficultyController = TextEditingController();
  TextEditingController paceInputController = TextEditingController();
  Map<String, List<String>> paceResults = {};
  Map<String, double> results = {};
  final paceGroup = AutoSizeGroup();
  bool paceMode = false;
  @override
  Widget build(BuildContext context) {
    Color themeColor = paceMode ? const Color.fromARGB(255, 36, 27, 218) : Colors.deepPurple;
     Color titleboxColor = paceMode ? const Color.fromARGB(255, 15, 7, 172) :Color.fromARGB(255, 75, 0, 130);
List<Widget> vdotModeChildren = [
            SizedBox(height: 55),
          TextField(
            controller: distanceController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Distance in meters (e.g. 5000)'
            )
          ),
          SizedBox(height: 20),
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Runners and times (e.g. Noah 20:00 Wyatt 18:00 etc)"
            )
          ),  
          SizedBox(height:20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(170, 40),
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
              List<String> words = inputController.text.split(' ');
              for (var i = 0; i < words.length; i = i+2) {
                double vdot = calculateVdot(double.parse(distanceController.text), words[i+1]);
                results[words[i]] = vdot;
              }
            });
            },
            child: Text(
              'Calculate',
              style: GoogleFonts.robotoMono(fontSize: 20),
              ),
          ),
          SizedBox(height: 80),
          Container(
    constraints: BoxConstraints(
      minHeight: 250,
      minWidth: 700,
    ),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: themeColor, width: 4),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: results.entries.map((entry) {
      return Text('${entry.key} ${entry.value.round()}',
      style: GoogleFonts.robotoMono(fontSize: 25));
      }).toList(),
      ),
     ),
     SizedBox(height: 20),
     ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 181, 179, 179),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.robotoMono(),
      ),
      onPressed: () async {
     String vdotTextToCopy = results.entries.map((entry) => '${entry.key} ${entry.value.round()}')
      .join(' ');
      await Clipboard.setData(ClipboardData(text: vdotTextToCopy));
      },
      child: const Text('Copy results'),
     ),
];


List<Widget> paceModeChildren = [
            SizedBox(height: 55),
          TextField(
            controller: difficultyController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Course difficulty (use light, mid, or hard)'
            )
          ),
          SizedBox(height: 20),
          TextField(
            controller: paceInputController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Runners and VDOT (e.g. Noah 50 Wyatt 52 etc)"
            )
          ),  
          SizedBox(height:20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(170, 40),
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
              List<String> words = paceInputController.text.split(' ');
              String difficulty = difficultyController.text;
              if (difficulty.isEmpty) {
                difficulty = 'mid';
              }
              for (var i = 0; i < words.length; i = i+2) {
                List<String> paces = calculatePace(difficulty, double.parse(words[i+1]));
                paceResults[words[i]] = paces;
              }
            });
            },
            child: Text(
              'Calculate',
              style: GoogleFonts.robotoMono(fontSize: 20),
              ),
          ),
          SizedBox(height: 50),
          Container(
    constraints: BoxConstraints(
      minHeight: 250,
      minWidth: 700,
    ),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: themeColor, width: 4),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: paceResults.entries.map<Widget>((entry) {
        return SizedBox(
          width: 660,
      child: AutoSizeText(
        '${entry.key} - Tempo = ${entry.value[0]}, Interval = ${entry.value[1]}, Repetition = ${entry.value[2]}',
      group: paceGroup,
      style: GoogleFonts.robotoMono(fontSize: 40),
      minFontSize: 10,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      ),
      );
      }).toList(),
    ),
      ),
      SizedBox(height: 20),
     ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 181, 179, 179),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.robotoMono(),
      ),
      onPressed: () async {
     String paceTextToCopy = paceResults.entries.map((entry) => '${entry.key} - Tempo = ${entry.value[0]}, Interval = ${entry.value[1]}, Repetition = ${entry.value[2]}')
     .join(' ');
      await Clipboard.setData(ClipboardData(text: paceTextToCopy));
      },
      child: const Text('Copy results'),
     ),
   ];

return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          color: titleboxColor,
          borderRadius: BorderRadius.circular(5.5),
        ),
        child: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 75, 0, 130),
            foregroundColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.25),
            side: paceMode
              ? BorderSide.none
              : const BorderSide(color: Colors.white, width: 2),
          ),
          child: Text(
            'VDOT MODE',
            style: GoogleFonts.robotoMono(fontSize: 15)
            ),
          onPressed: () {
            setState((){
              paceMode = false;
            });
          },
        ),  
        SizedBox(width: 10),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 15, 7, 172),
            foregroundColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.25),
            side: paceMode
              ? BorderSide(color: Colors.white, width: 2)
              : BorderSide.none,
          ),
          child: Text(
            'PACE MODE',
          ),
          onPressed: () {
            setState((){
              paceMode = true;
            }
          );
          }
        ),
        SizedBox(width: 20),
      ],  
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            children: paceMode ? paceModeChildren : vdotModeChildren,
          ),
        ),
      ),
);
}
}