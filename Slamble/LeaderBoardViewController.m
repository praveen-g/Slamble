//
//  LeaderBoardViewController.m
//  Slamble
//
//  Created by Claire Opila on 12/8/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LeaderBoardViewController ()

@end

@implementation LeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"slambleBackdrop.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.automaticallyAdjustsScrollViewInsets=YES;
    
     self.leaders = [[NSArray alloc] init];
    
    //Parallax
    //Min and Max Values
    CGFloat topBottomMin=-55.0f;
    CGFloat topBottomMAx=55.0f;
    
    //Motion Effect
    UIInterpolatingMotionEffect *topBottom= [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    topBottom.minimumRelativeValue=@(topBottomMin);
    topBottom.maximumRelativeValue=@(topBottomMAx);
    
    //Create motion effect group
    UIMotionEffectGroup *neGroup = [[UIMotionEffectGroup alloc]init];
    neGroup.motionEffects = @[topBottom];
    
    //Add motion effect group to our imageView
    [self.tableView addMotionEffect:neGroup];
    
    //returns an array of top leaders for leaderboad. 
    [PFCloud callFunctionInBackground:@"getLeaders" withParameters:nil block:^(NSArray *leaderBoardArr, NSError * error) {
        if (error) {
            // handle it here
            NSLog(@"error: %@", error);
            return;
        }
        NSLog(@"leaderBoardArr: %@", leaderBoardArr);
        
        self.leaders = leaderBoardArr;
        [self.tableView reloadData];
        
    }];
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //returns the number of sections based on the number of bet objects for the sleeper array and better array
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section based on the length of each array, or the number of bets
    
    return self.leaders.count;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:155 green:155 blue:155 alpha:.4];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:.7].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    headerLabel.text = @"Leader Board";
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //The above dequeues a cell, but cell will be nil the first few times this method is called, so we create them here.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        //Note that the firs time through we used UITableViewCellStyleDefault
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text =self.leaders[indexPath.row];
            
         
    
    return cell;
}

@end
