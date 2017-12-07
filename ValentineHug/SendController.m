//
//  SendController.m
//  ValentineHug
//
//  Created by Prinz & Co on 2015-01-23.
//  Copyright (c) 2015 Prinz & Co. All rights reserved.
//

#import "SendController.h"
#import "SendSelectController.h"
@import AVFoundation;

@interface SendController()<UIGestureRecognizerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UITextView *moodField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMoodSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMoodSpace;
@property (weak, nonatomic) IBOutlet UILabel *dragLabel;
@property (weak, nonatomic) IBOutlet UIImageView *triangleImg;
@property (weak, nonatomic) IBOutlet UITextField *linkToHug;
@property (weak, nonatomic) IBOutlet UIButton *attachButton;

@property (weak, nonatomic) IBOutlet UILabel *attachLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextField *chooseMood;
@property (weak, nonatomic) IBOutlet UIImageView *tapHereImg;

@end

@implementation SendController {
    NSString *startText;
    NSTimer *hugTimer;
    NSString *currentmood;
    int i;
    int ti;
    int nc;
    int hugduration;
    int firstX;
    int firstY;
    BOOL isHugging;
    NSTimer *vibrationTimer;
    CGPoint currentPos;
    UITapGestureRecognizer *tap;
    NSString *currentText;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [UIView animateWithDuration:2 animations:^{
        _tapHereImg.alpha = 0;
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self dismissKeyboard];
}

- (void)triggerKeyboard {
    [_moodField becomeFirstResponder];
}

-(void)viewDidLoad {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:UIDeviceProximityStateDidChangeNotification object:device];
    ti = 0;
    i=0;
    nc = 0;
    startText = _topLabel.text;
    
    
//    UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc]
//                                         initWithTarget:self
//                                         action:@selector(hideTapImg)];
//    
//    [self.view addGestureRecognizer:removeTap];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_moodImageView addGestureRecognizer:panRecognizer];
    _moodImageView.alpha = 0.0;
    _dragLabel.alpha = 0.0;
    
    _moodField.delegate = self;
    _moodField.hidden = YES;
    _moodField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    
    _tapHereImg.alpha = 0;
    
    UITapGestureRecognizer *openKeyboard = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(triggerKeyboard)];
    
    [_tapHereImg addGestureRecognizer:openKeyboard];
    
    _chooseMood.hidden = YES;
    
    currentmood = @"HAPPY HUG";
    
    _chooseMood.text = @"HAPPY HUG";
    
    isHugging = NO;
    
    currentPos = CGPointMake([UIScreen mainScreen].bounds.size.width/3.3, [UIScreen mainScreen].bounds.size.height/4);
    
    _iconImage.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  [UIImage imageNamed:@"emoji_1-1s"],
                                  
                                  [UIImage imageNamed:@"emoji_2-0s"],
                                  [UIImage imageNamed:@"emoji_2-0s"],
                                  
                                  [UIImage imageNamed:@"emoji_3-0s"],
                                  [UIImage imageNamed:@"emoji_3-0s"],
                                  
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  [UIImage imageNamed:@"emoji_4-2s"],
                                  
                                  [UIImage imageNamed:@"emoji_5-0s"],
                                  [UIImage imageNamed:@"emoji_5-0s"],
                                  
                                  [UIImage imageNamed:@"emoji_6-0s"],
                                  [UIImage imageNamed:@"emoji_6-0s"],
                                  nil];
    _iconImage.animationDuration = 3.0;
    _iconImage.animationRepeatCount = 0;
    [_iconImage startAnimating];
}

- (void)hideTapImg {
    [UIView animateWithDuration:2 animations:^{
        _tapHereImg.alpha = 0;
        _tapHereImg.hidden = YES;
    }];
}



-(void)updateTextLabelsWithText:(NSString *)str {
    
    NSRange range = [str rangeOfString: @"\n"];
    if (range.length > 0) {
        [_moodField resignFirstResponder];
    }
    
    _moodField.text = [_moodField.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([str length] > 60) return;
    
    str = [str stringByReplacingOccurrencesOfString:@" HUG"
                                   withString:@""];
    
    NSMutableString *string = [[str stringByReplacingOccurrencesOfString:@" "
                                         withString:@"-"] mutableCopy];
    
    string = [[string stringByReplacingOccurrencesOfString:@"\n"
                                            withString:@""] mutableCopy];
    
    NSUInteger characterCount = [string length];
    
    [string appendString:@" HUG"];
    
    [_moodField setText:string.uppercaseString];
    
    
    [_moodField setSelectedRange:NSMakeRange(characterCount, 0)];
    currentText = string.uppercaseString;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self updateTextLabelsWithText: newString];
    NSLog(@"Changed Str: %@",newString);
    
    return FALSE;
}

-(void)dismissKeyboard {
    [self.moodField endEditing:true];
    [self.view removeGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    _topSpace.constant = ([UIScreen mainScreen].bounds.size.height/5)*2;
}

- (void) shouldVibrate {
    ti++;
    if (ti == 1) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _descriptionLabel.hidden = NO;
        _backgroundImageView.image = [UIImage imageNamed:@"app_bg"];
        _sendButton.hidden = YES;
        _moodImageView.hidden = YES;
        _iconImage.hidden = NO;
        _moodField.hidden = YES;
        
        hugTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
    }
}

- (void)proximityChanged:(NSNotification *)notification {
    UIDevice *device = [notification object];
    if (device.proximityState == 1) {
        vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(shouldVibrate) userInfo:nil repeats:YES];
    } else {
        [vibrationTimer invalidate];
        ti = 0;
        if (i==0) {
        }
        else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            _topLabel.text = [self timeFormatted:i];
            hugduration = i;
        }
        if (![_topLabel.text isEqualToString:startText]) {
            nc++;
            
            _descriptionLabel.hidden = YES;
            _iconImage.hidden = YES;
            _backgroundImageView.image = [UIImage imageNamed:@"app_bg"];
            _sendButton.hidden = NO;
            _moodImageView.hidden = NO;
            if (nc == 1) {
                [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    _moodImageView.alpha = 1.0;
                    _dragLabel.alpha = 1.0;
                } completion:^(BOOL finished) {
                    _moodImageView.alpha = 1.0;
                    _dragLabel.alpha = 1.0;
                }];
                _dragLabel.hidden = NO;
            }
            [self setMood:currentPos];
            _topMoodSpace.constant = currentPos.y-40;
            _rightMoodSpace.constant = ([UIScreen mainScreen].bounds.size.width-currentPos.x)-40;
            
            _moodField.hidden = NO;
            _chooseMood.hidden = NO;
            
            _attachButton.hidden = YES;
            _attachLabel.hidden = YES;
            
            _timeImageView.hidden = NO;
            _timeLabel.hidden = NO;
            //_timeLabel.text = [self timeFormatted:[_message[@"duration"] intValue]];
            _timeLabel.text = [self timeFormatted:hugduration];
            
            [self.view layoutIfNeeded];
        }
        
        [hugTimer invalidate];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
}

-(void)move:(id)sender {
    _dragLabel.hidden = YES;
    
    [UIView animateWithDuration:2 animations:^{
        _tapHereImg.alpha = 1;
        _tapHereImg.hidden = NO;
    }];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        firstX = [_moodImageView center].x;
        firstY = [_moodImageView center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    currentPos = translatedPoint;
    
    _topMoodSpace.constant = translatedPoint.y - 40;
    _rightMoodSpace.constant = ([UIScreen mainScreen].bounds.size.width-translatedPoint.x)-40;
    
    [_moodImageView  setCenter:translatedPoint];
    [self setMood:translatedPoint];
    [self.view layoutIfNeeded];
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
        }
        if (currentText) {
            _moodField.text = currentText;
            //        _moodLabel.text = currentmood;
            _chooseMood.text = currentText;
        } else {
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
            //        _moodLabel.text = currentmood;
            _chooseMood.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
        }
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
        }
        
        if (currentText) {
            _moodField.text = currentText;
            //        _moodLabel.text = currentmood;
            _chooseMood.text = currentText;
        } else {
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
            //        _moodLabel.text = currentmood;
            _chooseMood.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
        }
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SendSelectController *sc = segue.destinationViewController;
    sc.hugDuration = hugduration;
    sc.mood = currentmood;
    sc.mood_text = self.moodField.text;
    sc.linkToHug = self.linkToHug.text;
  
}

- (void) count {
    i++;
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextView:(id)sender {
    [_moodImageView setHidden:YES];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
- (IBAction)attachLink:(id)sender {
    if([self.triangleImg isHidden] == YES) {
        [self.triangleImg setHidden:NO];
        [self.linkToHug setHidden:NO];
    } else {
        [self.triangleImg setHidden:YES];
        [self.linkToHug setHidden:YES];
        if(![[self.linkToHug text]  isEqual: @""]){
            self.attachLabel.text =
            @"Content attached";
        } else {
            self.attachLabel.text =
            @"Attach";
        }
        [self.view endEditing:YES];
    }
}

@end
