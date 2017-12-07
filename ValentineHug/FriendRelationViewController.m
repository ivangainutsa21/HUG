//
//  FriendRelationViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-08.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "FriendRelationViewController.h"
#import <Parse/Parse.h>
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "MONActivityIndicatorView.h"
#import "SendOneController.h"

@interface FriendRelationViewController ()<MONActivityIndicatorViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *hugLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hugDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *excitedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *happyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lovingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonelyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *curiousCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *hugBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation FriendRelationViewController {
    PFRelation *friendsRelation;
    PFObject *currentFriend;
    MONActivityIndicatorView *indicatorView;
    NSMutableArray *friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 3;
    indicatorView.radius = 20;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.5;
    indicatorView.delay = 0.5;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];

    if (_fr !=nil) {
        currentFriend = _fr;
        [self setItemsWithFriend:_fr];
    }
    else {
        [indicatorView startAnimating];
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" containsString:_friendId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error == nil) {
                [self setItemsWithFriend:(PFUser*)object];
            }
            else {
                NSLog(@"%@", error);
            }
            [indicatorView stopAnimating];
        }];
    }
}

-(BOOL)isFriend:(PFUser *)user{
    for (PFUser *friend in friends)
    {
        if ([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
    return NO;
}

- (void) setItemsWithFriend:(PFUser *)object {
    currentFriend = object;
    
    
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            friends = [NSMutableArray arrayWithArray:objects];
            if([self isFriend:(PFUser*)currentFriend]){
                //SHOW DELETE BUTTON AND HUG
                _deleteBtn.hidden = NO;
            }
            else {
                //HIDE DELETE AND SHOW ADD AND HUG
            }
        }
    }];
    
    
    
    _hugBtn.hidden = NO;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", object[@"name"], object[@"surname"]];
    _usernameLabel.text = object[@"username"];
    //_hugDescriptionLabel.text = [NSString stringWithFormat:@"%@'S HUGS",object[@"name"]];
    
    _userImage.layer.cornerRadius = _userImage.bounds.size.width/2;
    _userImage.clipsToBounds = YES;
    if (object[@"facebookId"] != nil) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            NSString *imgUrlStr = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture/?type=square&type=large", object[@"facebookId"]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]];
            UIImage *image = [[UIImage alloc] initWithData:data];
            NSLog(@"Image:%@", image);
            dispatch_async(dispatch_get_main_queue(), ^{
                _userImage.image = image;
                _userImage.alpha = 0.0;
                [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _userImage.alpha = 1.0;
                                 } completion:nil];
            });
        });
    }
    else {
        PFFile *thumbnail = [object objectForKey:@"image"];
        if (thumbnail != nil) {
            [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *uimage = [UIImage imageWithData:data];
                [_userImage setImage:uimage];
            }];
        }
    }
    if (object[@"DURATION"] != nil) {
        _timeLabel.text = [self timeFormatted:[object[@"DURATION"] intValue]];
    }
    else {
        _timeLabel.text = @"00:00";
    }
    
    if (object[@"EXCITED"] != nil) {
        _excitedCountLabel.text = [NSString stringWithFormat:@"%@", object[@"EXCITED"]];
    }
    
    if (object[@"HAPPY"] != nil) {
        _happyCountLabel.text = [NSString stringWithFormat:@"%@", object[@"HAPPY"]];
    }
    
    if (object[@"LOVING"] != nil) {
        _lovingCountLabel.text = [NSString stringWithFormat:@"%@", object[@"LOVING"]];
    }
    
    if (object[@"SAD"] != nil) {
        _lonelyCountLabel.text = [NSString stringWithFormat:@"%@", object[@"SAD"]];
    }
    
    if (object[@"CURIOUS"] != nil) {
        _curiousCountLabel.text = [NSString stringWithFormat:@"%@", object[@"CURIOUS"]];
    }
    
    if (object[@"PARTY"] != nil) {
        _partyCountLabel.text = [NSString stringWithFormat:@"%@", object[@"PARTY"]];
    }
    
    if (object[@"HUGS"] != nil) {
        _hugLabel.text = [NSString stringWithFormat:@"%@", object[@"HUGS"]];
    }
    else {
        _hugLabel.text = @"0";
    }
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //YES
        [friendsRelation removeObject:currentFriend];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}
- (IBAction)sendHug:(id)sender {
    if (![self isFriend:(PFUser*)currentFriend]) {
        [friendsRelation addObject:currentFriend];
        [[PFUser currentUser] saveInBackground];
    }
    [self performSegueWithIdentifier:@"sendhug" sender:self];
}

- (IBAction)removeFriend:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you really want to delete this friend?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles: nil];
    [actionSheet showInView:self.view];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SendOneController *sc = segue.destinationViewController;
    if (_fr!=nil) {
        sc.userId = _fr.objectId;
    }
    else {
        sc.userId = currentFriend.objectId;
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
