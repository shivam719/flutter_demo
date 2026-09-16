import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/common_controller.dart';
import '../../route/app_routes.dart';

/// Zomato / Blinkit-style Splash Screen:
/// 1. App opens with plain yellow screen (matching native launch screen #FFEB3B).
/// 2. Yellow screen stays for 1 second.
/// 3. Logo enters with a smooth Pop-in (Scale + Fade) animation.
/// 4. Logo blinks/pulses continuously until total 5 seconds elapsed.
/// 5. Navigates smoothly to Next Screen (Login / Dashboard).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Duration yellowOnlyDuration = Duration(seconds: 1);
  static const Duration totalDuration = Duration(seconds: 5);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    // 1. Entry Animation (Pop-in / Scale + Fade)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );

    // 2. Continuous Pulse / Blink Animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entryController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.repeat(reverse: true);
      }
    });

    // Step 1: Show plain yellow screen for 1 sec, then show logo with animation
    Future.delayed(SplashScreen.yellowOnlyDuration, () {
      if (!mounted) return;
      setState(() => _showLogo = true);
      _entryController.forward();
    });

    // Step 2: Total 5 seconds complete -> Navigate to Next Screen
    Future.delayed(SplashScreen.totalDuration, () {
      if (!mounted) return;
      _pulseController.stop();
      final isLoggedIn = Get.isRegistered<CommonController>() &&
          CommonController.to.loadLoginUserData();
      Get.offAllNamed(isLoggedIn ? AppRoutes.dashboard : AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEB3B), // Zomato / Blinkit Yellow
      body: Center(
        child: _showLogo
            ? AnimatedBuilder(
                animation: Listenable.merge([_entryController, _pulseController]),
                builder: (context, child) {
                  final scale = _entryController.isCompleted
                      ? _pulseAnimation.value
                      : _scaleAnimation.value;
                  final opacity = _entryController.isCompleted
                      ? 1.0
                      : _fadeAnimation.value;

                  return Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: _buildLogo(),
              )
            : const SizedBox.shrink(), // Plain yellow screen during first second
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo_blink.png',
      width: 200,
      height: 200,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/avatar.png',
          width: 180,
          height: 180,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.flash_on_rounded,
              size: 140,
              color: Colors.black87,
            );
          },
        );
      },
    );
  }
}
