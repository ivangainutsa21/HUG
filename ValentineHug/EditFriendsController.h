//
//  EditFriendsController.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-24.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface EditFriendsController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

- (BOOL) isFriend:(PFUser *)user;
@end
