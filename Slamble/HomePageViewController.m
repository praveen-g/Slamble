//
//  HomePageViewController.m
//  Slamble
//
//  Created by Claire Opila on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName = [[PFUser currentUser] objectForKey:@"username"];
    NSLog(self.currentUserName);
    
   
}
- (IBAction)enterSleepButtonPressed:(id)sender {
    //taking input from user regarding sleep to validate bet
    long timeSlept = [self.amountSleptInput.text integerValue];
    NSLog(@"Timeslept: %ld", timeSlept);

    
//    [[PFUser currentUser] objectForKey:@"username"];
    PFQuery *query = [PFQuery queryWithClassName:@"betMade"];
    [query whereKey:@"username" equalTo:self.currentUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)objects.count);
            // Do something with the found objects
//        for (PFObject *object in objects) {
                NSArray *betValue= [objects valueForKey:@"betTime"];
                NSLog(@"BetValue: %@", betValue);
                NSString* betValueNew = [betValue objectAtIndex:0];
                long betValueNum = [betValueNew integerValue];
                NSLog(@"BetValueNUm: %ld", betValueNum);
//                NSArray *fromUser = [objects valueForKey:@"createdBy"];
////                NSString *fromUserName = [fromUser valueForKey:@"username"];
            
//                NSLog(@"Bet from User: %@", fromUser);
                if (betValueNum > timeSlept){
                    NSLog(@"You Lose");
                }
                else if (betValueNum == timeSlept){
                    NSLog(@"it's a draw");
                }
                else if (betValueNum < timeSlept){
                    NSLog(@"You Win");
                }
            
//            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    

 
}

- (IBAction)makeBetButtonPressed:(id)sender {
    //taking input from the user to create bet
    NSString * userNameForBet = self.usernameForBet.text;
    NSInteger hoursToSleepForBet = [self.sleepHoursForBet.text integerValue];
    NSString *hoursToSleepString = self.sleepHoursForBet.text;
    NSLog(@"username for bet: %@", userNameForBet);
    NSLog(@"hours to sleep for bet: %ld", hoursToSleepForBet);
    PFObject *betObject = [PFObject objectWithClassName:@"betMade"];
    [betObject setObject: userNameForBet forKey:@"username"];
    [betObject setObject:hoursToSleepString forKey:@"betTime"];
    [betObject setObject:[[PFUser currentUser] objectForKey:@"username"] forKey:@"userName"];
    [betObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error) {
             NSLog(@"saved bet object");
         } else{
             NSLog(@"Failed to save");
         }
     }];
    

}



- (IBAction)logOutButtonPressed:(id)sender {
    [PFUser logOut];
//    PFUser *currentUser = [PFUser currentUser];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
