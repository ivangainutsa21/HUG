//
//  PickGenderViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "AppConstant.h"
#import "PickGenderViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "MONActivityIndicatorView.h"
#import "AppDelegate.h"

@interface PickGenderViewController ()<MONActivityIndicatorViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickGenderViewController {
    NSString *gender;
    MONActivityIndicatorView *indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    gender = @"";
    _bgImageView.image = [UIImage imageNamed:_mood];
    [_nextBtn setTitleColor:_tColor forState:UIControlStateNormal];
    
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

- (IBAction)man:(id)sender {
    gender = @"MAN";
    [self setText];
}
- (IBAction)woman:(id)sender {
    gender = @"WOMAN";
    [self setText];
}

- (void) setText{
        [_manBtn setImage:[UIImage imageNamed:@"man-1"] forState:UIControlStateNormal];
        [_womanBtn setImage:[UIImage imageNamed:@"woman-1"] forState:UIControlStateNormal];
    
    
    [_nextBtn setTitle:[NSString stringWithFormat:@"I AM A %@", gender] forState:UIControlStateNormal];
    if ([gender isEqualToString:@"MAN"]) {
        [_manBtn setImage:[UIImage imageNamed:@"man-1-clicked"] forState:UIControlStateNormal];
    }
    else {
        [_womanBtn setImage:[UIImage imageNamed:@"woman-1-clicked"] forState:UIControlStateNormal];
    }
    _nextBtn.hidden = NO;

}


- (IBAction)next:(id)sender {
    NSLog(@"%@", _items);
    [indicatorView startAnimating];
    NSString *username	= _items[@"username"];
    NSString *password	= _items[@"password"];
    NSString *email		= _items[@"email"];
    NSString *name = _items[@"name"];
    NSString *surname = _items[@"surname"];
    
    PFFile *imageFile;
    if (_items[@"photo"] != nil) {
        imageFile = [PFFile fileWithName:_items[@"username"] data:UIImageJPEGRepresentation(_items[@"photo"], 0.8)];
    }
    else {
        imageFile = nil;
    }
    
    if ((username.length != 0) && (password.length != 0))
    {
        NSLocale *locale = [NSLocale currentLocale];
        NSString *country = [locale displayNameForKey:NSLocaleIdentifier value:[locale localeIdentifier]];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        user[@"name"] = name;
        user[@"surname"] = surname;
        if (imageFile != nil) {
            user[@"image"] = imageFile;
        }
        user[@"gender"] = gender;
        user[PF_USER_COUNTRY] = country;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [indicatorView stopAnimating];

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

@end
