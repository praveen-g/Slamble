//
//  PendingBetRequests.m
//  Slamble
//
//  Created by Praveen Gupta on 10/28/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "PendingBetRequests.h"
#import "BetsTableViewController.h"
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface PendingBetRequests()

@end

@implementation PendingBetRequests

- (void)viewDidLoad {
    [super viewDidLoad];
    //get list of active bet requests
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    PFQuery *query = [PFQuery queryWithClassName:@"betRequest"];
    [query whereKey:@"sleeperName" equalTo:self.currentUserName];
    [query whereKey:@"betStatus" equalTo:@"0"];
    self.listOfBets = [query findObjects];
    self.countOfObjects = self.listOfBets.count;
    NSLog(@"bet objects are: %@", self.listOfBets);
    
    //set a badge for the app depending on number of requests
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.listOfBets.count];
    
    // parses the bet objects into 3 arrays to present in the table view controller (the better, bet status, and created Date
    self.better= [self.listOfBets valueForKey:@"betterName"];
    self.noOfHours = [self.listOfBets valueForKey:@"betHours"];
    self.betsCreatedAt = [self.listOfBets valueForKey:@"createdAt"];
    self.objectID = [self.listOfBets valueForKey:@"objectId"];
    self.betterID = [self.listOfBets valueForKey:@"betterID"];
    //logs them for testing purposes
    NSLog(@"betterArray called: %@", self.better);
    NSLog(@"no of hours: %@", self.noOfHours);
    NSLog(@"cretedAt Bets Against called: %@", self.betsCreatedAt);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //returns the number of sections based on the number of bet objects for the sleeper array and better array
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section based on number of bets
    
    if (self.listOfBets.count == 0){
        return 1;
    }
    else {
        return self.listOfBets.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Active Bet Requests";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //The above dequeues a cell, but cell will be nil the first few times this method is called, so we create them here.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    //    cell.textLabel.textColor = [UIColor whiteColor];
    //    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    
    //if no bets exist
    if (self.listOfBets.count == 0){
        cell.textLabel.text = @"No Outstanding Bets Against You";
        cell.detailTextLabel.text = @"";
    }
    else{
        // first creates a string of the better
        NSString *labelText1 = [NSString stringWithFormat:@"%s%@", "You Were Bet By: ", self.better[indexPath.row]];
        //then creates a string of the hours bet
        NSString *detailText1 = [NSString stringWithFormat:@"%s%@%s", "To Sleep: ", self.noOfHours[indexPath.row], " hours"];
        cell.textLabel.text = labelText1;
        cell.detailTextLabel.text  = detailText1;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // creating the installation object for push
    //    PFInstallation *installation1 = [PFInstallation currentInstallation];
    //    [installation1 setObject:self.betterID[ind] forKey:@"username"];
    //    [installation1 setObject:[PFUser currentUser].objectId forKey:@"installationUserId"];
    //    [installation1 saveInBackground];
    //    NSLog(@"installation is: %@", installation1);
    
    
    UITableViewRowAction *accept = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Accept" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        [PFCloud callFunctionInBackground:@"sendPushNotificationsToBetter" withParameters:@{@"betterID":self.betterID ,@"objectId":self.objectID[indexPath.row], @"message": @"Your bet has been accepted", @"status": @"1"}];
                                        
                                    }];
    accept.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *decline = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Decline" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         [PFCloud callFunctionInBackground:@"sendPushNotificationsToBetter" withParameters:@{@"betterID":self.betterID,@"objectId":self.objectID[indexPath.row], @"message": @"Your bet has been declined", @"status": @"2"}];
                                     }];
    decline.backgroundColor = [UIColor greenColor];
    
    return @[accept, decline];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

