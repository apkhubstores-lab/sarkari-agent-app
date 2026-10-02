import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MaterialApp(home: AgentHomeScreen()));
}

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  bool isAgentActive = false;
  final FlutterTts tts = FlutterTts();
  late GenerativeModel model;

  // AAPKI GEMINI API KEY YAHAN AAYEGI
  final String apiKey = "YOUR_GEMINI_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    _initAI();
  }

  void _initAI() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "Tum ek friendly Indian Government Form Assistant ho. User screen par PAN (NSDL), Voter ID, ya DL ka form bharega. Unhe live bol kar guide karo. Agar name fields (First/Middle/Last Name) me galti karein, toh kindly unhe toko aur batao ki sahi tarike se kaise bharen."
      ),
    );
    tts.setLanguage("hi-IN");
  }

  void toggleAgent(bool val) async {
    setState(() => isAgentActive = val);
    if (val) {
      await SystemAlertWindow.requestPermissions();
      SystemAlertWindow.showSystemWindow(
        height: 100,
        width: 100,
        gravity: SystemWindowGravity.TOP_RIGHT,
      );
      await tts.speak("Hello sir! Agent mode start ho gaya hai. Aap kaunsa form bharna chahte hain?");
    } else {
      SystemAlertWindow.closeSystemWindow();
      await tts.speak("Agent stop ho gaya hai.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sarkari AI Agent")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy, size: 80, color: isAgentActive ? Colors.green : Colors.grey),
            const SizedBox(height: 20),
            Text(
              isAgentActive ? "Agent Mode: ON" : "Agent Mode: OFF",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Switch(
              value: isAgentActive,
              onChanged: toggleAgent,
            ),
          ],
        ),
      ),
    );
  }
}
