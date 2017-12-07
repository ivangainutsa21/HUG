//
//  PFUser+logOut.m
//  ValentineHug
//
//  Created by softevol on 2/6/17.
//  Copyright © 2017 App Universe. All rights reserved.
//

#import "PFUser+logOut.h"
#import "AppDelegate.h"

@implementation PFUser(logOut)

+ (void)logOutAndStartLogIn {
    [self logOut];
    [[PFInstallation currentInstallation] removeObjectForKey:@"userId"];
    [[PFInstallation currentInstallation] saveInBackground];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"JONLoginViewController"];
    
    [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
}

@end
