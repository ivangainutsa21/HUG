//
//  ContactsViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-29.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "ContactsViewController.h"
#import "SelectFriendCell.h"
#import "MONActivityIndicatorView.h"
#import "FriendRelationViewController.h"

@interface ContactsViewController ()<MONActivityIndicatorViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@end

@implementation ContactsViewController {
    PFRelation *friendsRelation;
    MONActivityIndicatorView *indicatorView;
    NSMutableArray *searchResults;
    int keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    //[_searchField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
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
                if (objects.count == 0) {
                    _middleLabel.hidden = NO;
                }
                else {
                    _middleLabel.hidden = YES;
                    self.friends = [NSMutableArray arrayWithArray:objects];
                    [self.tableView reloadData];
                }
            }
        }];
    }
    else {
        [indicatorView stopAnimating];
        _inviteLabel.hidden = NO;
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardHeight = kbSize.height;
    _keyboardSpace.constant = keyboardHeight;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    keyboardHeight = 0;
    _keyboardSpace.constant = keyboardHeight;
    [self.view layoutIfNeeded];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return self.friends.count;
    }
    else {
        return searchResults.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFUser *user;
    if ([[_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        user = self.friends[indexPath.row];
    }
    else {
        user = searchResults[indexPath.row];
    }
    
    if (user[@"emailVerified"] != nil &&  [[user valueForKey:@"emailVerified"] boolValue] == YES)
    {
        
        cell.friendImageView.image = [UIImage imageNamed:@"email_verified_icon"];
        [cell.friendInitialLabel setHidden:YES];
        
    } else {
        cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
        cell.friendUserLabel.text = [user.username uppercaseString];
        cell.friendImageView.backgroundColor = [UIColor whiteColor];
        cell.friendImageView.layer.cornerRadius = cell.friendImageView.bounds.size.width/2;
        [cell.friendInitialLabel setHidden:NO];
        cell.friendInitialLabel.text = [[user.username substringToIndex:2] uppercaseString];
    }
    return cell;
}

- (IBAction)changed:(id)sender {
    _middleLabel.hidden = NO;
    UITextField *tf = sender;
    if([[tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        if (self.friends.count == 0) {
            _middleLabel.text = @"Invite or add contacts now,\nclick the button below.";
        }
        else{
            _middleLabel.text = @"";
        }
        searchResults = self.friends;
        [self.tableView reloadData];
    }
    else {
        [self filterText:tf.text];
    }
}

- (void) filterText:(NSString*)text {
    NSPredicate *uPredicate = [NSPredicate predicateWithFormat:@"username contains[cd] %@",text];
    NSPredicate *nPredicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@",text];
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"surname contains[cd] %@",text];
    NSPredicate *resultPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[uPredicate, nPredicate, sPredicate]];
    searchResults = [NSMutableArray arrayWithArray:[[self.friends filteredArrayUsingPredicate:resultPredicate] mutableCopy]];
    if (searchResults.count == 0) {
        _middleLabel.text = @"Couldn’t find that user";
    }
    else {
        _middleLabel.text = @"";
    }
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"friendInfo"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        FriendRelationViewController *fr = (FriendRelationViewController *)navigationController.topViewController;
        PFUser *friend = self.friends[indexPath.row];
        fr.fr = friend;
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)endEdit:(id)sender {
    [_searchField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [friendsRelation removeObject:self.friends[indexPath.row]];
        if ([[_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [self.friends removeObjectAtIndex:indexPath.row];
        }
        else {
            [self.friends removeObject:searchResults[indexPath.row]];
            [searchResults removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[PFUser currentUser] saveInBackground];
        if (self.friends.count == 0) {
            _middleLabel.hidden = NO;
        }
    } 
}

@end
