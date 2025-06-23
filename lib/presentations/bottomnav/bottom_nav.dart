import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';

class BottomNavUi extends StatefulWidget {
  const BottomNavUi({super.key});

  @override
  State<BottomNavUi> createState() => _BottomNavUiState();
}

class _BottomNavUiState extends State<BottomNavUi> {
  int _page = 0;

  final List<String> _labels = [
    'Home',
    'Messages',
    'Add',
    'Notifications',
    'Profile',
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.message,
    Icons.shopping_cart,
    Icons.person_pin,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Current Page: ${_labels[_page]}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        color: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        items: List.generate(
          _icons.length,
              (index) => _buildNavItem(_icons[index], _labels[index], index == _page),
        ),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with gradient background if selected
        Container(
          padding: const EdgeInsets.all(8),
          decoration: isSelected
              ? BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1F41BB), // Top
                Color(0xFF3DBE64), // Bottom
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              )
            ],
          )
              : null,
          child: Icon(
            icon,
            size: 26,
            color: isSelected ? Colors.white : AppColors.labelBlackColor,
          ),
        ),

        // Only show label if selected
        if (isSelected)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
      ],
    );
  }
}