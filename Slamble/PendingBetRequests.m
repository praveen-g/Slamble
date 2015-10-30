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
    
    //initialize array for list of bets that have not been validated yet
    self.listOfBets =[[NSArray alloc]init];
    self.currentFirstName = [[NSString alloc] init];
    self.currentLastName = [[NSString alloc] init];
    
    //get current username
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    NSString * userId= [PFUser currentUser].objectId;
    NSLog(@"current user ID is %@", userId);
    PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
    [query whereKey:@"sleeperId" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"betStatus" equalTo: @"0"];
//    self.listOfBets = [query findObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray * pendingBets, NSError *error){
        if(!error){
            self.listOfBets = pendingBets;
//            self.countOfObjects = self.listOfBets.count;
            NSLog(@"bet objects are: %@", self.listOfBets);
            NSLog(@"number of bet objects are: %lu", (unsigned long)self.listOfBets.count);
            //set a badge for the app depending on number of requests
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.listOfBets.count];
            
            // parses the bet objects into 3 arrays to present in the table view controller (the better, bet status, and created Date
            self.better= [self.listOfBets valueForKey:@"better"];
            self.noOfHours = [self.listOfBets valueForKey:@"betTime"];
            self.betsCreatedAt = [self.listOfBets valueForKey:@"createdAt"];
            self.objectID = [self.listOfBets valueForKey:@"objectId"];
            self.betterID = [self.listOfBets valueForKey:@"betterid"];
            //logs them for testing purposes
            NSLog(@"betterArray called: %@", self.better);
            NSLog(@"no of hours: %@", self.noOfHours);
            NSLog(@"cretedAt Bets Against called: %@", self.betsCreatedAt);
            NSLog(@"no of hours: %@", self.objectID);
            NSLog(@"cretedAt Bets Against called: %@", self.betterID);
            [self.tableView reloadData];
        }
        else{
            NSLog(@"error %@", error);
        }
    }];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
//        //            [query2 whereKey:@"objectId" equalTo:self.objectId];
//        [query whereKey:@"sleeperId" equalTo:[PFUser currentUser].objectId];
//        [query whereKey:@"betStatus" equalTo: @"0"];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *pendingBetObjects, NSError * error) {
//            if(!error){
//                self.listOfBets = pendingBetObjects;
//                NSLog(@"bet objects are: %@", self.listOfBets);
//                NSLog(@"bet objects are: %lu", (unsigned long)self.listOfBets.count);
//                //set a badge for the app depending on number of requests
//                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.listOfBets.count];
//                
//                // parses the bet objects into 3 arrays to present in the table view controller (the better, bet status, and created Date
//                self.better= [self.listOfBets valueForKey:@"better"];
//                self.noOfHours = [self.listOfBets valueForKey:@"betTime"];
//                self.betsCreatedAt = [self.listOfBets valueForKey:@"createdAt"];
//                self.objectID = [self.listOfBets valueForKey:@"objectId"];
//                self.betterID = [self.listOfBets valueForKey:@"betterid"];
//                //logs them for testing purposes
//                NSLog(@"betterArray called: %@", self.better);
//                NSLog(@"no of hours: %@", self.noOfHours);
//                NSLog(@"cretedAt Bets Against called: %@", self.betsCreatedAt);
//                NSLog(@"no of hours: %@", self.objectID);
//                NSLog(@"cretedAt Bets Against called: %@", self.betterID);
//
//                }
//         else{
//                // Did not find any betClass for self.currentuserName
//                NSLog(@"Error: %@",error);
//            }
//        }];
//        //[PFCloud callFunctionInBackground:@"betWinner" withParameters:@{@"objectId":self.objectId}];
//        [self.tableView reloadData];
//    });
//    

    
    
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
//        NSLog(@"bet counts for rows in section are %@", self.listOfBets.count);
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
//    NSLog(@"sefl.listofBets.count used in cell foramtting is: %@", self.listOfBets.count);
    if (self.listOfBets.count == 0){
        cell.textLabel.text = @"No Outstanding Bets Against You";
        cell.detailTextLabel.text = @"";
    }
    else{
        // first creates a string of the better
        NSString *labelText1 = [NSString stringWithFormat:@"%s%@", "You Were Bet By: ", self.better[indexPath.row]];
        //then creates a string of the hours bet
        NSString *detailText1 = [NSString stringWithFormat:@"%s%@%s", "To Sleep: ", self.noOfHours[indexPath.row], " hours"];
        NSLog(@"labeltexet1 %@", labelText1);
        NSLog(@"detailtext2 %@", detailText1);
        cell.textLabel.text = labelText1;
        cell.detailTextLabel.text  = detailText1;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listOfBets.count == 0){
        return NO;
    }
    else{
        return YES;
    }
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
                                        NSString* messageAccept = [NSString stringWithFormat:@"%s%@%s%@%@%@%@", "Your bet to ", self.currentFirstName, "", self.currentLastName, @" to sleep ", self.noOfHours[indexPath.row], @" hours has been accepted"];
                                        
                                        [PFCloud callFunctionInBackground:@"sendPushNotificationsToBetter" withParameters:@{@"betterID":self.betterID[indexPath.row] ,@"objectID":self.objectID[indexPath.row], @"message": messageAccept, @"betStatus": @"1"}];
                                        
                                    }];
    accept.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *decline = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Decline" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSString* messageDecline = [NSString stringWithFormat:@"%s%@%s%@%@%@%@", "Your bet to ", self.currentFirstName, "", self.currentLastName, @" to sleep ", self.noOfHours[indexPath.row], @" hours has been declined"];
                                         
                                         [PFCloud callFunctionInBackground:@"sendPushNotificationsToBetter" withParameters:@{@"betterID":self.betterID[indexPath.row], @"objectID":self.objectID[indexPath.row], @"message": messageDecline, @"betStatus": @"2"}];
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
