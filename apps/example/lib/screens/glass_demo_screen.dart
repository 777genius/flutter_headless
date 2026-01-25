import 'package:flutter/material.dart';
import 'package:liquid_glass_apple/liquid_glass_apple.dart';

class GlassDemoScreen extends StatelessWidget {
  const GlassDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Glassmorphism Demo')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GlassStyleCard(
                  style: GlassStyle.ultraThin,
                  title: 'Ultra Thin',
                  description: 'Blur σ=8, Tint 10%',
                ),
                const SizedBox(height: 16),
                const GlassStyleCard(
                  style: GlassStyle.thin,
                  title: 'Thin',
                  description: 'Blur σ=10, Tint 15%',
                ),
                const SizedBox(height: 16),
                const GlassStyleCard(
                  style: GlassStyle.regular,
                  title: 'Regular',
                  description: 'Blur σ=12, Tint 20%',
                ),
                const SizedBox(height: 16),
                const GlassStyleCard(
                  style: GlassStyle.thick,
                  title: 'Thick',
                  description: 'Blur σ=15, Tint 25%',
                ),
                const SizedBox(height: 16),
                const GlassStyleCard(
                  style: GlassStyle.chrome,
                  title: 'Chrome',
                  description: 'Blur σ=20, Tint 30%',
                ),
                const SizedBox(height: 32),
                const GlassOverlapDemo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassStyleCard extends StatelessWidget {
  const GlassStyleCard({
    super.key,
    required this.style,
    required this.title,
    required this.description,
  });

  final GlassStyle style;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      style: style,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassOverlapDemo extends StatelessWidget {
  const GlassOverlapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Overlapping Glass',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: GlassContainer(
                  style: GlassStyle.regular,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(24),
                  child: const SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text(
                        'Back',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GlassContainer(
                  style: GlassStyle.thick,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(24),
                  child: const SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text(
                        'Front',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
