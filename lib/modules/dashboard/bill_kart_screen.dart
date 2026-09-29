import 'package:flutter/material.dart';
import 'home_screen.dart';

class BillKartScreen extends StatelessWidget {
  const BillKartScreen({super.key});

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_cart, color: Color(0xFF0066FF), size: 28),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BillKart Hub',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                          Text(
                            'THE FASTEST PAYMENT, SURE PAYMENTS',
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Color(0xFF0066FF), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066FF), Color(0xFF0040DD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0066FF).withValues(alpha: 0.3),
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
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Instant Bill Settlement',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Zero Fee on All Utility Bills in BillKart!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.flash_on, size: 56, color: Colors.amberAccent),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Quick Bill Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Service Cards Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _buildServiceCard('Electricity', Icons.flash_on, const Color(0xFFFFFAED), Colors.amber[800]!),
                  _buildServiceCard('Mobile', Icons.phone_iphone, const Color(0xFFFFEBEE), Colors.pink[600]!),
                  _buildServiceCard('DTH', Icons.live_tv, const Color(0xFFE3F2FD), Colors.blue[600]!),
                  _buildServiceCard('FASTag', Icons.directions_car, const Color(0xFFFBE9E7), Colors.deepOrange[600]!),
                  _buildServiceCard('Gas', Icons.local_fire_department, const Color(0xFFFFEBEE), Colors.red[600]!),
                  _buildServiceCard('Water', Icons.water_drop, const Color(0xFFE1F5FE), Colors.lightBlue[600]!),
                  _buildServiceCard('Postpaid', Icons.phone_android, const Color(0xFFE8EAF6), Colors.indigo[600]!),
                  _buildServiceCard('Insurance', Icons.security, const Color(0xFFE8F5E9), Colors.green[600]!),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Active Reminders & Pending Bills',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              const GeneralRecentCard(
                title: 'Electricity Bill Due',
                subtitle: 'Due in 2 Days • ₹2,450.00',
                amount: 'Pay Now',
                icon: Icons.flash_on,
                iconBgColor: Color(0xFFFFFAED),
                iconColor: Colors.amber,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'Postpaid Mobile Bill',
                subtitle: 'Due in 5 Days • ₹799.00',
                amount: 'Pay Now',
                icon: Icons.phone_android,
                iconBgColor: Color(0xFFE8EAF6),
                iconColor: Colors.indigo,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color bgColor, Color iconColor) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
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
              child: Icon(icon, color: iconColor, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
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
    );
  }
}
