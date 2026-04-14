import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Config',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: const Color(0xFFF2F4F8),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Biến lưu trạng thái
  bool isSoundOn = false;
  bool isAutoSaveOn = false;
  double volumeValue = 50.0; // Range: 0.0 - 100.0
  int highScore = 3500;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Hàm tải dữ liệu từ SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSoundOn = prefs.getBool('isSoundOn') ?? false;
      isAutoSaveOn = prefs.getBool('isAutoSaveOn') ?? false;
      volumeValue = prefs.getDouble('volumeValue') ?? 50.0;
      highScore = prefs.getInt('highScore') ?? 3500;
    });
  }

  // Hàm lưu dữ liệu vào SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundOn', isSoundOn);
    await prefs.setBool('isAutoSaveOn', isAutoSaveOn);
    await prefs.setDouble('volumeValue', volumeValue);
    await prefs.setInt('highScore', highScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4834DF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.gamepad_rounded, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Cấu hình Game",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Đố vui",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),

            // --- CONTENT ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card: Điểm cao nhất
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F6FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              "Điểm cao nhất",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF444444),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$highScore",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card: Âm thanh
                  _buildSettingCard(
                    icon: Icons.volume_up,
                    title: "Âm thanh",
                    child: Switch(
                      value: isSoundOn,
                      activeColor: const Color(0xFF6C63FF),
                      onChanged: (value) {
                        setState(() {
                          isSoundOn = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Card: Tự động lưu
                  _buildSettingCard(
                    icon: Icons.save_alt,
                    title: "Tự động lưu game",
                    child: Switch(
                      value: isAutoSaveOn,
                      activeColor: const Color(0xFF6C63FF),
                      onChanged: (value) {
                        setState(() {
                          isAutoSaveOn = value;
                          _saveSettings();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Card: Volume (ĐÃ SỬA SLIDER)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.graphic_eq, color: Colors.grey[600]),
                            const SizedBox(width: 15),
                            const Text(
                              "Volume",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF444444),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.volume_mute, size: 18, color: Colors.grey),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFF6C63FF),
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbColor: const Color(0xFF6C63FF),
                                  trackHeight: 6.0,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  value: volumeValue,
                                  min: 0.0,        
                                  max: 100.0,      
                                  divisions: 100,  
                                  label: '${volumeValue.round()}%', 
                                  onChanged: (value) {
                                    setState(() {
                                      volumeValue = value;
                                    });
                                  },
                                  onChangeEnd: (value) {
                                    _saveSettings();
                                  },
                                ),
                              ),
                            ),
                            Icon(Icons.volume_up, size: 18, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nút Lưu cấu hình
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Đã lưu cấu hình thành công!"),
                      backgroundColor: Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 3,
                ),
                child: const Text(
                  "LƯU CẤU HÌNH",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget tái sử dụng cho các dòng setting
  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 24),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
