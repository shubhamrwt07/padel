package com.razorpay;

import java.util.Map;

public class AnalyticsUtil {
    
    // Required field that Razorpay SDK expects
    public static String libraryType = "flutter";
    
    // Method signature that the SDK is looking for
    public static void logFunctionEntry(String str, String str2, boolean z) {
        // Empty implementation to prevent crash
    }
    
    public static void logFunctionEntry(String str, String str2) {
        // Empty implementation to prevent crash
    }
    
    public static void logFunctionExit(String str, String str2) {
        // Empty implementation to prevent crash
    }
    
    public static void trackEvent(Object event, Map<String, Object> properties) {
        // Empty implementation to prevent crash
    }
}