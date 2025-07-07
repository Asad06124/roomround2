import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // This is required to make any communication available in the action isolate.
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Set up the method channel for badge counter
        setupBadgeCounterChannel()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupBadgeCounterChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return
        }
        
        let badgeChannel = FlutterMethodChannel(
            name: "com.example.roomrounds/badge",
            binaryMessenger: controller.binaryMessenger
        )
        
        badgeChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self?.handleBadgeMethodCall(call: call, result: result)
        }
    }
    
    private func handleBadgeMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setBadgeCount":
            if let args = call.arguments as? [String: Any],
               let count = args["count"] as? Int {
                setBadgeCount(count: count)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid badge count", details: nil))
            }
            
        case "getBadgeCount":
            let currentBadge = getBadgeCount()
            result(currentBadge)
            
        case "incrementBadgeCount":
            let currentBadge = getBadgeCount()
            setBadgeCount(count: currentBadge + 1)
            result(nil)
            
        case "resetBadgeCount":
            setBadgeCount(count: 0)
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func setBadgeCount(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
            print("[iOS Badge] Badge count set to: \(count)")
        }
    }
    
    private func getBadgeCount() -> Int {
        return UIApplication.shared.applicationIconBadgeNumber
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
    
    // Handle notifications when app is in foreground
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    // Handle notification tap
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Reset badge when notification is tapped
        setBadgeCount(count: 0)
        completionHandler()
    }
    
    // Handle app becoming active (foreground)
    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)
        
        // Optionally sync badge count with your Flutter app state
        // This ensures consistency between iOS badge and app's internal count
        syncBadgeWithFlutter()
    }
    
    private func syncBadgeWithFlutter() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return
        }
        
        let badgeChannel = FlutterMethodChannel(
            name: "com.example.roomrounds/badge",
            binaryMessenger: controller.binaryMessenger
        )
        
        // Always reset iOS badge count to 0 on resume
        setBadgeCount(count: 0)
        
        // Inform Flutter about the reset badge count
        badgeChannel.invokeMethod("syncBadgeCount", arguments: ["count": 0])
    }
}