//
//  ReceiveController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-24.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "ReceiveController.h"
#import "SendOneController.h"
#import "NSDate+TimeAgo.h"

@import AVFoundation;

@interface ReceiveController()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpacing;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ReceiveController{
    NSString *startText;
    NSTimer *hugTimer;
    int i;
    int hugduration;
    PFRelation *friendsRelation;
    NSMutableArray *friends;
}

-(void)viewDidAppear:(BOOL)animated {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:UIDeviceProximityStateDidChangeNotification object:device];
}

-(void)viewWillAppear:(BOOL)animated {
    _topSpacing.constant = ([UIScreen mainScreen].bounds.size.height/5)*2;
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)isFriend:(NSString *)userId{
    for (PFUser *friend in friends)
    {
        if ([friend.objectId isEqualToString:userId])
        {
            return YES;
        }
    }
    return NO;
}

- (void) addUserWithId:(NSString*)userid {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [friendsRelation addObject:object];
        [[PFUser currentUser] saveInBackground];
        NSLog(@"%@", error);
    }];
}

-(void)viewDidLoad {

    i=0;
    _topLabel.text = [_message[@"sender"] uppercaseString];
    
    _durationLabel.text = _message[@"text"];
    
    _timeLabel.text = [self timeFormatted:[_message[@"duration"] intValue]];

    NSDate *sendDate = _message[@"datestamp"];
    NSLog(@"%@", [sendDate timeAgo]);
    
    NSString *sid = _message[@"senderId"];
    friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    
    friends = [NSMutableArray new];
    
    if (friendsRelation !=nil) {
        PFQuery *query = [friendsRelation query];
        [query orderByAscending:@"username"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);
            }
            else {
                friends = [NSMutableArray arrayWithArray:objects];
                if (![self isFriend:sid]) {
                    [self addUserWithId:sid];
                }
            }
        }];
    }
    else {
        [self addUserWithId:sid];
    }
    
    NSString *_mood = _message[@"mood"];
    
    if ([_mood isEqualToString:@"CURIOUS"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"curious_bg"];
        _moodImageView.image = [UIImage imageNamed:@"curious_1"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],
                                      [UIImage imageNamed:@"curious_1"],

                                      [UIImage imageNamed:@"curious_2"],
                                      [UIImage imageNamed:@"curious_2"],
                                      
                                      [UIImage imageNamed:@"curious_3"],
                                      [UIImage imageNamed:@"curious_3"],
                                      
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      [UIImage imageNamed:@"curious_4"],
                                      nil];
        _moodImageView.animationDuration = 3.0;
        _moodImageView.animationRepeatCount = 0;
        [_moodImageView startAnimating];
    }
    else if ([_mood isEqualToString:@"EXCITED"]){
        _backgroundImageView.image = [UIImage imageNamed:@"excited_bg"];
        _moodImageView.image = [UIImage imageNamed:@"excited_1"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          [UIImage imageNamed:@"excited_1"],
                                          
                                          [UIImage imageNamed:@"excited_2"],
                                          [UIImage imageNamed:@"excited_2"],
                                          
                                          [UIImage imageNamed:@"excited_3"],
                                          [UIImage imageNamed:@"excited_3"],
                                          
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          [UIImage imageNamed:@"excited_4"],
                                          nil];
    }
    else if ([_mood isEqualToString:@"HAPPY"]){
        _backgroundImageView.image = [UIImage imageNamed:@"happy_bg"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      [UIImage imageNamed:@"emoji_1-1s"],
                                      
                                      [UIImage imageNamed:@"emoji_2-0s"],
                                      [UIImage imageNamed:@"emoji_2-0s"],
                                      
                                      [UIImage imageNamed:@"emoji_3-0s"],
                                      [UIImage imageNamed:@"emoji_3-0s"],
                                      
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      [UIImage imageNamed:@"emoji_4-2s"],
                                      
                                      [UIImage imageNamed:@"emoji_5-0s"],
                                      [UIImage imageNamed:@"emoji_5-0s"],
                                      
                                      [UIImage imageNamed:@"emoji_6-0s"],
                                      [UIImage imageNamed:@"emoji_6-0s"],
                                      nil];

    }
    else if ([_mood isEqualToString:@"SAD"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"sad_bg"];
        _moodImageView.image = [UIImage imageNamed:@"sad_1"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          [UIImage imageNamed:@"sad_1"],
                                          
                                          [UIImage imageNamed:@"sad_2"],
                                          [UIImage imageNamed:@"sad_2"],
                                          
                                          [UIImage imageNamed:@"sad_3"],
                                          [UIImage imageNamed:@"sad_3"],
                                          
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          [UIImage imageNamed:@"sad_4"],
                                          nil];
    }
    else if ([_mood isEqualToString:@"LOVING"]){
        _backgroundImageView.image = [UIImage imageNamed:@"loving_bg"];
        _moodImageView.image = [UIImage imageNamed:@"loving"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          [UIImage imageNamed:@"loving_1"],
                                          
                                          [UIImage imageNamed:@"loving_2"],
                                          [UIImage imageNamed:@"loving_2"],
                                          
                                          [UIImage imageNamed:@"loving_3"],
                                          [UIImage imageNamed:@"loving_3"],
                                          
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          [UIImage imageNamed:@"loving_4"],
                                          nil];
    }
    else if ([_mood isEqualToString:@"PARTY"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"party_bg"];
        _moodImageView.image = [UIImage imageNamed:@"party"];
        _moodImageView.animationImages = [NSArray arrayWithObjects:
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          [UIImage imageNamed:@"party_1"],
                                          
                                          [UIImage imageNamed:@"party_2"],
                                          [UIImage imageNamed:@"party_2"],
                                          
                                          [UIImage imageNamed:@"party_3"],
                                          [UIImage imageNamed:@"party_3"],
                                          
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          [UIImage imageNamed:@"party_4"],
                                          nil];
    }
    _moodImageView.animationDuration = 3.0;
    _moodImageView.animationRepeatCount = 0;
    [_moodImageView startAnimating];
}

- (void)proximityChanged:(NSNotification *)notification {
    UIDevice *device = [notification object];
    if (device.proximityState == 1) {
        usleep(500);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        hugTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
    } else {
        [hugTimer invalidate];
        if (i==0) {
        }
        else {
            int tt = [_message[@"duration"] intValue];
            _topLabel.text = [self timeFormatted:tt-i];
            _durationLabel.text = [NSString stringWithFormat:@"REMAINING"];
        }
    }
}

- (void) count {
    int tt = [_message[@"duration"] intValue];
    i++;
    [_durationLabel setText:[self timeFormatted:tt-i]];
    _bottomLabel.text = @"Put it back to\nyour heart or skip";
    if (i==tt) {
        [hugTimer invalidate];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self performSegueWithIdentifier:@"back" sender:self];
    }
}

- (IBAction)skip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SendOneController *sc = segue.destinationViewController;
    sc.userId = _message[@"senderId"];
    sc.linkToHug = _message[@"linkToHug"];
}

@end
