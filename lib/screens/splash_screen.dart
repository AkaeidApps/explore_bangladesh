import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) widget.onFinished();
    });
  }
  @override
  void dispose() { _wave.dispose(); _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF173D2C), Color(0xFF245C42), Color(0xFF6F956B)])),
      child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnimatedBuilder(
          animation: Listenable.merge([_wave, _pulse]),
          builder: (context, _) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..setEntry(3, 2, .0015)..rotateY(math.sin(_wave.value * math.pi * 2) * .16)..rotateZ(math.sin(_wave.value * math.pi * 2) * .02),
            child: Container(
              width: 210, height: 126,
              decoration: BoxDecoration(color: const Color(0xFF006A4E), borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .22), blurRadius: 28, offset: const Offset(0, 14))]),
              child: Center(child: Container(width: 62 + _pulse.value * 4, height: 62 + _pulse.value * 4, decoration: const BoxDecoration(color: Color(0xFFF42A41), shape: BoxShape.circle))),
            ),
          ),
        ),
        const SizedBox(height: 34),
        const Text('Explore Bangladesh', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -.5)),
        const SizedBox(height: 8),
        Text('Find your next natural escape', style: TextStyle(color: Colors.white.withValues(alpha: .84))),
        const SizedBox(height: 36),
        const SizedBox(width: 110, child: LinearProgressIndicator(minHeight: 3, color: Colors.white, backgroundColor: Colors.white24)),
      ])),
    ),
  );
}
