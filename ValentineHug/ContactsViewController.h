//
//  ContactsViewController.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-29.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *friends;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end
