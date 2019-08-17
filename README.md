# FirebasePushNotification
Follow below steps for the setup push notifications.

1) Open firebase console and create new project. https://console.firebase.google.com
2) Setup your project in Setting and upload .p12 certificate in cloud messaging sections.
3) Add PushNotification.swift file into your project.
4) Write below code into your appdelegate method.

         func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        PushNotification.setupForPushNotiFication(application: application) { (isGranted) in
            print(isGranted)
        }
        return true
    }
    
    
5) Run your project in ios Device and allow push notification service. 
6) Send Push notification from firebase console.


Stay connected with us for get custom classes for the ios Development.

Thanks
