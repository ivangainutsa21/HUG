//
//  MultipleViewController.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-08.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *hugs;
@property (strong, nonatomic) NSString *sender;
@end
