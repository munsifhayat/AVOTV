//
//  AppDelegate.swift
//  AVO TV
//
//  Created by Zeeshan Tariq on 10/06/2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
//import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor  = UIColor(named: "primary_gold")!
        
        UITextField.appearance().tintColor = UIColor(named: "primary_gold")!
 
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()

        let controller = SplashViewController()
        let navigationController = BaseNavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        
//        if AppStateManager.shared.isUserLoggedIn{
//            loadHomeController()
//        }
//        else{
//            loadLogInController()
//        }
//
       
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

//            UIApplication.shared.applicationIconBadgeNumber = 0
//        }

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//        UIApplication.shared.applicationIconBadgeNumber = 0

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func loadLogInController() {
        let controller = LogInViewController()
        let navigationController = BaseNavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
    }
    
    func loadHomeController() {
        
        if let revealViewController = self.window?.rootViewController as? SWRevealViewController {
            if let navController = revealViewController.frontViewController as? UINavigationController {
                if let vc = navController.topViewController as? LiveTVViewController {
                    vc.videoPlayer.removeFromSuperview()
                }
            }
        }

        let controller = LiveTVViewController(nibName: "LiveTVViewController", bundle: nil)
        let homeNavigationController = BaseNavigationController(rootViewController: controller)
        
        let sideController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        
        let frontViewController = homeNavigationController
        let rearViewController  = sideController
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController);
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut;
        swRevealVC?.toggleAnimationDuration = 0.30;
        
        //set swRevealVC as rootVC of windows
        self.window?.rootViewController = swRevealVC!;
        
        self.window?.makeKeyAndVisible()
    }
    
    
    func changeRootController(_ controller:UIViewController) {
        
        let navController = BaseNavigationController(rootViewController: controller)

        let sideController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        
        let frontViewController = navController
        let rearViewController  = sideController
        
        //create instance of swRevealVC based on front and rear VC
        let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontViewController);
        swRevealVC?.toggleAnimationType = SWRevealToggleAnimationType.easeOut;
        swRevealVC?.toggleAnimationDuration = 0.30;
        
        //set swRevealVC as rootVC of windows
        self.window?.rootViewController = swRevealVC!;
        
        self.window?.makeKeyAndVisible()
    }
    
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func handleRecievedPush() {
        NotificationCenter.default.post(name: Notification.Name("refresh_Data"), object: nil)
    }
    
    // Receive displayed notifications for iOS 10 devices in foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message IDEEEEE: \(messageID)")
        }
        print(userInfo)

//        if let page = userInfo[AnyHashable("page")] as? NSString {
//
//            if page != "VIEW_CHAT" {
//                NotificationCenter.default.post(name: Notification.Name("refresh_Chat"), object: nil)
//            }
//
//            if page == "NEW_TASK" {
//                handleRecievedPush()
//                completionHandler([])
//            }
//        }
        completionHandler([.alert, .sound, .badge])
    }
    
    
    // Tap on Notification When App in Background/Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message IDFFFFFFF: \(messageID)")
        }

        print(userInfo)
        
//        if let pid = userInfo[AnyHashable("pid")] as? NSString, let page = userInfo[AnyHashable("page")] as? NSString
//        {
//
//            loadHomeController()
//            let revealViewController = window?.rootViewController as? SWRevealViewController
//            let tabController = revealViewController?.frontViewController as? TabBarController
//
//            if page == "VIEW_CHAT"{
//                if let withId = userInfo[AnyHashable("withId")] as? NSString{
//                    if let navController = tabController?.selectedViewController as? UINavigationController {
//                        let controller = ChatViewController()
//                        controller.task_id = pid as String
//                        controller.for_user_id = withId as String
//                        controller.hidesBottomBarWhenPushed = true
//                        navController.pushViewController(controller, animated: true)
//                    }
//                }
//            }
//            else if page  == "VIEW_NOTIFICATIONS"{
//                if let navController = tabController?.selectedViewController as? UINavigationController {
//                    let controller = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
//                    navController.pushViewController(controller, animated: true)
//                }
//            }
//            else{
//
//                if let status = userInfo[AnyHashable("status")] as? NSString{
//
//                    switch status {
//
//                    case "0":
//                        if let navController = tabController?.selectedViewController as? UINavigationController {
//                            let controller = TaskDetailsViewController(nibName: "TaskDetailsViewController", bundle: nil)
//                            controller.task_id = pid as String
//                            navController.pushViewController(controller, animated: true)
//                        }
//                        break
//
//                    case "1":
//                        if let navController = tabController?.selectedViewController as? UINavigationController {
//                            let controller = TaskDetailsViewController(nibName: "TaskDetailsViewController", bundle: nil)
//                            controller.isCompletedTask = true
//                            controller.task_id = pid as String
//                            navController.pushViewController(controller, animated: true)
//                        }
//                        break
//
//                    case "2":
//                        if let navController = tabController?.selectedViewController as? UINavigationController {
//                            //let controller = AddTaskViewController()
//                            //controller.forwardTask_id = pid as String
//                            let controller = DraftsViewController(nibName: "DraftsViewController", bundle: nil)
//                            controller.isForwardedTasks = true
//                            navController.pushViewController(controller, animated: true)
//                        }
//                        break
//
//                    case "4":
//                        if let navController = tabController?.selectedViewController as? UINavigationController {
//                            let controller = AddTaskViewController()
//                            controller.draftTask_id = pid as String
//                            navController.pushViewController(controller, animated: true)
//                        }
//                        break
//
//                    default:
//                        break
//                    }
//                }
//            }
//        }
        
        completionHandler()
    }
    
}
// [END ios_10_message_handling]


extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        
        AppStateManager.shared.fcmToken = fcmToken ?? ""
        
    }
    
}

