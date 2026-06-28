import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ml_services.dart';

class SkinResultPage extends StatefulWidget {
  final File imageFile;
  const SkinResultPage({super.key, required this.imageFile});

  @override
  State<SkinResultPage> createState() => _SkinResultPageState();
}

class _SkinResultPageState extends State<SkinResultPage> {
  final MLService _mlService = MLService();
  bool _isLoading = true;
  SkinPrediction? _prediction;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _runPrediction();
  }

  Future<void> _runPrediction() async {
    try {
      final result = await _mlService.predictImage(widget.imageFile);
      setState(() {
        _prediction = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSkinResult() async {
    if (_prediction == null) return;
    final prefs = await SharedPreferences.getInstance();

    // Run all shared preference saves concurrently to speed up execution
    await Future.wait([
      prefs.setString('latest_skin_concern', _prediction!.predictedClass),
      prefs.setDouble('latest_skin_confidence', _prediction!.confidence),
      prefs.setString('latest_skin_analysis_date', DateTime.now().toIso8601String()),
      prefs.setString('latest_skin_image_path', widget.imageFile.path),
    ]);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Skin analysis result saved!'),
        backgroundColor: Color(0xFFA259B3),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    _mlService.close();
    super.dispose();
  }

  // Condensed Helper Method
  String _formatClass(String className) => className.replaceAll('_', ' ').toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        title: const Text('Skin Analysis Result'),
        backgroundColor: const Color(0xFFEDE2F2),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildBody(), // Moved logic to a cleaner helper method
    );
  }

  Widget _buildBody() {
    // 1. Handle Loading State
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFA259B3)));
    }
    
    // 2. Handle Error State
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Prediction failed:\n$_errorMessage', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ),
      );
    }

    // Sort probabilities cleanly in one line
    final sortedProbs = _prediction!.probabilities.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // 3. Handle Success State
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 280,
              color: Colors.black,
              child: Image.file(widget.imageFile, fit: BoxFit.contain, width: double.infinity),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Detected Skin Result', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(_formatClass(_prediction!.predictedClass), textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          Text('Confidence: ${(_prediction!.confidence * 100).toStringAsFixed(2)}%', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 28),
          const Text('All Class Probabilities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          // Generate the probability cards
          ...sortedProbs.map((entry) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  title: Text(_formatClass(entry.key), style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text('${(entry.value * 100).toStringAsFixed(2)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              )),
              
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retake'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveSkinResult,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Result'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA259B3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}