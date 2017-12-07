//
//  SentViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-09.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "SentViewController.h"

@implementation SentViewController {
    NSTimer *slideDown;
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearView)];
    tg.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tg];
    
    slideDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:NO];
}

- (void) count {
    i++;
    if (i==3) {
        [slideDown invalidate];
        [self clearView];
    }
}

-(void) clearView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
