//
//  FacebookLoginOrViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "FacebookLoginOrViewController.h"
#import "SimpleImageMenuCell.h"
#import "ProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import "AppDelegate.h"

@interface FacebookLoginOrViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FacebookLoginOrViewController{
    NSArray *images;
    NSArray *titles;
    PFUser *currentUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    titles = @[@"WITH FACEBOOK", @"WITH USERNAME"];
    images = @[@"fb_icon", @"add_icon"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)processFacebook:(PFUser *)user {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id, name, first_name, last_name, picture.type(large), email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error == nil)
         {
             if(user.isNew){
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

                 NSDictionary *pictureData = userData[@"picture"];
                 if (pictureData[@"data"][@"url"]) {
                     NSString *avatarURL = pictureData[@"data"][@"url"];
                     dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                         NSURL *aURL = [NSURL URLWithString:avatarURL];
                         NSData *data = [[NSData alloc] initWithContentsOfURL:aURL];
                         UIImage *avatar = [UIImage imageWithData:data];
                         
                         PFFile *imageFile;
                         if (avatar != nil) {
                             imageFile = [PFFile fileWithName:user[PF_USER_USERNAME] data:UIImageJPEGRepresentation(avatar, 0.8)];
                         }
                         else {
                             imageFile = nil;
                         }
                         
                         if (imageFile != nil) {
                             user[PF_USER_PICTURE] = imageFile;
                         }
                     });
                 }
                 
                 currentUser = user;
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

- (void)userLoggedIn:(PFUser *)user {
    [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", user[PF_USER_USERNAME]]];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
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
    return ([UIScreen mainScreen].bounds.size.height-50)/2;
}

@end
