//
//  LoginController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "LoginController.h"
#import  <Parse/Parse.h>
#import "ProgressHUD.h"
#import "AppDelegate.h"

@interface LoginController()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (strong, nonatomic) IBOutlet UITextField *fieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@end

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    float keyboardheight = kbSize.height;
    _keyboardSpace.constant = keyboardheight;
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_fieldUsername becomeFirstResponder];
}

- (IBAction)actionLogin:(id)sender
{
    NSString *username = _fieldUsername.text;
    NSString *password = _fieldPassword.text;
    
    if ((username.length != 0) && (password.length != 0))
    {
        [ProgressHUD show:@"Signing in..." Interaction:NO];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
         {
             if (user != nil)
             {
                 [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", [user objectForKey:PF_USER_USERNAME]]];
                 NSString * storyboardName = @"Main";
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                 UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
                 [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
             }
             else [ProgressHUD showError:[error.userInfo valueForKey:@"error"]];
         }];
    }
    else [ProgressHUD showError:@"Please enter a username and password."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        [self actionLogin:nil];
    }
    return YES;
}

- (IBAction)resetPass:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset password" message:@"Enter your HUG email associated with your account." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Send" ,nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
