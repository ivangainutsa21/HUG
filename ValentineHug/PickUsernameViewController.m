//
//  PickUsernameViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "PickUsernameViewController.h"
#import "PickPasswordViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "MONActivityIndicatorView.h"

@interface PickUsernameViewController ()<MONActivityIndicatorViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickUsernameViewController {
    float keyboardHeight;
    MONActivityIndicatorView *indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_userField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    _bgImageView.image = [UIImage imageNamed:_mood];
    [_okBtn setTitleColor:_tColor forState:UIControlStateNormal];
    
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

- (IBAction)submit:(id)sender {
    _okBtn.enabled = NO;
    [indicatorView startAnimating];
    if ([[_userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        [ProgressHUD showError:@"Please enter a username"];
        [indicatorView stopAnimating];
        _okBtn.enabled = YES;
    }
    else {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:_userField.text];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            [indicatorView stopAnimating];
            if (number>0) {
                //EXISTS
                NSLog(@"EXISTS");
                [ProgressHUD showError:@"Username already exists"];
            }
            else {
                // ALL GOOD MOVE ON
                [self performSegueWithIdentifier:@"password" sender:self];
            }
        }];
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickPasswordViewController *pv = segue.destinationViewController;
    pv.items = [NSMutableDictionary dictionaryWithObject:_userField.text forKey:@"username"];
    pv.hgt = keyboardHeight;
    pv.mood = _mood;
    pv.tColor = _tColor;
}


@end
