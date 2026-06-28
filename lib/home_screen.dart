import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera.dart';
import 'questionnaire.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _skinType = 'Unknown';
  String _latestSkinConcern = 'Unknown';
  double _latestSkinConfidence = 0.0;
  String _skinStatus = "Complete quiz to see status";

  @override
  void initState() {
    super.initState();
    _loadSkinProfile();
  }

  Future<void> _loadSkinProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _skinType = prefs.getString('skin_type') ?? 'Unknown';
      _skinStatus = prefs.getString('skin_status') ?? "Complete quiz to see status";
      _latestSkinConcern = prefs.getString('latest_skin_concern') ?? 'Unknown';
      _latestSkinConfidence = prefs.getDouble('latest_skin_confidence') ?? 0.0;
    });
  }

  Future<void> _openCamera() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
    _loadSkinProfile();
  }

  Future<void> _openQuestionnaire() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
    _loadSkinProfile();
  }

  String _formatClass(String value) => value == 'Unknown' ? value : value.replaceAll('_', ' ').toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP HEADER SECTION
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6EEFA),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good evening,', style: TextStyle(color: Colors.black54, fontSize: 16)),
                            SizedBox(height: 4),
                            Text("NUR SOFIATUNNISA'\nBINTI MOHD ZAKI ✨", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'serif', height: 1.2)),
                          ],
                        ),
                      ),
                      const CircleAvatar(backgroundColor: Color(0xFFA259B3), radius: 26, child: Text("N", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard(Icons.access_time, "Analyses", _latestSkinConcern == 'Unknown' ? "0" : "1", Colors.red.shade300)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildStatCard(Icons.auto_awesome, "Streak", "3 days", Colors.purple.shade300)),
                    ],
                  ),
                ],
              ),
            ),
            
            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkinAnalysisBanner(),
                  const SizedBox(height: 30),
                  const Text("Your Skin Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildUnifiedProfileCard(),
                  const SizedBox(height: 30),
                  // ... rest of your UI
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        backgroundColor: const Color(0xFFA259B3),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 65.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: [_buildNavItem(Icons.home_rounded, "Home", 0), _buildNavItem(Icons.history_rounded, "History", 1)]),
              Row(children: [_buildNavItem(Icons.spa_rounded, "Products", 2), _buildNavItem(Icons.person_outline_rounded, "Profile", 3)]),
            ],
          ),
        ),
      ),
    );
  }

  // FIXED: Card now uses Expanded to stop the text overflow error
  Widget _buildUnifiedProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Wrapping this row in Expanded stops the button overflow
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle), child: const Icon(Icons.face, color: Color(0xFFA259B3))),
                    const SizedBox(width: 15),
                    Expanded( // Forces text to wrap instead of overflowing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: $_skinType", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          Text(_skinStatus, style: const TextStyle(color: Color(0xFFA259B3), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _openQuestionnaire,
                child: Text(_skinType == 'Unknown' ? "Take Quiz" : "Retake", style: const TextStyle(color: Color(0xFFA259B3), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 25, color: Color(0xFFF6EEFA), thickness: 1.5),
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, color: Color(0xFFA259B3))),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Skin Concern: ${_formatClass(_latestSkinConcern)}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(_latestSkinConcern == 'Unknown' ? "No recent scan" : "Confidence: ${(_latestSkinConfidence * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // RESTORED: Original Banner
  Widget _buildSkinAnalysisBanner() {
    return Container(
      width: double.infinity, height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFB854A6), Color(0xFF8C52FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1))),
          Positioned(right: 40, bottom: -30, child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Capture your daily selfie to track progress.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                const Text("Start Skin Analysis", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                  label: const Text("Take Selfie", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return MaterialButton(
      minWidth: 60,
      onPressed: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFA259B3) : Colors.grey.shade400),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFFA259B3) : Colors.grey.shade400, fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}