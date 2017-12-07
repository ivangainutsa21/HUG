//
//  SelectController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-23.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "SelectController.h"


@interface SelectController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *startedBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation SelectController {
    NSArray *textSnippets;
    NSArray *images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textSnippets = @[
                     @"HUG is the first emoji\nthat you can feel!",
                     @"Put the phone to your\nheart to record a HUG",
                     @"HUG for as looong as you\nwant and set your mood",
                     @"When recieving a HUG simply\nplace it to your heart to feel it",
                     @"That’s it!\nSend your first HUG now!"
                     ];
    
    images = @[
               @"tutorial_1",
               @"tutorial_2",
               @"tutorial_3",
               @"tutorial_4",
               @"tutorial_1"
               ];
    
    
    int relativeWidth = [UIScreen mainScreen].bounds.size.width;
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.mainScrollView.clipsToBounds = YES;
    
    for (int i = 0; i < 5; i++) {
        
        CGRect frame;
        frame.size = CGSizeMake(relativeWidth, 225);

        frame.origin.x = relativeWidth * i;
        if (screenHeight>568) {
            frame.origin.y = 80;
        }
        else if(screenHeight == 480) {
            frame.origin.y = 10;
            frame.size = CGSizeMake(relativeWidth, 150);
        }
        else {
            frame.origin.y = 30;
        }


        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setClipsToBounds:YES];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(relativeWidth*i+10, [UIScreen mainScreen].bounds.size.height-290, relativeWidth-20, 50)];
        label.numberOfLines = 3;
        [label setText:textSnippets[i]];
        [label setTextColor:[UIColor colorWithRed:1 green:0.98 blue:0.91 alpha:1]];
        [label setFont:[UIFont fontWithName:@"FuturaStd-Bold" size:17.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.mainScrollView addSubview:imageView];
        
        
        if (i == 4) {
            UIImageView *zoomImage = [[UIImageView alloc] initWithFrame:CGRectMake(relativeWidth*i-(relativeWidth/2), 58, 100, 100)];
            [zoomImage setClipsToBounds:YES];
            zoomImage.image = [UIImage imageNamed:@"tutorial_4_zoom"];
            zoomImage.contentMode = UIViewContentModeScaleAspectFit;
            [self.mainScrollView addSubview:zoomImage];
        }
        
        [self.mainScrollView addSubview:label];
    }
    self.mainScrollView.contentSize = CGSizeMake(relativeWidth * 5, _mainScrollView.bounds.size.height-40);
    if (screenHeight == 480) {
        self.mainScrollView.contentSize = CGSizeMake(relativeWidth * 5, _mainScrollView.bounds.size.height-150);
    }
    self.pageControl.numberOfPages = 5;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)changePage
{
    int page = (int)self.pageControl.currentPage;
    page +=1;
    [self.mainScrollView scrollRectToVisible:CGRectMake(self.mainScrollView.frame.size.width*page, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) animated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    self.pageControl.currentPage = page;
    switch (page) {
        case 0:
            [_startedBtn setTitle:@"GET STARTED" forState:UIControlStateNormal];
            [_startedBtn setBackgroundImage:[UIImage imageNamed:@"app_bg"] forState:UIControlStateNormal];
            [_startedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 1:
            [_startedBtn setTitle:@"OK, COOL!" forState:UIControlStateNormal];
            [_startedBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_startedBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.64 blue:0.89 alpha:1] forState:UIControlStateNormal];
            break;
        case 2:
            [_startedBtn setTitle:@"GREAT!" forState:UIControlStateNormal];
            [_startedBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_startedBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.64 blue:0.89 alpha:1] forState:UIControlStateNormal];
            break;
        case 3:
            [_startedBtn setTitle:@"OK, SWEET!" forState:UIControlStateNormal];
            [_startedBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_startedBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.64 blue:0.89 alpha:1] forState:UIControlStateNormal];
            break;
        case 4:
            [_startedBtn setTitle:@"SIGN UP" forState:UIControlStateNormal];
            [_startedBtn setBackgroundImage:[UIImage imageNamed:@"app_bg"] forState:UIControlStateNormal];
            [_startedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)started:(id)sender {
    if (self.pageControl.currentPage == 4) {
        [self performSegueWithIdentifier:@"signup" sender:self];
    }
    else {
        [self changePage];
    }
}

- (IBAction)login:(id)sender {
    
}

@end