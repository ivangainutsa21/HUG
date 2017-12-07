//
//  RegistrationController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "ProgressHUD.h"
#import <Parse/Parse.h>
#import "RegistrationController.h"
#import "AppDelegate.h"

@interface RegistrationController()
@property (strong, nonatomic) IBOutlet UITextField *fieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *fieldEmail;
@property (strong, nonatomic) IBOutlet UIButton *buttonRegister;
@end

@implementation RegistrationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Register";
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg"]]];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_fieldUsername becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)actionRegister:(id)sender
{
    NSString *username	= _fieldUsername.text;
    NSString *password	= _fieldPassword.text;
    NSString *email		= _fieldEmail.text;
    
    if ((username.length != 0) && (password.length != 0) && (email.length != 0))
    {
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                 [ProgressHUD showSuccess:@"Succeed."];
                 NSString * storyboardName = @"Main";
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                 UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
                 [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
             }
             else [ProgressHUD showError:[error.userInfo valueForKey:@"error"]];
         }];
    }
    else [ProgressHUD showError:@"Please fill all values!"];
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _fieldUsername)
    {
        [_fieldPassword becomeFirstResponder];
    }
    if (textField == _fieldPassword)
    {
        [_fieldEmail becomeFirstResponder];
    }
    if (textField == _fieldEmail)
    {
        [self actionRegister:nil];
    }
    return YES;
}


@end
