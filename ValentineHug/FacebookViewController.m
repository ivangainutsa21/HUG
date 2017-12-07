//
//  FacebookViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-03.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "FacebookViewController.h"
#import "SelectFriendCell.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MONActivityIndicatorView.h"

@interface FacebookViewController ()<MONActivityIndicatorViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *syncSwitch;
@property (strong, nonatomic) NSMutableArray *friends;
@end

@implementation FacebookViewController {
    NSArray* fbFriends;
    PFRelation *friendsRelation;
    MONActivityIndicatorView *indicatorView;
    BOOL hasSentPush;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasSentPush = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.friends = [NSMutableArray new];
    
    friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = [NSMutableArray arrayWithArray:objects];
        }
    }];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"fbsync"] != NULL) {
        _syncSwitch.on = YES;
    }
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }

            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];

            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [indicatorView stopAnimating];
                fbFriends = objects;
                [self.tableView reloadData];
            }];
        }
    }];
    
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
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fbFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFUser *user = fbFriends[indexPath.row];
    
    cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    cell.friendUserLabel.text = [user.username uppercaseString];
    cell.friendImageView.backgroundColor = [UIColor whiteColor];
    cell.friendImageView.layer.cornerRadius = cell.friendImageView.bounds.size.width/2;
    cell.friendInitialLabel.text = [[user.username substringToIndex:2] uppercaseString];

    if ([self isFriend:user]) {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"contact-added"];
    }
    else {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"add-contact"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = fbFriends[indexPath.row];

    if ([self isFriend:user]) {
        [self.friends removeObject:user];
        [friendsRelation removeObject:user];
    }
    else {
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        NSLog(@"%@", friendsRelation);
        if (!hasSentPush) {
            [self sendPushToUser:user];
            hasSentPush = YES;
        }
    }
    [[PFUser currentUser] saveInBackground];
    [self.tableView reloadData];
}

- (IBAction)toggleChanged:(id)sender {
    UISwitch *sw = sender;
    if (sw.isOn) {
        NSLog(@"TURNED ON");
        //TODO ADD ALL FRIENDS
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"fbsync"];
        [self addAll];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:NULL forKey:@"fbsync"];
    }
}

- (void)sendPushToUser:(PFUser *)user {
    NSString *msg = [NSString stringWithFormat:@"%@ just added you!", [[PFUser currentUser] objectForKey:@"name"]];
    NSDictionary *params = @{@"alert": msg,
                           @"badge": @"Increment",
                           @"msgId": @"123",
                          @"userId": user.objectId};
    [PFCloud callFunctionInBackground:@"iosPushHugFriendNotification" withParameters:params
                                block:^(id  _Nullable object, NSError * _Nullable error) {
                                    NSLog(@"Error:%@", error);
                                }];
}

- (void)addAll {
    for (PFUser *user in fbFriends) {
        if (![self isFriend:user]) {
            [self.friends addObject:user];
            [friendsRelation addObject:user];
            if (!hasSentPush) {
                [self sendPushToUser:user];
                hasSentPush = YES;
            }
        }
    }
    [self.tableView reloadData];
    [[PFUser currentUser] saveInBackground];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isFriend:(PFUser *)user{
    for (PFUser *friend in self.friends)
    {
        if ([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
    return NO;
}

@end
