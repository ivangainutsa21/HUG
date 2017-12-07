//
//  EditFriendsController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-24.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "EditFriendsController.h"
#import "MSCellAccessory.h"
#import "SelectFriendCell.h"
#import "MONActivityIndicatorView.h"
#import "FriendRelationViewController.h"

@interface EditFriendsController()<MONActivityIndicatorViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@end

@implementation EditFriendsController {
    MONActivityIndicatorView* indicatorView;
    NSNumber* selectedUser;
}

UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    
    self.currentUser = [PFUser currentUser];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.friends = [NSMutableArray new];
    
    selectedUser = nil;
    
    PFRelation* friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    
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
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 3;
    indicatorView.radius = 20;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.5;
    indicatorView.delay = 0.5;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void) searchUser:(NSString*)user {
    [indicatorView startAnimating];
    
    PFQuery *q1 = [PFUser query];
    [q1 whereKey:@"username" containsString:[user capitalizedString]];
    PFQuery *q2 = [PFUser query];
    [q2 whereKey:@"username" containsString:[user lowercaseString]];
    PFQuery *q3 = [PFUser query];
    [q3 whereKey:@"username" containsString:user];
    
    PFQuery *q4 = [PFUser query];
    [q4 whereKey:@"name" containsString:[user capitalizedString]];
    PFQuery *q5 = [PFUser query];
    [q5 whereKey:@"name" containsString:[user lowercaseString]];
    PFQuery *q6 = [PFUser query];
    [q6 whereKey:@"name" containsString:user];
    
    PFQuery *q7 = [PFUser query];
    [q7 whereKey:@"surname" containsString:[user capitalizedString]];
    PFQuery *q8 = [PFUser query];
    [q8 whereKey:@"surname" containsString:[user lowercaseString]];
    PFQuery *q9 = [PFUser query];
    [q9 whereKey:@"surname" containsString:user];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:q1,q2,q3,q4,q5,q6,q7,q8,q9,nil]];
    
        [query orderByAscending:@"username"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@ %@",error, [error userInfo]);
                [[[UIAlertView alloc] initWithTitle:@"Could not search users" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            else {
                self.allUsers = objects;
                if (objects.count == 0) {
                    _middleLabel.text = @"Couldn’t find that user.";
                    _middleLabel.hidden = NO;
                    
                }
                else {
                    _middleLabel.hidden = YES;
                }
                [self.tableView reloadData];
            }
            [indicatorView stopAnimating];
        }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFUser *user = self.allUsers[indexPath.row];
    cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    cell.friendUserLabel.text = [user.username uppercaseString];
    cell.friendImageView.backgroundColor = [UIColor whiteColor];
    cell.friendImageView.layer.cornerRadius = cell.friendImageView.bounds.size.width/2;
    cell.friendInitialLabel.text = [[user.username substringToIndex:2] uppercaseString];
    
    if ((int)indexPath.row == [selectedUser intValue] && selectedUser != nil) {
        cell.layer.contents = (id)[UIImage imageNamed:@"app_bg"].CGImage;
    }
    else {
        cell.layer.contents = nil;
    }
    
    if ([self isFriend:user]) {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"contact-added"];
    }
    else {
        cell.friendSelectionImageView.image = [UIImage imageNamed:@"add-contact"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedUser = @(indexPath.row);
    if ([self isFriend:self.allUsers[indexPath.row]]) {
        [self performSegueWithIdentifier:@"friend" sender:self];
    }
    else {
        [self.tableView reloadData];
        _addBtn.hidden = NO;
    }
}

- (IBAction)addUser:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"friends"];
    
    PFUser *user = self.allUsers[[selectedUser intValue]];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];

    if (![self isFriend:self.allUsers[[selectedUser intValue]]]) {
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        
        NSString *msg = [NSString stringWithFormat:@"%@ just added you!", [[PFUser currentUser] objectForKey:@"username"]];
        NSDictionary *data = @{@"alert": msg,
                               @"badge": @"Increment",
                               @"msgId": @"123" };
        
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Added %@ %@ to HUG", user[@"name"], user[@"surname"]] message:@"Start hugging now!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        NSMutableDictionary *params = [data mutableCopy];
        [params setObject:user.objectId forKey:@"userId"];
        [PFCloud callFunctionInBackground:@"iosPushHugFriendNotification" withParameters:params
                     block:^(id  _Nullable object, NSError * _Nullable error) {
                         NSLog(@"Error:%@", error);
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PFUser *user = self.allUsers[[selectedUser intValue]];
    FriendRelationViewController *fr = segue.destinationViewController;
    fr.fr = user;
}

#pragma mark - Helper methods

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)endEdit:(id)sender {
    selectedUser = nil;
    [_searchField resignFirstResponder];
    if ([[_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        _middleLabel.text = @"Search for username\nor Name Surname.";
    }
    else {
        [self searchUser:_searchField.text];
    }
}

@end
