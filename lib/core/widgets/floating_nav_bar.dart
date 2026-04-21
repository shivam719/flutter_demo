import 'package:flutter/material.dart';

/// @Created by akash on 19-02-2026.
/// Know more about author at https://akash.cloudemy.in

class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({super.key});

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  int selectedIndex = 0;

  final icons = const [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(icons.length, (index) {
          final isSelected = index == selectedIndex;

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 16.0),
            child: InkWell(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              borderRadius: BorderRadius.circular(32),
              child: SizedBox(
                width: 48,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                      child: child,
                    );
                  },
                  child: isSelected
                      ? Container(
                    key: const ValueKey('filled'),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      _filledIcon(icons[index]),
                      color: colorScheme.inversePrimary,
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      icons[index],
                      key: const ValueKey('outlined'),
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData _filledIcon(IconData icon) {
    switch (icon) {
      case Icons.home_outlined:
        return Icons.home;
      case Icons.calendar_month_outlined:
        return Icons.calendar_month;
      case Icons.account_balance_wallet_outlined:
        return Icons.account_balance_wallet;
      case Icons.person_outline:
        return Icons.person;
      default:
        return icon;
    }
  }
}
