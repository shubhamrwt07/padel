import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static RazorpayService? _instance;
  static RazorpayService get instance => _instance ??= RazorpayService._();
  
  RazorpayService._();
  
  Razorpay? _razorpay;
  Completer<Map<String, dynamic>>? _paymentCompleter;
  
  Future<Map<String, dynamic>> processPayment({
    required String keyId,
    required double amount,
    required String name,
    required String description,
    String? userEmail,
    String? userContact,
  }) async {
    try {
      // Initialize Razorpay if not already done
      _razorpay ??= Razorpay();
      
      // Set up event listeners
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      
      // Create payment completer
      _paymentCompleter = Completer<Map<String, dynamic>>();
      
      // Minimal options to prevent crashes
      var options = {
        'key': keyId,
        'amount': (amount * 100).toInt(),
        'name': name,
        'description': description,
        'timeout': 300,
        'prefill': {
          'contact': userContact ?? '',
          'email': userEmail ?? '',
        }
      };
      
      // Open Razorpay with error handling
      await Future.delayed(Duration(milliseconds: 100));
      _razorpay!.open(options);
      
      // Wait for payment result
      return await _paymentCompleter!.future.timeout(
        Duration(minutes: 5),
        onTimeout: () => {'status': 'timeout', 'message': 'Payment timeout'},
      );
      
    } catch (e) {
      debugPrint('Razorpay Error: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }
  
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete({
        'status': 'success',
        'paymentId': response.paymentId,
        'orderId': response.orderId,
        'signature': response.signature,
      });
    }
    _cleanup();
  }
  
  void _handlePaymentError(PaymentFailureResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete({
        'status': 'failed',
        'code': response.code,
        'message': response.message,
      });
    }
    _cleanup();
  }
  
  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete({
        'status': 'external_wallet',
        'walletName': response.walletName,
      });
    }
    _cleanup();
  }
  
  void _cleanup() {
    _razorpay?.clear();
    _razorpay = null;
    _paymentCompleter = null;
  }
  
  void dispose() {
    _cleanup();
  }
}