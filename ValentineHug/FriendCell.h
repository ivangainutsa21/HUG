//
//  FriendCell.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hugMoodImage;
@property (weak, nonatomic) IBOutlet UILabel *hugCount;

@end
