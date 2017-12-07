//
//  AppDelegate.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)switchRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated completion:(dispatch_block_t)completion;
+ (AppDelegate *)sharedDelegate;
@end

