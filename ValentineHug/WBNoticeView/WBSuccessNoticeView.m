//
//  WBSuccessNoticeView.m
//  NoticeView
//
//  Created by Tito Ciuro on 5/25/12.
//  Copyright (c) 2012 Tito Ciuro. All rights reserved.
//

#import "WBSuccessNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBBlueGradientView.h"

@implementation WBSuccessNoticeView

+ (WBSuccessNoticeView *)successNoticeInView:(UIView *)view title:(NSString *)title
{
    WBSuccessNoticeView *notice = [[WBSuccessNoticeView alloc]initWithView:view title:title];

    notice.sticky = NO;

    return notice;
}

- (void)show
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;
    // Make and add the title label
    float titleYOrigin = 10.0;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55.0 + (self.contentInset.left), titleYOrigin + (self.contentInset.top), viewWidth - 70.0 - (self.contentInset.right+self.contentInset.left) , 16.0)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Make the message label
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(55.0 + (self.contentInset.left), 20.0 + 10.0 + (self.contentInset.top), viewWidth - 70.0 - (self.contentInset.right+self.contentInset.left), 12.0)];
    self.messageLabel.font = [UIFont systemFontOfSize:13.0];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = self.message;
    
    // Calculate the number of lines it'll take to display the text
    NSInteger numberOfLines = [[self.messageLabel lines]count];
    self.messageLabel.numberOfLines = numberOfLines;
    [self.messageLabel sizeToFit];
    CGFloat messageLabelHeight = self.messageLabel.frame.size.height;
    
    CGRect r = self.messageLabel.frame;
    r.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    
    float noticeViewHeight = 0.0;
    double currOsVersion = [[[UIDevice currentDevice]systemVersion]doubleValue];
    if (currOsVersion >= 6.0f) {
        noticeViewHeight = messageLabelHeight;
    } else {
        // Now we can determine the height of one line of text
        r.size.height = self.messageLabel.frame.size.height * numberOfLines;
        r.size.width = viewWidth - 70.0;
        self.messageLabel.frame = r;
        
        // Calculate the notice view height
        noticeViewHeight = 10.0;
        if (numberOfLines > 1) {
            noticeViewHeight += ((numberOfLines - 1) * messageLabelHeight);
        }
    }
    
    // Add some bottom margin for the notice view
    noticeViewHeight += 30.0;
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.gradientView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    [self.view addSubview:self.gradientView];
    
    // Make and add the icon view
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 30.0, 30.0)];
    iconView.image = self.image;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.alpha = 0.8;
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the message label
    [self.gradientView addSubview:self.messageLabel];
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}

@end
