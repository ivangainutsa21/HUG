//
//  SelectShareTableViewController.m
//  ValentineHug
//
//  Created by Prinz & Co. on 2015-01-28.
//  Copyright (c) 2015 App Universe. All rights reserved.
//

#import "SelectShareTableViewController.h"
#import "SimpleMenuCell.h"

@implementation SelectShareTableViewController{
    NSArray *items;
    NSArray *titles;
    NSArray *images;
}

-(void)viewDidLoad {
    titles = @[@"SHARE",@"FRIENDS",@"ACCOUNT"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height/3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.row == 1) {
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    }
    cell.mainLabel.text = titles[indexPath.row];
    return cell;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSString *string = @"Send HUG messages that you can feel!";
        NSURL *URL = [NSURL URLWithString:@"http://www.gethug.co/"];
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                          applicationActivities:nil];
        [self.navigationController presentViewController:activityViewController
                                           animated:YES
                                         completion:^{
                                             // ...
                                         }];
    }
    else if(indexPath.row == 1){
        [self performSegueWithIdentifier:@"contacts" sender:self];
    }
    else if (indexPath.row == 2){
        [self performSegueWithIdentifier:@"me" sender:self];
    }
}

@end
