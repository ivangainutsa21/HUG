//
//  SelectFriendCell.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-29.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *friendSelectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendInitialLabel;

@end
