import 'package:flutter/material.dart';
class QuestionsBottomsheetScreen extends StatelessWidget {
  final String totalAmount;
  final int totalSlots;
  final String walletBalance;
  final VoidCallback onWalletTap;
  final VoidCallback onDirectPaymentTap;

  const QuestionsBottomsheetScreen({
    super.key,
    required this.totalAmount,
    required this.totalSlots,
    required this.walletBalance,
    required this.onWalletTap,
    required this.onDirectPaymentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------- FORM ----------
        _buildDropdown('Select game level'),
        const SizedBox(height: 16),
        _buildDropdown('Select game type'),
        const SizedBox(height: 16),
        _buildDropdown('Select match type'),

        const Spacer(),

        // ---------- PAYMENT PANEL ----------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1F3C88), Color(0xFF2E5BFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Up arrow
              Container(
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 16),

              // Total row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total to Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Total Slots: $totalSlots',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹ $totalAmount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Wallet
              _paymentTile(
                title: 'Wallet',
                subtitle: 'Current Balance: $walletBalance',
                trailingColor: Colors.blue,
                onTap: onWalletTap,
              ),

              const SizedBox(height: 12),

              // Direct Payment
              _paymentTile(
                title: 'Direct Payment',
                titleColor: const Color(0xFF6FCF97),
                trailingColor: const Color(0xFF6FCF97),
                onTap: onDirectPaymentTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- DROPDOWN ----------
  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2E5BFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: const Text('Select'),
              isExpanded: true,
              items: const [],
              onChanged: null,
            ),
          ),
        ),
      ],
    );
  }

  // ---------- PAYMENT TILE ----------
  Widget _paymentTile({
    required String title,
    String? subtitle,
    Color titleColor = Colors.black,
    required Color trailingColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: trailingColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
