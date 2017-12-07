//
//  AccountViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-29.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AccountViewController.h"
#import "PFUser+logOut.h"
#import "UIKit+AFNetworking/UIButton+AFNetworking.h"
#import "ProgressHUD.h"

@interface AccountViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *excitedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *happyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lovingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonelyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *curiousCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hugCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    _unameLabel.text = user.username;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    if (user[@"EXCITED"] != nil) {
        _excitedCountLabel.text = [NSString stringWithFormat:@"%@", user[@"EXCITED"]];
    }
    
    if (user[@"HAPPY"] != nil) {
        _happyCountLabel.text = [NSString stringWithFormat:@"%@", user[@"HAPPY"]];
    }
    
    if (user[@"LOVING"] != nil) {
        _lovingCountLabel.text = [NSString stringWithFormat:@"%@", user[@"LOVING"]];
    }
    
    if (user[@"LONELY"] != nil) {
        _lonelyCountLabel.text = [NSString stringWithFormat:@"%@", user[@"LONELY"]];
    }
    
    if (user[@"CURIOUS"] != nil) {
        _curiousCountLabel.text = [NSString stringWithFormat:@"%@", user[@"CURIOUS"]];
    }
    
    if (user[@"PARTY"] != nil) {
        _partyCountLabel.text = [NSString stringWithFormat:@"%@", user[@"PARTY"]];
    }
    
    if (user[@"HUGS"] != nil) {
        _hugCountLabel.text = [NSString stringWithFormat:@"%@", user[@"HUGS"]];
    }
    else{
        _hugCountLabel.text = @"0";
    }
    
    if (user[@"DURATION"] != nil) {
        _timeCountLabel.text = [self timeFormatted:[user[@"DURATION"] intValue]];
    }
    else {
        _timeCountLabel.text = @"00:00";
    }
    
    _pictureBtn.layer.cornerRadius = _pictureBtn.bounds.size.width/2;
    _pictureBtn.clipsToBounds = YES;
    if (user[@"facebookId"] != nil) {
        [_pictureBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture/?type=square&type=large", user[@"facebookId"]]]];
    } else {
        PFFile *thumbnail = [user objectForKey:@"image"];
        if (thumbnail != nil) {
            NSData *imageData = [thumbnail getData];
            UIImage *uimage = [UIImage imageWithData:imageData];
            [_pictureBtn setBackgroundImage:uimage forState:UIControlStateNormal];
        }
    }
    
    _usernameField.text = user.username;
    _usernameField.textAlignment = NSTextAlignmentRight;
    _usernameField.textColor = [UIColor whiteColor];
    _usernameField.font = [UIFont fontWithName:@"FuturaStd-Bold" size:16.0];
    _emailField.text = user.email;
    _emailField.textAlignment = NSTextAlignmentRight;
    _emailField.textColor = [UIColor whiteColor];
    _emailField.font = [UIFont fontWithName:@"FuturaStd-Bold" size:16.0];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    _nameTextField.text = [NSString stringWithFormat:@"%@ %@", user[@"name"], user[@"surname"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg"]];
    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    PFUser *user = [PFUser currentUser];
    if (textField == _emailField) {
        if ([self validateEmail:_emailField.text]) {
            user.email = _emailField.text;
            [user saveInBackground];
            return YES;
        }
        else {
            [ProgressHUD showError:@"Please enter a valid email"];
            return NO;
        }
    }
    else if(textField == _nameTextField) {
        if ([[_nameTextField.text componentsSeparatedByString:@" "] count] == 2) {
            NSArray *nameItems = [_nameTextField.text componentsSeparatedByString:@" "];
            user[@"name"] = nameItems[0];
            user[@"surname"] = nameItems[1];
            _nameLabel.text = [NSString stringWithFormat:@"%@ %@", nameItems[0], nameItems[1]];
            [user saveInBackground];
            return YES;
        }
        else {
            [ProgressHUD showError:@"Invalid name entered"];
            return NO;
        }
    }
    else if (textField == _usernameField){
        if ([[PFUser currentUser].username isEqualToString:_usernameField.text]) {
            return YES;
        } else {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:_usernameField.text];
            NSInteger *items = [query countObjects];
                if (items>0) {
                    [ProgressHUD showError:@"Username already exists"];
                    return NO;
                }
                else {
                    [PFUser currentUser].username = _usernameField.text;
                    self.unameLabel.text = _usernameField.text;
                    [[PFUser currentUser] saveInBackground];
                    return YES;
                }
            }
    }
    
    return YES;
}


- (IBAction)goBack:(id)sender {
    if ([self textFieldShouldEndEditing:_nameTextField] && [self textFieldShouldEndEditing:_emailField]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)nameDone:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)emailDone:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)usernameDone:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutAndStartLogIn];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (IBAction)switchPN:(UISwitch *)sender {
    if(sender.isOn == YES)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

@end
