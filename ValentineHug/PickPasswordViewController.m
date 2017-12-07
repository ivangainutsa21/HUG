//
//  PickPasswordViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "PickPasswordViewController.h"
#import "PickEmailViewController.h"
#import "ProgressHUD.h"

@interface PickPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_passField becomeFirstResponder];
    _keyboardSpace.constant = _hgt;
    [self.view layoutIfNeeded];
    _bgImageView.image = [UIImage imageNamed:_mood];
    [_okBtn setTitleColor:_tColor forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [_passField becomeFirstResponder];
}

- (IBAction)next:(id)sender {
    if (_passField.text.length>5) {
        [self performSegueWithIdentifier:@"email" sender:self];
    }
    else {
        [ProgressHUD showError:@"Password has to be at least 6 characters"];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickEmailViewController *pe = segue.destinationViewController;
    [_items setValue:_passField.text forKey:@"password"];
    pe.items = _items;
    pe.hgt = _hgt;
    pe.mood = _mood;
    pe.tColor = _tColor;

}


@end
