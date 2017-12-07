//
//  PFUser+logOut.h
//  ValentineHug
//
//  Created by softevol on 2/6/17.
//  Copyright © 2017 App Universe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PFUser(logOut)
+ (void)logOutAndStartLogIn;
@end
