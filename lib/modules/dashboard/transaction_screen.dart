import 'package:flutter/material.dart';
import 'home_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description, color: Color(0xFF0066FF), size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                          Text(
                            'All your bill payments & history',
                            style: TextStyle(
                              fontSize: 11,
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
                    child: const Icon(Icons.filter_list, color: Color(0xFF0066FF), size: 20),
                  ),
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
                      'Search by biller, id or amount...',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('Electricity', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Mobile', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('FASTag', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Gas', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Water', false),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              const GeneralRecentCard(
                title: 'Electricity Bill',
                subtitle: '12 Mar 2025, 10:24 AM • Ref: #BK982341',
                amount: '₹2,450.00',
                icon: Icons.flash_on,
                iconBgColor: Color(0xFFFFFAED),
                iconColor: Colors.amber,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'Mobile Recharge',
                subtitle: '10 Mar 2025, 08:17 PM • Ref: #BK873421',
                amount: '₹499.00',
                icon: Icons.phone_iphone,
                iconBgColor: Color(0xFFFFEBEE),
                iconColor: Colors.pink,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'FASTag Recharge',
                subtitle: '08 Mar 2025, 11:03 AM • Ref: #BK654312',
                amount: '₹300.00',
                icon: Icons.directions_car,
                iconBgColor: Color(0xFFFBE9E7),
                iconColor: Colors.deepOrange,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'Gas Pipeline Bill',
                subtitle: '05 Mar 2025, 02:45 PM • Ref: #BK543219',
                amount: '₹820.00',
                icon: Icons.local_fire_department,
                iconBgColor: Color(0xFFFFEBEE),
                iconColor: Colors.red,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'Water Board Bill',
                subtitle: '01 Mar 2025, 09:15 AM • Ref: #BK432187',
                amount: '₹450.00',
                icon: Icons.water_drop,
                iconBgColor: Color(0xFFE1F5FE),
                iconColor: Colors.lightBlue,
              ),
              const SizedBox(height: 10),
              const GeneralRecentCard(
                title: 'DTH Recharge',
                subtitle: '26 Feb 2025, 04:30 PM • Ref: #BK321098',
                amount: '₹350.00',
                icon: Icons.live_tv,
                iconBgColor: Color(0xFFE3F2FD),
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0066FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }
}
