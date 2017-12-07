//
//  PickNameViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "PickNameViewController.h"
#import "PickPhotoViewController.h"
#import "ProgressHUD.h"

@interface PickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpace;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_nameField becomeFirstResponder];
    _keyboardSpace.constant = _hgt;
    [self.view layoutIfNeeded];
    _bgImageView.image = [UIImage imageNamed:_mood];
    [_okBtn setTitleColor:_tColor forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [_nameField becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![_nameField.text isEqualToString:@""] && ![_surnameField.text isEqualToString:@""]) {
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
    }
    else {
        [_okBtn setTitle:@"SKIP" forState:UIControlStateNormal];
    }
    return YES;
}

- (IBAction)next:(id)sender {
    if (![[_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        //NAME VALID
        if (![[_surnameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            //SURNAME VALID
            [self performSegueWithIdentifier:@"photo"sender:self];
        }
        else {
            [ProgressHUD showError:@"Enter surname"];
        }
    }
    else{
        [self performSegueWithIdentifier:@"photo"sender:self];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickPhotoViewController *pe = segue.destinationViewController;
    [_items setValue:_nameField.text forKey:@"name"];
    [_items setValue:_surnameField.text forKey:@"surname"];
    pe.items = _items;
    pe.mood = _mood;
    pe.tColor = _tColor;
}

@end
