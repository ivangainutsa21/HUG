//
//  ViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "ViewController.h"
#import "FriendCell.h"
#import "SendController.h"
#import "EditFriendsController.h"
#import "ReceiveController.h"
#import <Parse/Parse.h>
#import "MONActivityIndicatorView.h"
#import "MultipleViewController.h"
#import "FriendRelationViewController.h"
#import "AFNetworking.h"
#import "ParseErrorHandlingController.h"

@interface ViewController ()<MONActivityIndicatorViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendsBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstHugLabel;
@end

@implementation ViewController {
    NSTimer *timer;
    MONActivityIndicatorView *indicatorView;
    NSMutableDictionary *myhugs;
    NSMutableArray *sortedhugs;
    BOOL hasFriends;
    BOOL hasHugs;
    NSMutableDictionary *selectedHug;
    PFRelation *friendsRelation;
}

- (void)viewDidLoad {

    hasHugs = NO;
    hasFriends = YES;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if ([PFUser currentUser] != nil) {
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser].objectId forKey:@"userId"];
    }
    [currentInstallation saveInBackground];
    self.hugs = [NSMutableArray new];
    
        indicatorView = [[MONActivityIndicatorView alloc] init];
        indicatorView.delegate = self;
        indicatorView.numberOfCircles = 3;
        indicatorView.radius = 20;
        indicatorView.internalSpacing = 3;
        indicatorView.duration = 0.5;
        indicatorView.delay = 0.5;
        indicatorView.center = self.view.center;
        [self.view addSubview:indicatorView];
        [indicatorView startAnimating];
        self.tableView.alpha = 0.0;

    myhugs = [NSMutableDictionary new];
    [self setObjects];
    
    PFQuery *pushQuery = [PFInstallation query];
    friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
//    PFPush *push = [[PFPush alloc] init];
//    [push setMessage:@"ERROR, HUGS DISABLED"];
//    [push sendPushInBackground];
    
    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    PFQuery *query = [friendsRelation query];
    if (query !=nil) {
        [query orderByAscending:@"username"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [indicatorView stopAnimating];
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);
                _inviteLabel.hidden = NO;
            }
            else {
                if (objects.count != 0) {                    self.friends = [NSMutableArray arrayWithArray:objects];
                }
            }
        }];
    }
}

- (void) setObjects {
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    PFQuery *query = relation.query;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [indicatorView stopAnimating];
        if (objects.count != 0) {
            hasFriends = YES;
            _addFriendsBtn.hidden = YES;
            self.tableView.hidden = YES;
            _recentLabel.hidden = NO;
        }
        else {
                hasFriends = NO;
                _addFriendsBtn.hidden = NO;
                self.tableView.hidden = NO;
                _recentLabel.hidden = YES;
            
        }
        
        if ([PFUser currentUser][@"HUGS"] != nil) {
                _firstHugLabel.hidden = YES;
                _addFriendsBtn.hidden = YES;
                _recentLabel.hidden = NO;
                self.tableView.hidden = NO;
        }
        else {
            if (objects.count != 0) {
                _firstHugLabel.hidden = NO;
                self.tableView.hidden = YES;
                _recentLabel.hidden = YES;
            }
            else {
                _firstHugLabel.hidden = YES;
            }
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [self retreiveHugs];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(retreiveHugs) userInfo:nil repeats:YES];
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:NO];
    [self setObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortedhugs.count >= 20? 20 : sortedhugs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *senderName = sortedhugs[indexPath.row][@"name"];
    cell.friendLabel.text = [senderName uppercaseString];
    int hugCount = 0;
    
    NSMutableArray *hugs = sortedhugs[indexPath.row][@"hugs"];
    for (int i=0; i<hugs.count; i++) {
        if ([hugs[i] objectForKey:@"shown"] != nil) {
            
        }else{
            hugCount++;
        }
    }
    
    if (hugCount == 0) {
        cell.hugMoodImage.image = nil;
        cell.hugCount.text = @"";
    }
    else if(hugCount == 1){
        NSDictionary *hug = sortedhugs[indexPath.row][@"hugs"][0];
        cell.hugCount.text = @"";
        if ([hug[@"mood"] isEqualToString:@"CURIOUS"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"curious_btn"];
        }
        if ([hug[@"mood"] isEqualToString:@"EXCITED"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"excited_btn"];
        }
        if ([hug[@"mood"] isEqualToString:@"HAPPY"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"happy_btn"];
        }
        if ([hug[@"mood"] isEqualToString:@"SAD"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"sad_btn"];
        }
        if ([hug[@"mood"] isEqualToString:@"LOVING"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"loving_btn"];
        }
        if ([hug[@"mood"] isEqualToString:@"PARTY"]) {
            cell.hugMoodImage.image = [UIImage imageNamed:@"party_btn"];
        }
    }
    else if(hugCount == 2 || hugCount == 3){
        cell.hugCount.text = [NSString stringWithFormat:@"%d", hugCount];
        cell.hugMoodImage.image = [UIImage imageNamed:@"bg"];
    }
    else {
        cell.hugMoodImage.image = [UIImage imageNamed:@"several"];
        cell.hugCount.text = @"";
    }
    PFUser *user;
    user = self.friends[indexPath.row];
    if (user[@"emailVerified"] != nil &&  [[user valueForKey:@"emailVerified"] boolValue] == YES)
    {
        
        cell.hugMoodImage.image = [UIImage imageNamed:@"email_verified_mainscreen"];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = (FriendCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.friendLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.friendLabel.alpha = 1.0f;
    }];
    
    NSMutableArray *fHugs = sortedhugs[indexPath.row][@"hugs"];
    NSMutableArray *senderHugs = [NSMutableArray new];
    for (int i=0; i<fHugs.count; i++) {
        if (fHugs[i][@"shown"]!=nil) {
            
        }
        else {
            selectedHug = fHugs[i];
            [senderHugs addObject:fHugs[i]];
        }
    }
    
    if ([senderHugs count]>0) {
        if (senderHugs.count == 1) {
            [self performSegueWithIdentifier:@"receive" sender:self];
            PFQuery *query = [PFQuery queryWithClassName:@"Hugs"];
            [query whereKey:@"objectId" equalTo:senderHugs[0][@"hugid"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        [object setObject:@(1) forKey:@"shown"];
                        [object saveInBackground];
                    }
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else {
            [self performSegueWithIdentifier:@"several" sender:self];
        }
    }
    else {
        [self performSegueWithIdentifier:@"friends" sender:self];
    }
}
- (IBAction)hug:(id)sender {
    if (!hasFriends)
    {
        [self performSegueWithIdentifier:@"addFriends" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"hug" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"send"]) {

    }
    else if([segue.identifier isEqualToString:@"edit"]) {

    }
    else if([segue.identifier isEqualToString:@"receive"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ReceiveController *rc = (ReceiveController *)navigationController.topViewController;
        rc.message = selectedHug;
    }
    else if([segue.identifier isEqualToString:@"friends"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        FriendRelationViewController *fc = (FriendRelationViewController *)navigationController.topViewController;
        fc.friendId = sortedhugs[indexPath.row][@"hugs"][0][@"senderId"];
    }
    else if([segue.identifier isEqualToString:@"several"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        MultipleViewController *mc = (MultipleViewController*)navigationController.topViewController;
        NSMutableArray *hugs = sortedhugs[indexPath.row][@"hugs"];
        NSMutableArray *notshown = [NSMutableArray new];
        for (int i=0; i<hugs.count; i++) {
            if ([hugs[i] objectForKey:@"shown"] != nil) {
            }else{
                [notshown addObject:hugs[i]];
            }
        }
        mc.hugs = notshown;
        mc.sender = sortedhugs[indexPath.row][@"name"];
    }
}

- (void)addHug:(NSString*)duration andMood:(NSString*)mood andText:(NSString*)text andShown:(NSNumber*)shown andHugid:(NSString*)hugid andSenderId:(NSString*)sender andDate:(NSDate *)date forUserName:(NSString*)username{
    NSDictionary *items;
    if (shown != nil) {
        items = @{@"duration":duration, @"mood":mood, @"text":text, @"sender":username, @"shown":shown, @"hugid":hugid, @"senderId":sender, @"datestamp":date};
    }
    else {
        items = @{@"duration":duration, @"mood":mood, @"text":text, @"sender":username, @"hugid":hugid, @"senderId":sender, @"datestamp":date};
    }
    if ([myhugs objectForKey:username] != nil) {
        NSMutableArray *stuff = [myhugs objectForKey:username];
        [stuff addObject:items];
        [myhugs setObject:stuff forKey:username];
    }
    else {
        NSMutableArray *stuff = [NSMutableArray new];
        [stuff addObject:items];
        [myhugs setObject:stuff forKey:username];
    }
}

- (void)retreiveHugs {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"run"] != nil) {
        
    }
    else {
        [self.hugs removeAllObjects];
        PFQuery *query = [PFQuery queryWithClassName:@"Hugs"];
        [query whereKey:@"recipiantIds" equalTo:[[PFUser currentUser] objectId]];
        [query orderByDescending:@"createdAt"];
       // [query addAscendingOrder:@"senderName"];
        [[query copy] countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
            NSLog(@"Count:%i", number);
        }];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count>0) {
                _addFriendsBtn.hidden = YES;
                _recentLabel.hidden = NO;
                _tableView.hidden = NO;
                _firstHugLabel.hidden = YES;
                hasFriends = YES;
            }
            [indicatorView stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                self.tableView.alpha = 1.0;
            }];
            self.hugs = [NSMutableArray arrayWithArray:objects];
            
            if (error) {
                if (![ParseErrorHandlingController handleParseError:error]) {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [[[UIAlertView alloc] initWithTitle:@"Could not fetch hugs" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                }
            }
            else {
                [myhugs removeAllObjects];
                
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"senderName" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
                NSArray *sortedArray = [objects sortedArrayUsingDescriptors:sortDescriptors];
                
                int hugcount = 0;
                for (PFObject *hug in sortedArray) {
                    NSString *text = [[NSString alloc] init];
                    if (hug[@"text"] == nil) {
                        text = @"";
                    } else {
                        text = hug[@"text"];
                    }
                    
                    [self addHug:hug[@"duration"] andMood:hug[@"mood"] andText:text andShown:hug[@"shown"] andHugid:hug.objectId andSenderId:hug[@"senderId"] andDate:hug.createdAt forUserName:hug[@"senderName"]];
                    if (hug[@"shown"] != nil) {
                    }
                    else {
                        hugcount++;
                    }
                }
                
                NSArray *sortedKeys = [myhugs allKeys];
                sortedhugs = [NSMutableArray new];
                for (NSString *key in sortedKeys){
                    [sortedhugs addObject:@{@"name":key,@"hugs": [myhugs objectForKey: key]}];
                }
                [sortedhugs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    id val1 = [[[obj1 objectForKey:@"hugs"] objectAtIndex:0] objectForKey:@"datestamp"];
                    id val2 = [[[obj2 objectForKey:@"hugs"] objectAtIndex:0] objectForKey:@"datestamp"];
                    NSLog(@"Val1:%@", val1);
                    return [val2 compare:val1];
                    
                }];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                currentInstallation.badge = hugcount;
                [currentInstallation saveEventually];
                
                [self.tableView reloadData];
            }
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate];
}

#pragma mark - Gradients and Color

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    NSArray *colors;
    
    if (scrollView.contentOffset.y + scrollView.contentInset.top <= 0) {
        colors = @[(__bridge id)innerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height
               >= scrollView.contentSize.height) {
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)innerColor];
    } else {
        colors = @[(__bridge id)outerColor, (__bridge id)innerColor,
                   (__bridge id)innerColor, (__bridge id)outerColor];
    }
    ((CAGradientLayer *)scrollView.layer.mask).colors = colors;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.tableView.layer.mask) {
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        
        maskLayer.locations = @[[NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.2],
                                [NSNumber numberWithFloat:0.8],
                                [NSNumber numberWithFloat:1.0]];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.tableView.frame.size.width,
                                      self.tableView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.tableView.layer.mask = maskLayer;
    }
    [self scrollViewDidScroll:self.tableView];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

@end
