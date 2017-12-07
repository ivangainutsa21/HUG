//
//  ParseErrorHandlingController.m
//  ValentineHug
//
//  Created by softevol on 2/6/17.
//  Copyright © 2017 App Universe. All rights reserved.
//

#import "ParseErrorHandlingController.h"
#import "PFUser+logOut.h"
@implementation ParseErrorHandlingController

+ (BOOL)handleParseError:(NSError *)error {
    if (![error.domain isEqualToString:PFParseErrorDomain]) {
        return NO;
    }
    
    switch (error.code) {
        case kPFErrorFacebookInvalidSession:
        case kPFErrorUserCannotBeAlteredWithoutSession:
        case kPFErrorInvalidSessionToken: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Session"
                                                                           message:@"Session is no longer valid, please log in again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                 [PFUser logOutAndStartLogIn];
            }];
            
            [alert addAction:defaultAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                         animated:YES
                                                                                       completion:nil];
            return  YES;
        }
        case kPFErrorConnectionFailed: {
            [[[UIAlertView alloc] initWithTitle:@"Connection Failed"
                                       message:@"The connection to the HUG servers failed."
                                      delegate:nil
                             cancelButtonTitle:@"Close"
                             otherButtonTitles:nil, nil] show];
            return YES;
        }
    }
    return NO;
}

@end
