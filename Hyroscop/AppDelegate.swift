//
//  AppDelegate.swift
//  Hyroscop
//
//  Created by Mikhail Lutskiy on 01.09.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import NMAKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let kHelloMapAppID = "4BX2CK9iaJOQ2tHVu9Nq"
        let kHelloMapAppCode = "HXKFkI62tof0oyzE-7xFTA"
        let kHelloMapLicenseKey = "aebEt0JKgU3ykTQ7UzM+UVsgd76IiDTTV3nSVdphmmyjKS1vbNFGOeOKlVFmzxgna3waNglCJ4aB2sofLQgS+hDXwbI5Wq0pIxyCikj4Iednvu73UcPqqT7VzY3FjxLJwv4szRo/oxt+4Lx9a06FYXa04wFC4jjPKVSuhm/HOlHzE7JO3PFs4nHwKEBKsxxissLNi0/LUh+ymLfW7omvuY/cHBeL+rVk5tPvHmwiFVn13teM+L6E/yjBXcAKF5CsBcFSujYGBAZ5Io4RBSqu8fk/kKz8gk7f8gDwL3EOSSwE2T48KotAipIQSR9oUYnvXvndbuthEFN/GECWv0ViwYNyuCToXnewBNNyT3Z7UCuzqO4kVQ15Rdb5D+ykdUietwZOVgnyFcx8FzjqzYbM2286oLcY0toL34uJ9cGx2VBFab2KYl14OyHKZGfCe9sn/4frVJqz1UWl4XUbDViQJtQnpCmOyCE8TIkbNopOo5Bvhpz8sHOkmoZjyrbBAZdwtFAbHZKRrWMNuvBL/CzU3MKhZa0ISKahvjFZQCpVD9Lky6KtM0jae+zfgkVTt5TcudoVAWt2Okp+P7ETytV1dVGGFee5rsWq8NKQRey7zyJaehND38txXEEpfpq5d94ZmlQ3QImUpSYblIHlSyUSY3pat2Szkx+ehkfuCKm+Rfg="
        
        let error =  NMAApplicationContext.setAppId(kHelloMapAppID,
                                                    appCode: kHelloMapAppCode,
                                                    licenseKey: kHelloMapLicenseKey)
        assert(error == NMAApplicationContextError.none)
        // Override point for customization after application launch.
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            print("payload")
            print(payload)
            NotificationCenter.default.post(name: .pit, object: nil)

        }
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "d1f513fa-91c8-499f-9f3a-082362796ef8",
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
//        OneSignal.didReceiveNotificationExtensionRequest(UNNotificationRequest!, with: UNMutableNotificationContent!)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension Notification.Name {
    static let pit = Notification.Name("getPit")
}

