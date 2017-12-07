//
//  ViewController.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *hugs;
@property (nonatomic, strong) NSMutableArray *friends;
@end

