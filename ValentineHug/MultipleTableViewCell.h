//
//  MultipleTableViewCell.h
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-08.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
