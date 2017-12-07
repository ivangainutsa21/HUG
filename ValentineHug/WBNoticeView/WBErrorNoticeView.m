//
//  WBErrorNoticeView.m
//  NoticeView
//
//  Created by Tito Ciuro on 5/25/12.
//  Copyright (c) 2012 Tito Ciuro. All rights reserved.
//

#import "WBErrorNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBRedGradientView.h"

@implementation WBErrorNoticeView

+ (WBErrorNoticeView *)errorNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)message image:(UIImage *)image
{
    WBErrorNoticeView *notice = [[WBErrorNoticeView alloc]initWithView:view title:title];
    
    notice.message = message;
    notice.sticky = NO;
    notice.image = image;
    
    return notice;
}


- (void)show
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;    
    // Make and add the title label
    float titleYOrigin = 30.0;

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65.0 + (self.contentInset.left), titleYOrigin + (self.contentInset.top), viewWidth - 70.0 - (self.contentInset.right+self.contentInset.left) , 16.0)];
    self.titleLabel.textColor = [UIColor colorWithRed:0.96 green:0.46 blue:0.69 alpha:1];
    self.titleLabel.font = [UIFont fontWithName:@"FuturaStd-Bold" size:15.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.message;
    
    // Calculate the number of lines it'll take to display the text
    NSInteger numberOfLines = [[self.messageLabel lines]count];
    self.messageLabel.numberOfLines = numberOfLines;
    [self.messageLabel sizeToFit];
    
    CGRect r = self.messageLabel.frame;
    r.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    
    float noticeViewHeight = 74.0;
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.gradientView setBackgroundColor:[UIColor colorWithRed:1 green:0.98 blue:0.93 alpha:1]];
    [self.view addSubview:self.gradientView];
    
    // Make and add the icon view
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(12.0, 12.0, 50.0, 50.0)];
    iconView.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    iconView.tintColor = [UIColor colorWithRed:0.96 green:0.46 blue:0.69 alpha:1];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.alpha = 1.0;
    
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2)-15, 74, 30, 3)];
    bottomView.image = [UIImage imageNamed:@"banner-slider"];
    [self.gradientView addSubview:bottomView];
    
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the message label
    [self.gradientView addSubview:self.messageLabel];
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}

@end
