//
//  SignupMoodViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-04.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "SignupMoodViewController.h"
#import "FacebookOrCreateViewController.h"

@interface SignupMoodViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UILabel *dragLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midContstant;

@end

@implementation SignupMoodViewController {
    int firstX;
    int firstY;
    NSString *imgName;
    UIColor *btnColor;
    NSString *currentmood;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_moodImageView addGestureRecognizer:panRecognizer];
    
    _nextBtn.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [_moodImageView setHidden:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FacebookOrCreateViewController *fc = segue.destinationViewController;
    fc.mood = imgName;
    fc.tColor = btnColor;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [_moodImageView setHidden:YES];
}

-(void)move:(id)sender {
    
    _dragLabel.hidden = YES;
    _nextBtn.hidden = NO;
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        firstX = [_moodImageView center].x;
        firstY = [_moodImageView center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    [_moodImageView  setCenter:translatedPoint];
    [self setMood:translatedPoint];
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    return [image1 isEqual:image2];
}

- (void) setMood:(CGPoint)point {
    int screenheight = [UIScreen mainScreen].bounds.size.height;
    int screenwidth = [UIScreen mainScreen].bounds.size.width;
    
    if (point.x>screenwidth/2) {
        //RIGHT SIDE OF DISPLAY
        if (point.y<screenheight/3) {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"excited"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"excited"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"excited_bg"];
            currentmood = @"EXCITED";
            imgName = @"excited_bg";
            btnColor = [UIColor colorWithRed:0.99 green:0.84 blue:0.46 alpha:1];
            
        }
        else if(point.y<(screenheight/3)*2) {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"loving"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"loving"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"loving_bg"];
            currentmood = @"LOVING";
            imgName = @"loving_bg";
            btnColor = [UIColor colorWithRed:0.99 green:0.54 blue:0.6 alpha:1];
        }
        else {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"sad"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"sad"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"sad_bg"];
            currentmood = @"SAD";
            imgName = @"sad_bg";
            btnColor = [UIColor colorWithRed:0.35 green:0.31 blue:0.62 alpha:1];
        }
        _moodLabel.text = [currentmood uppercaseString];
    }
    else {
        //LEFT SIDE OF DISPLAY
        if (point.y<screenheight/3) {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"happy"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"happy"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"happy_bg"];
            currentmood = @"HAPPY";
            imgName = @"happy_bg";
            btnColor = [UIColor colorWithRed:0.99 green:0.76 blue:0.49 alpha:1];
            
        }
        else if(point.y<(screenheight/3)*2) {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"party"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"party"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"party_bg"];
            currentmood = @"PARTY";
            imgName = @"party_bg";
            btnColor = [UIColor colorWithRed:0.71 green:0.87 blue:0.51 alpha:1];
        }
        else {
            if (![self image:_moodImageView.image isEqualTo:[UIImage imageNamed:@"curious"]]) {
                _moodImageView.alpha = 0.0;
                [UIView animateWithDuration:0.1 animations:^{
                    _moodImageView.image = [UIImage imageNamed:@"curious"];
                    _moodImageView.alpha = 1.0;
                }];
            }
            _backgroundImageView.image = [UIImage imageNamed:@"curious_bg"];
            currentmood = @"CURIOUS";
            imgName = @"curious_bg";
            btnColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1];
        }
        _moodLabel.text = currentmood;
    }
}


@end
