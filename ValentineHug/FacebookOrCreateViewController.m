//
//  FacebookOrCreateViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "FacebookOrCreateViewController.h"
#import "SimpleImageMenuCell.h"
#import "ProgressHUD.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PickUsernameViewController.h"
#import "AppDelegate.h"

@interface FacebookOrCreateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableView;

@end

@implementation FacebookOrCreateViewController {
    NSArray *images;
    NSArray *titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"SIGN IN WITH FACEBOOK", @"CREATE NEW USER"];
    images = @[@"fb_icon", @"add_icon"];
    
    _bgImageView.image = [UIImage imageNamed:_mood];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //FACEBOOK SIGN IN
        if ([NSClassFromString(@"FBSDKInternalUtility") performSelector:@selector(isFacebookAppInstalled)]) {
            [ProgressHUD show:@"Signing in..." Interaction:NO];
        }
        
        [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                                        block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                                                            NSLog(@"%@", user);
                                                            NSLog(@"%@", error);
                                                            if (user != nil)
                                                            {
                                                                NSLog(@"NOT NIL");
                                                                if (user[PF_USER_FACEBOOKID] == nil)
                                                                {
                                                                    [self processFacebook:user];
                                                                }
                                                                else [self userLoggedIn:user];
                                                            }
                                                            else [ProgressHUD showError:[error.userInfo valueForKey:@"error"]];
        }];
    }
    else {
        [self performSegueWithIdentifier:@"create" sender:self];
    }
}

- (void)processFacebook:(PFUser *)user {
    if ([FBSDKAccessToken currentAccessToken] != nil) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id, name, first_name, last_name, picture.type(large), email"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error == nil) {
                if(user.isNew) {
                    NSLocale *locale = [NSLocale currentLocale];
                    NSString *country = [locale displayNameForKey:NSLocaleIdentifier value:[locale localeIdentifier]];
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSArray *nitems = [[userData valueForKey:@"name"] componentsSeparatedByString:@" "];
                    
                    user[PF_USER_FIRSTNAME] = nitems[0];
                    user[PF_USER_SURNAME] = nitems[1];
                    user[PF_USER_FACEBOOKID] = [userData valueForKeyPath:@"id"];
                    //                 user[PF_USER_GENDER] = [[userData valueForKey:@"gender"] uppercaseString];
                    //                 user[PF_USER_EMAIL] = [userData valueForKey:@"email"];
                    user[PF_USER_COUNTRY] = country;
                    
                    [ProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"fb" sender:self];
                }
                else {
                    if (error == nil)
                    {
                        [self userLoggedIn:user];
                    }
                }
            }
            else
            {
                [PFUser logOut];
                [ProgressHUD showError:@"Failed to fetch Facebook user data."];
            }
        }];
        
    }
    else {
        [PFUser logOut];
        [ProgressHUD showError:@"Failed to fetch Facebook user data."];
    }
}

- (void)userLoggedIn:(PFUser *)user
{
    [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", user[PF_USER_USERNAME]]];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fb"]) {
        
    }
    else {
        PickUsernameViewController *pc = segue.destinationViewController;
        pc.mood = _mood;
        pc.tColor = _tColor;
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleImageMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.mainImageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.mainLabel.text = titles[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([UIScreen mainScreen].bounds.size.height)/2;
}

@end
