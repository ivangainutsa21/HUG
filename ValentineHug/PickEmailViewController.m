//
//  PickEmailViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "PickEmailViewController.h"
#import "PickNameViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "MONActivityIndicatorView.h"

@interface PickEmailViewController ()<MONActivityIndicatorViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickEmailViewController{
    MONActivityIndicatorView *indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_emailField becomeFirstResponder];
    _keyboardSpace.constant = _hgt;
    [self.view layoutIfNeeded];
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
    [_emailField becomeFirstResponder];
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self validateEmail:[NSString stringWithFormat:@"%@%@", textField.text, string]]) {
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
    }
    else {
        [_okBtn setTitle:@"SKIP" forState:UIControlStateNormal];
    }
    return YES;
}

- (IBAction)next:(id)sender {
    if([_emailField.text isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"name" sender:self];
    }
    else {
        if ([self validateEmail:_emailField.text]) {
            [indicatorView startAnimating];
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:_emailField.text];
            [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                [indicatorView stopAnimating];
                if (number>0) {
                    //EXISTS
                    NSLog(@"EXISTS");
                    [ProgressHUD showError:@"Email already exists"];
                }
                else {
                    // ALL GOOD MOVE ON
                    [self performSegueWithIdentifier:@"name" sender:self];
                }
            }];
        }
        else {
            [ProgressHUD showError:@"Invalid email"];
        }
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickNameViewController *pe = segue.destinationViewController;
    [_items setValue:_emailField.text forKey:@"email"];
    pe.items = _items;
    pe.hgt = _hgt;
    pe.mood = _mood;
    pe.tColor = _tColor;
}

@end
