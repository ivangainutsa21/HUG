//
//  SelectAddTableViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-29.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "SelectAddTableViewController.h"
#import "SimpleImageMenuCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import "ProgressHUD.h"

@interface SelectAddTableViewController ()

@end

@implementation SelectAddTableViewController{
    NSArray *titles;
    NSArray *images;
}

-(void)viewDidLoad {
    titles = @[@"FACEBOOK FRIENDS",@"BY USERNAME",@"INVITE FRIENDS"];
    images = @[@"fb_icon", @"search_icon", @"add_icon"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([UIScreen mainScreen].bounds.size.height-50)/3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleImageMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.mainLabel.text = titles[indexPath.row];
    cell.mainImageView.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        NSString *string = @"Send HUG messages that you can feel!";
        NSURL *URL = [NSURL URLWithString:@"http://gethug.co/get"];
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                          applicationActivities:nil];
        [self.navigationController presentViewController:activityViewController
                                                animated:YES
                                              completion:^{
                                                  // ...
                                              }];
    }
    else if(indexPath.row == 0){
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [self performSegueWithIdentifier:@"facebook" sender:self];
        }
        else {
            [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
                              withReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                            block:^(BOOL succeeded, NSError * _Nullable error) {
                if (error == nil) {
                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id, name, first_name, last_name, picture.type(large), email"}];
                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        [PFUser currentUser][PF_USER_FACEBOOKID] = result[@"id"];//[userData valueForKeyPath:@"id"];
                        [[PFUser currentUser] saveInBackground];
                        [self performSegueWithIdentifier:@"facebook" sender:self];
                    }];
                    
                } else {
                    [ProgressHUD showError:[error.userInfo valueForKey:@"error"]];
                }
            }];
        }
    }
    else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"search" sender:self];
    }
}

@end;
