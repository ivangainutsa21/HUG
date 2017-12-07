//
//  PickPhotoViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "PickPhotoViewController.h"
#import "FDTakeController.h"
#import "PickGenderViewController.h"

@interface PickPhotoViewController ()<FDTakeDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property FDTakeController *takeController;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation PickPhotoViewController {
    UIImage *userImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _photoBtn.layer.cornerRadius = _photoBtn.bounds.size.width/2;
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    self.takeController.takePhotoText = @"Take Photo";
    self.takeController.chooseFromPhotoRollText = @"Choose Existing";
    self.takeController.chooseFromLibraryText = @"Choose Existing";
    self.takeController.allowsEditingPhoto = YES;
    _nextBtn.hidden = NO;
    _bgImageView.image = [UIImage imageNamed:_mood];
    [_okBtn setTitleColor:_tColor forState:UIControlStateNormal];
    [_tapBtn setTitleColor:_tColor forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (IBAction)selectPhoto:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    [self.photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
    [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
    [self.photoBtn setContentMode:UIViewContentModeCenter];
    userImage = photo;
    _nextBtn.hidden = NO;
    [_nextBtn setTitle:@"LOOKS GOOD!" forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PickGenderViewController *pe = segue.destinationViewController;
    [_items setValue:userImage forKey:@"photo"];
    pe.items = _items;
    pe.mood = _mood;
    pe.tColor = _tColor;
}

@end
