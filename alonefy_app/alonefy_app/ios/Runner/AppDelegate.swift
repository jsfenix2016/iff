import UIKit
import BackgroundTasks
import Flutter
//import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //   SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.transistorsoft.fetch"
//      registerBackgroundTaks()
//      registerBackgroundTask()
     
    GeneratedPluginRegistrant.register(with: self)
     
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

    //MARK: Register BackGround Tasks
    private func registerBackgroundTaks() {

        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.flutter.background.refresh", using: nil) { task in
                //This task is cast with processing request (BGProcessingTask)
                
            }
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.flutter.background.refresh", using: nil) { task in
                //This task is cast with processing request (BGAppRefreshTask)
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func registerBackgroundTask() {
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        print("iOS has signaled time has expired")
        self?.endBackgroundTaskIfActive()
      }
    }
    func endBackgroundTaskIfActive() {
      let isBackgroundTaskActive = backgroundTask != .invalid
      if isBackgroundTaskActive {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
      }
    }
   
}
