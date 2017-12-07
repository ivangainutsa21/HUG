//
//  AppDelegate.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import "LoginController.h"
#import "WBNoticeView.h"
#import "WBErrorNoticeView.h"
#import "UIViewController+Utils.h"
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

#import "Harpy.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[Harpy sharedInstance] setAppID:@"966678342"];
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    [[Harpy sharedInstance] setDelegate:self];
    [[Harpy sharedInstance] setAppName:@"HUG"];
    [[Harpy sharedInstance] checkVersion];
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"AdiidG8HAcHrQf0Fdbsdctdtg9NeoSuWffnxxvCq";
        configuration.clientKey = @"81OVjqkYqKhbvNPhNEB0851KFAL3IJKNEyvfap17";
        configuration.server = @"https://hughug.tk/parse";
    }]];
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [PFImageView class];
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        LoginController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JONLoginViewController"];
        self.window.rootViewController = viewController;
        
    }
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - Push notification methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if ([PFUser currentUser] != nil) {
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser].objectId forKey:@"userId"];
    }
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saveInBackgroundWithBlock:%i error:%@", succeeded, error);
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {   
    NSLog(@"%@", userInfo);
   // [PFPush handlePush:userInfo];
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:[UIViewController currentViewController].view title:@"HUG" message:userInfo[@"aps"][@"alert"] image:[UIImage imageNamed:[userInfo[@"msgId"] lowercaseString]]];
    [notice show];
}

- (void)switchRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    if (animated) {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            BOOL oldState = [UIView areAnimationsEnabled];
                            self.window.rootViewController = rootViewController;
                            [UIView setAnimationsEnabled:oldState];
                        }
                        completion:^(BOOL finished) {
                            if (completion != nil) {
                                completion();
                            }
                        }];
    } else {
        self.window.rootViewController = rootViewController;
    }
}

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
