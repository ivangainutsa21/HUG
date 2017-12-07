//
//  SendSelectController.m
//  ValentineHug
//
//  Created by Prinz & Co on 2015-01-29.
//  Copyright (c) 2015 Prinz & Co. All rights reserved.
//

#import "SendSelectController.h"
#import <Parse/Parse.h>
#import "SelectFriendCell.h"
#import "MONActivityIndicatorView.h"

@interface SendSelectController ()<MONActivityIndicatorViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *isAllSelectedImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *hugBtn;
@property (weak, nonatomic) IBOutlet UILabel *hugTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation SendSelectController {
    PFRelation *friendsRelation;
    NSArray *items;
    NSMutableArray *selected;
    NSMutableArray *selectedIds;
    UIColor *fontColor;
    MONActivityIndicatorView *indicatorView;
    bool isSelectedAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hugBtn.alpha = 1.0;
    // Do any additional setup after loading the view.
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
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
    
    friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            items = objects;
            [self.tableView reloadData];
        }
        [indicatorView stopAnimating];
    }];
    
    
    
    fontColor = [UIColor whiteColor];
    
    if ([_mood isEqualToString:@"CURIOUS"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"curious_bg"];
        _moodImageView.image = [UIImage imageNamed:@"curious"];
        fontColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1];
    }
    else if ([_mood isEqualToString:@"EXCITED"]){
        _backgroundImageView.image = [UIImage imageNamed:@"excited_bg"];
        _moodImageView.image = [UIImage imageNamed:@"excited"];
        fontColor = [UIColor colorWithRed:0.99 green:0.84 blue:0.46 alpha:1];
    }
    else if ([_mood isEqualToString:@"HAPPY"]){
        _backgroundImageView.image = [UIImage imageNamed:@"happy_bg"];
        _moodImageView.image = [UIImage imageNamed:@"happy"];
        fontColor = [UIColor colorWithRed:0.99 green:0.76 blue:0.49 alpha:1];
    }
    else if ([_mood isEqualToString:@"SAD"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"sad_bg"];
        _moodImageView.image = [UIImage imageNamed:@"sad"];
        fontColor = [UIColor colorWithRed:0.35 green:0.31 blue:0.62 alpha:1];
    }
    else if ([_mood isEqualToString:@"LOVING"]){
        _backgroundImageView.image = [UIImage imageNamed:@"loving_bg"];
        _moodImageView.image = [UIImage imageNamed:@"loving"];
        fontColor = [UIColor colorWithRed:0.99 green:0.54 blue:0.6 alpha:1];
    }
    else if ([_mood isEqualToString:@"PARTY"]) {
        _backgroundImageView.image = [UIImage imageNamed:@"party_bg"];
        _moodImageView.image = [UIImage imageNamed:@"party"];
        fontColor = [UIColor colorWithRed:0.71 green:0.87 blue:0.51 alpha:1];
    }
    
    _hugTimeLabel.text = [self timeFormatted:_hugDuration];
    
    selected = [NSMutableArray new];
    selectedIds = [NSMutableArray new];
    isSelectedAll = false;
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

-(void)viewDidAppear:(BOOL)animated {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFUser *user = items[indexPath.row];
    
    cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    cell.friendUserLabel.text = [user.username uppercaseString];
    if (user[@"emailVerified"] != nil &&  [[user valueForKey:@"emailVerified"] boolValue] == YES){
        
        cell.friendImageView.image = [UIImage imageNamed:@"email_verified_icon"];
        [cell.friendInitialLabel setHidden:YES];
        
    } else {
        [cell.friendInitialLabel setHidden:NO];
        cell.friendImageView.backgroundColor = [UIColor whiteColor];
    }
    cell.friendImageView.layer.cornerRadius = cell.friendImageView.bounds.size.width/2;
    cell.friendInitialLabel.text = [[user.username substringToIndex:2] uppercaseString];
    [cell.friendInitialLabel setTextColor:fontColor];
    
    if ([selected containsObject:user]) {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"friend_selected"];
    }
    else {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"friend_unselected"];
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = items[indexPath.row];
    if ([selected containsObject:user]) {
        [selected removeObject:user];
        [selectedIds removeObject:user.objectId];
    }
    else {
        [selected addObject:user];
        [selectedIds addObject:user.objectId];
    }
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)sendHugs:(id)sender {
    if (selectedIds.count > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            _hugBtn.alpha = 0.0;
        }];
        
        [indicatorView startAnimating];
        
        NSString *msg = [NSString stringWithFormat:@"HUG from %@!", [[PFUser currentUser] objectForKey:@"name"]];
        NSDictionary *data = @{@"alert": msg,
                               @"badge": @"Increment",
                               @"msgId": _mood };
        
        PFQuery *query = [PFInstallation query];
        [query whereKey:@"userId" containedIn:selectedIds];
        
        NSMutableDictionary *parametrs = [data mutableCopy];
        [parametrs setObject:selectedIds forKey:@"userIds"];
        
        PFObject *total = [PFObject objectWithClassName:@"Total"];
        [total setObject:@(_hugDuration) forKey:@"duration"];
        [total setObject:[PFUser currentUser] forKey:@"senderId"];
        [total saveInBackground];
        
        PFObject *message = [PFObject objectWithClassName:@"Hugs"];
        [message setObject:selectedIds forKey:@"recipiantIds"];
        [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
        
        if (![[[PFUser currentUser] objectForKey:@"name"] isEqualToString:@""] && [[PFUser currentUser] objectForKey:@"name"] != nil && ![[[PFUser currentUser] objectForKey:@"surname"] isEqualToString:@""] && [[PFUser currentUser] objectForKey:@"surname"] != nil) {
            [message setObject:[NSString stringWithFormat:@"%@ %@",[[PFUser currentUser] objectForKey:@"name"], [[[PFUser currentUser] objectForKey:@"surname"] substringToIndex:1]] forKey:@"senderName"];
        }
        else {
            [message setObject:[PFUser currentUser].username forKey:@"senderName"];
        }
        
        [message setObject:_mood forKey:@"mood"];
        
        if (_mood_text.length > 0) {
            [message setObject:_mood_text forKey:@"text"];
        } else {
            [message setObject:_mood_text forKey:@"text"];
        }
        [message setObject:_linkToHug forKey:@"linkToHug"];
        [message setObject:@(_hugDuration) forKey:@"duration"];
        
        for (int i =0; i<selectedIds.count; i++) {
            PFObject *message2 = [PFObject objectWithClassName:@"Hugs"];
            [message2 setObject:@[[PFUser currentUser].objectId] forKey:@"recipiantIds"];
            [message2 setObject:selectedIds[i] forKey:@"senderId"];
            
            if (![selected[i][@"name"] isEqualToString:@""] && selected[i][@"name"] != nil && ![selected[i][@"surname"] isEqualToString:@""] && selected[i][@"surname"] != nil) {
                [message2 setObject:[NSString stringWithFormat:@"%@ %@", selected[i][@"name"], [selected[i][@"surname"] substringToIndex:1]] forKey:@"senderName"];
            }
            else {
                [message2 setObject:[PFUser currentUser].username forKey:@"senderName"];
            }
            
            [message2 setObject:_mood forKey:@"mood"];
            [message2 setObject:@(1) forKey:@"shown"];
            [message2 setObject:@(_hugDuration) forKey:@"duration"];
            [message2 saveInBackground];
        }
        
        
        
        if ([[PFUser currentUser] valueForKey:@"HUGS"] != nil) {
            int hugs = [[[PFUser currentUser] valueForKey:@"HUGS"] intValue];
            hugs+=1;
            [[PFUser currentUser] setValue:@(hugs) forKey:@"HUGS"];
        }
        else {
            [[PFUser currentUser] setValue:@(1) forKey:@"HUGS"];
        }
        
        if ([[PFUser currentUser] valueForKey:@"DURATION"] != nil) {
            int duration = [[[PFUser currentUser] valueForKey:@"DURATION"] intValue];
            duration+=_hugDuration;
            [[PFUser currentUser] setValue:@(duration) forKey:@"DURATION"];
        }
        else {
            [[PFUser currentUser] setValue:@(_hugDuration) forKey:@"DURATION"];
        }
        
        
        if ([[PFUser currentUser] valueForKey:_mood] != nil) {
            int mooditems = [[[PFUser currentUser] valueForKey:_mood] intValue];
            mooditems +=1;
            [[PFUser currentUser] setValue:@(mooditems) forKey:_mood];
        }
        else {
            [[PFUser currentUser] setValue:@(1) forKey:_mood];
        }
        //[[PFUser currentUser] saveInBackground];
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Upload error, please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
            else {
                _moodImageView.hidden = YES;
                [indicatorView stopAnimating];
                
                [PFCloud callFunctionInBackground:@"iosPushHugSent"
                                   withParameters:parametrs
                                            block:^(id  _Nullable object, NSError * _Nullable pushError) {
                                                NSLog(@"Error:%@", pushError);
    
                                            }];
                [self performSegueWithIdentifier:@"sent" sender:self];
            }
        }];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"You have to select some friends first!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (IBAction)selectAll:(id)sender {
    if( isSelectedAll == false) {
        for(int i = 0; i < items.count; i++){
            PFUser *user = items[i];
            [selected addObject:user];
            [selectedIds addObject:user.objectId];
        }
        isSelectedAll = true;
        _isAllSelectedImageVIew.image = [UIImage imageNamed:@"friend_selected"];
    } else {
        for(int i = 0; i < items.count; i++){
            PFUser *user = items[i];
            [selected removeObject:user];
            [selectedIds removeObject:user.objectId];
        }
        isSelectedAll = false;
        
        _isAllSelectedImageVIew.image = [UIImage imageNamed:@"friend_unselected"];
    }
    [self.tableView reloadData];
}

@end
