//
//  MultipleViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-02-08.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "MultipleViewController.h"
#import "MultipleTableViewCell.h"
#import "ReceiveController.h"
#import "NSDate+TimeAgo.h"

@interface MultipleViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation MultipleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _senderLabel.text = [NSString stringWithFormat:@"FROM %@", [_sender uppercaseString]];
    
    NSDictionary *hug = _hugs[0];
    if ([hug[@"mood"] isEqualToString:@"CURIOUS"]) {
       _backgroundImage.image = [UIImage imageNamed:@"curious_bg"];
    }
    if ([hug[@"mood"] isEqualToString:@"EXCITED"]) {
        _backgroundImage.image = [UIImage imageNamed:@"excited_bg"];
    }
    if ([hug[@"mood"] isEqualToString:@"HAPPY"]) {
        _backgroundImage.image = [UIImage imageNamed:@"happy_bg"];
    }
    if ([hug[@"mood"] isEqualToString:@"SAD"]) {
        _backgroundImage.image = [UIImage imageNamed:@"sad_bg"];
    }
    if ([hug[@"mood"] isEqualToString:@"LOVING"]) {
        _backgroundImage.image = [UIImage imageNamed:@"loving_bg"];
    }
    if ([hug[@"mood"] isEqualToString:@"PARTY"]) {
        _backgroundImage.image = [UIImage imageNamed:@"party_bg"];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultipleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.durationLabel.text = [self timeFormatted:[_hugs[indexPath.row][@"duration"] intValue]];
    cell.moodLabel.text = _hugs[indexPath.row][@"text"];
    cell.layer.contents = (id)[UIImage imageNamed:@"app_bg"].CGImage;
    
    NSDate *time = _hugs[indexPath.row][@"datestamp"];
    NSLog(@"%@", time);
    cell.timeLabel.text = [time timeAgo];
    
    
    NSDictionary *hug = _hugs[indexPath.row];
    if ([hug[@"mood"] isEqualToString:@"CURIOUS"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"curious_bg"].CGImage;
    }
    if ([hug[@"mood"] isEqualToString:@"EXCITED"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"excited_bg"].CGImage;
    }
    if ([hug[@"mood"] isEqualToString:@"HAPPY"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"happy_bg"].CGImage;
    }
    if ([hug[@"mood"] isEqualToString:@"SAD"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"sad_bg"].CGImage;
    }
    if ([hug[@"mood"] isEqualToString:@"LOVING"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"loving_bg"].CGImage;
    }
    if ([hug[@"mood"] isEqualToString:@"PARTY"]) {
        cell.layer.contents = (id)[UIImage imageNamed:@"party_bg"].CGImage;
    }
    cell.moodImage.image = [UIImage imageNamed:[hug[@"mood"] lowercaseString]];

    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hugs.count;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFQuery *query = [PFQuery queryWithClassName:@"Hugs"];
    [query whereKey:@"objectId" equalTo:_hugs[indexPath.row][@"hugid"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [object setObject:@(1) forKey:@"shown"];
                [object saveInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ReceiveController *rc = segue.destinationViewController;
    rc.message = _hugs[indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hugs.count == 2) {
        return ([UIScreen mainScreen].bounds.size.height-50)/2;
    }
    else {
        return ([UIScreen mainScreen].bounds.size.height-50)/3;
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
