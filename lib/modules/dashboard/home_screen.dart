import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../route/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class CardAnimationValues {
  final double translateY;
  final double scale;
  final double opacity;

  CardAnimationValues({required this.translateY, required this.scale, required this.opacity});
}

CardAnimationValues getCardAnimationValues(double controllerValue, int index) {
  final double delayFraction = (index * 0.05).clamp(0.0, 0.7);
  final double animDurationFraction = 0.48;
  final double endFraction = (delayFraction + animDurationFraction).clamp(0.0, 1.0);

  double t = 0.0;
  if (controllerValue >= endFraction) {
    t = 1.0;
  } else if (controllerValue <= delayFraction) {
    t = 0.0;
  } else {
    t = (controllerValue - delayFraction) / (endFraction - delayFraction);
  }

  // Exact CSS cubic-bezier(.34, 1.56, .64, 1)
  final double curvedT = const Cubic(0.34, 1.56, 0.64, 1).transform(t);

  double translateY;
  double scale;
  double opacity;

  if (curvedT <= 0.6) {
    final double subT = curvedT / 0.6;
    translateY = -18.0 + (3.0 - (-18.0)) * subT;
    scale = 0.85 + (1.04 - 0.85) * subT;
    opacity = subT.clamp(0.0, 1.0);
  } else {
    final double subT = (curvedT - 0.6) / 0.4;
    translateY = 3.0 + (0.0 - 3.0) * subT;
    scale = 1.04 + (1.0 - 1.04) * subT;
    opacity = 1.0;
  }

  return CardAnimationValues(translateY: translateY, scale: scale, opacity: opacity);
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  late AnimationController _animationController;
  Worker? _tabWorker;

  late final Animation<double> _notificationBounceAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.35), weight: 35),
    TweenSequenceItem(tween: Tween<double>(begin: 1.35, end: 0.9), weight: 35),
    TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 30),
  ]).animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
  ));

  late final Animation<double> _notificationTranslateAnimation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -14.0), weight: 35),
    TweenSequenceItem(tween: Tween<double>(begin: -14.0, end: 4.0), weight: 35),
    TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: 0.0), weight: 30),
  ]).animate(CurvedAnimation(
    parent: _animationController,
    curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
  ));

  static final List<ServiceItem> _services = [
    ServiceItem('Electricity', Icons.flash_on, const Color(0xFFFFFAED), Colors.amber[800]!),
    ServiceItem('Mobile', Icons.phone_iphone, const Color(0xFFFFEBEE), Colors.pink[600]!),
    ServiceItem('DTH', Icons.live_tv, const Color(0xFFE3F2FD), Colors.blue[600]!),
    ServiceItem('FASTag', Icons.directions_car, const Color(0xFFFBE9E7), Colors.deepOrange[600]!),
    ServiceItem('Gas', Icons.local_fire_department, const Color(0xFFFFEBEE), Colors.red[600]!),
    ServiceItem('Water', Icons.water_drop, const Color(0xFFE1F5FE), Colors.lightBlue[600]!),
    ServiceItem('Postpaid', Icons.phone_android, const Color(0xFFE8EAF6), Colors.indigo[600]!),
    ServiceItem('Insurance', Icons.security, const Color(0xFFE8F5E9), Colors.green[600]!),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Exact CSS parameters: duration 480ms + staggered delay (0.05s per item)
    final totalDurationMs = 480 + (_services.length * 50);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalDurationMs),
    );

    _animationController.value = 0.0;

    // Trigger animation after the first frame / route transition is fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward(from: 0.0);
      }
    });

    // Listen to tab changes to replay animation whenever coming to Home (index 0)
    if (Get.isRegistered<DashboardController>()) {
      final dashboardController = Get.find<DashboardController>();
      _tabWorker = ever(dashboardController.currentIndex, (index) {
        if (index == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _animationController.forward(from: 0.0);
            }
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // Replay animation when coming back from another pushed screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Replay animation when app is resumed/re-opened from background or clear
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _animationController.forward(from: 0.0);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    _tabWorker?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: Logo & Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset('assets/images/logo_home.png', height: 34),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Profile Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF0066FF),
                              backgroundImage: const AssetImage('assets/images/avatar.png'),
                              onBackgroundImageError: (exception, stackTrace) {},
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ashad Retail ...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Good Morning!',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Notification Bell with prominent Bounce / Pop animation & Badge '4'
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.black87, size: 20),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: const Center(
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Promotional Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'In one kart!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Explore Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo_blink.png',
                            width: 54,
                            height: 54,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_cart_checkout, size: 48, color: Color(0xFF0066FF)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Page Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 20, height: 6, decoration: BoxDecoration(color: const Color(0xFF0066FF), borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 4),
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[350], shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[350], shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      'Search services, bills or operator...',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recharge & Pay Bills Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recharge & Pay Bills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0066FF)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Highly Visible Staggered Bouncy Icons Grid (Exact CSS cardDrop animation)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final animValues = getCardAnimationValues(_animationController.value, index);
                      return Opacity(
                        opacity: animValues.opacity,
                        child: Transform.translate(
                          offset: Offset(0, animValues.translateY),
                          child: Transform.scale(
                            scale: animValues.scale,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: ServiceCardItem(service: service),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Recent History Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0066FF)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Recent History Cards List
              const RecentHistoryCard(
                title: 'Electricity Bill',
                subtitle: '12 Mar 2025, 10:24 AM',
                amount: '₹2,450.00',
                icon: Icons.flash_on,
                iconBgColor: Color(0xFFFFFAED),
                iconColor: Colors.amber,
              ),
              const SizedBox(height: 10),
              const RecentHistoryCard(
                title: 'Mobile Recharge',
                subtitle: '10 Mar 2025, 08:17 PM',
                amount: '₹499.00',
                icon: Icons.phone_iphone,
                iconBgColor: Color(0xFFFFEBEE),
                iconColor: Colors.pink,
              ),
              const SizedBox(height: 10),
              const RecentHistoryCard(
                title: 'FASTag',
                subtitle: '08 Mar 2025, 11:03 AM',
                amount: '₹300.00',
                icon: Icons.directions_car,
                iconBgColor: Color(0xFFFBE9E7),
                iconColor: Colors.deepOrange,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  ServiceItem(this.title, this.icon, this.bgColor, this.iconColor);
}

class ServiceCardItem extends StatefulWidget {
  final ServiceItem service;

  const ServiceCardItem({super.key, required this.service});

  @override
  State<ServiceCardItem> createState() => _ServiceCardItemState();
}

class _ServiceCardItemState extends State<ServiceCardItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Get.snackbar(
          widget.service.title,
          'Selected ${widget.service.title}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: widget.service.iconColor.withValues(alpha: 0.1),
          colorText: widget.service.iconColor,
          duration: const Duration(milliseconds: 1200),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.service.bgColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.service.icon,
                    color: widget.service.iconColor,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.service.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RecentHistoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const RecentHistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GeneralRecentCard(
      title: title,
      subtitle: subtitle,
      amount: amount,
      icon: icon,
      iconBgColor: iconBgColor,
      iconColor: iconColor,
    );
  }
}

class GeneralRecentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const GeneralRecentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
