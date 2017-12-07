//
//  SelectFbUsernameViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-09.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "SelectFbUsernameViewController.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"

@interface SelectFbUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@end

@implementation SelectFbUsernameViewController{
    float keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_userField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [_userField becomeFirstResponder];
    _okBtn.enabled = YES;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardHeight = kbSize.height;
    _keyboardSpace.constant = keyboardHeight;
    [self.view layoutIfNeeded];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submit:(id)sender {
    _okBtn.enabled = NO;
    if ([[_userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        [ProgressHUD showError:@"Please enter a username"];
        _okBtn.enabled = YES;
    }
    else {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:_userField.text];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (number>0) {
                //EXISTS
                NSLog(@"EXISTS");
                [ProgressHUD showError:@"Username already exists"];
            }
            else {
                [PFUser currentUser].username = _userField.text;
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", [PFUser currentUser].username]];
                    NSString * storyboardName = @"Main";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
                    [[AppDelegate sharedDelegate] switchRootViewController:vc animated:YES completion:nil];
                }];

            }
        }];
    }
    
}

@end
