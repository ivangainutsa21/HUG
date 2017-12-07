//
//  SendSelectController.h
//  ValentineHug
//
//  Created by Prinz & Co on 2015-01-29.
//  Copyright (c) 2015 Prinz & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendSelectController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int hugDuration;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *linkToHug;
@property (strong, nonatomic) NSString *mood_text;

@end
