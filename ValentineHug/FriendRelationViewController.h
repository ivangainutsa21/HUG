//
//  FriendRelationViewController.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-08.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendRelationViewController : UIViewController
@property (strong, nonatomic) NSString*friendId;
@property (strong, nonatomic) PFUser*fr;
@end
