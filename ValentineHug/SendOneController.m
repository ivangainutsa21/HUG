//
//  SendController.m
//  ValentineHug
//
//  Created by Prinz & Co on 2015-01-23.
//  Copyright (c) 2015 Prinz & Co. All rights reserved.
//

#import "SendOneController.h"
#import "SendSelectController.h"
#import "MONActivityIndicatorView.h"
@import AVFoundation;

@interface SendOneController()<UIGestureRecognizerDelegate, MONActivityIndicatorViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMoodSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMoodSpace;
@property (weak, nonatomic) IBOutlet UILabel *dragLabel;

@property (weak, nonatomic) IBOutlet UITextView *moodField;
@property (weak, nonatomic) IBOutlet UIImageView *tapHereImg;

@end

@implementation SendOneController {
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
    MONActivityIndicatorView *indicatorView;
    UITapGestureRecognizer *tap;
    NSString *currentText;
}

-(void)viewDidAppear:(BOOL)animated {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
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

-(void)viewDidLoad {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:UIDeviceProximityStateDidChangeNotification object:device];
    ti = 0;
    i=0;
    nc = 0;
    startText = _topLabel.text;
    
    _sendButton.alpha = 1.0;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_moodImageView addGestureRecognizer:panRecognizer];
    _moodImageView.alpha = 0.0;
    
    _tapHereImg.alpha = 0;
    _dragLabel.alpha = 0.0;
    _moodField.hidden = YES;
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 3;
    indicatorView.radius = 20;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.5;
    indicatorView.delay = 0.5;
    indicatorView.center = self.view.center;
    //    [self.view addSubview:indicatorView];
    
    _moodField.delegate = self;
    _moodField.hidden = YES;
    _moodField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(hideTapImg)];
    
    [self.view addGestureRecognizer:removeTap];
    
    currentmood = @"HAPPY HUG";
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
    
    NSMutableString *string = [str stringByReplacingOccurrencesOfString:@" "
                                                             withString:@"-"];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n"
                                               withString:@""];
    
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

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            
            [self.view layoutIfNeeded];
        }
        
        [hugTimer invalidate];
    }
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
            _moodField.text = currentText;
        } else {
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
            //        _moodLabel.text = currentmood;
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
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
            _moodField.text = currentText;
        } else {
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
            //        _moodLabel.text = currentmood;
            _moodField.text = [NSString stringWithFormat:@"%@ %@", currentmood, @"HUG"];
        }
        
    }
}


- (IBAction)sendHug:(id)sender {
    [_moodImageView setHidden:YES];
    [_dragLabel setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        _sendButton.alpha = 0.0;
    }];
    [indicatorView startAnimating];
    NSString *msg = [NSString stringWithFormat:@"HUG from %@!", [[PFUser currentUser] objectForKey:@"name"]];
    NSDictionary *data = @{@"alert": msg,
                           @"badge": @"Increment",
                           @"msgId": currentmood };
    
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"userId" containedIn:@[_userId]];
    
    
    
    PFObject *total = [PFObject objectWithClassName:@"Total"];
    [total setObject:@(hugduration) forKey:@"duration"];
    [total setObject:[PFUser currentUser] forKey:@"senderId"];
    [total saveInBackground];
    
    PFObject *message = [PFObject objectWithClassName:@"Hugs"];
    [message setObject:@[_userId] forKey:@"recipiantIds"];
    [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
    
    if (![[[PFUser currentUser] objectForKey:@"name"] isEqualToString:@""] && [[PFUser currentUser] objectForKey:@"name"] != nil && ![[[PFUser currentUser] objectForKey:@"surname"] isEqualToString:@""] && [[PFUser currentUser] objectForKey:@"surname"] != nil) {
        [message setObject:[NSString stringWithFormat:@"%@ %@",[[PFUser currentUser] objectForKey:@"name"], [[[PFUser currentUser] objectForKey:@"surname"] substringToIndex:1]] forKey:@"senderName"];
    }
    else {
        [message setObject:[PFUser currentUser].username forKey:@"senderName"];
    }
    
    
    [message setObject:currentmood forKey:@"mood"];
    [message setObject:@(hugduration) forKey:@"duration"];
    
    PFQuery *q = [PFUser query];
    [q whereKey:@"objectId" equalTo:_userId];
    [q getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *message2 = [PFObject objectWithClassName:@"Hugs"];
        [message2 setObject:@[[PFUser currentUser].objectId] forKey:@"recipiantIds"];
        [message2 setObject:_userId forKey:@"senderId"];
        
        if (![object[@"name"] isEqualToString:@""] && object[@"name"] != nil && ![object[@"surname"] isEqualToString:@""] && object[@"surname"] != nil) {
            [message2 setObject:[NSString stringWithFormat:@"%@ %@", object[@"name"], [object[@"surname"] substringToIndex:1]] forKey:@"senderName"];
        }
        else {
            [message2 setObject:[PFUser currentUser].username forKey:@"senderName"];
        }
        [message2 setObject:currentmood forKey:@"mood"];
        [message2 setObject:@(1) forKey:@"shown"];
        [message2 setObject:@(hugduration) forKey:@"duration"];
        [message2 saveInBackground];
    }];
    
    
    if ([[PFUser currentUser] valueForKey:@"HUGS"] != nil) {
        int hugs = [[[PFUser currentUser] valueForKey:@"HUGS"] intValue];
        hugs+=1;
        [[PFUser currentUser] setValue:@(hugs) forKey:@"HUGS"];
    }
    else {
        [[PFUser currentUser] setValue:@(1) forKey:@"HUGS"];
    }
    
    if ([[PFUser currentUser] valueForKey:@"DURATION"] != nil) {
        int duration = [[[PFUser currentUser] valueForKey:@"DURATION"] intValue];
        duration+=hugduration;
        [[PFUser currentUser] setValue:@(duration) forKey:@"DURATION"];
    }
    else {
        [[PFUser currentUser] setValue:@(hugduration) forKey:@"DURATION"];
    }
    
    
    if ([[PFUser currentUser] valueForKey:currentmood] != nil) {
        int mooditems = [[[PFUser currentUser] valueForKey:currentmood] intValue];
        mooditems +=1;
        [[PFUser currentUser] setValue:@(mooditems) forKey:currentmood];
    }
    else {
        [[PFUser currentUser] setValue:@(1) forKey:currentmood];
    }
    [[PFUser currentUser] saveInBackground];
    
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Upload error, please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        else {
            [self performSegueWithIdentifier:@"sent" sender:self];

            NSMutableDictionary *parametrs = [data mutableCopy];
            [parametrs setObject:@[_userId] forKey:@"userIds"];
            [PFCloud callFunctionInBackground:@"iosPushHugSent"
                               withParameters:parametrs
                                        block:^(id  _Nullable object, NSError * _Nullable pushError) {
                                            NSLog(@"Result:%@\nError:%@\nParams %@", object, pushError, parametrs);
                                            
                                        }];

            [indicatorView stopAnimating];
        }
    }];
}

- (void) count {
    i++;
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}
- (IBAction)openHugLink:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_linkToHug
                                                    message:_linkToHug
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
