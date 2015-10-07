//
//  MakeBetsViewController.m
//  Slamble
//
//  Created by Claire Opila on 10/5/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "MakeBetsViewController.h"
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MakeBetsViewController ()

@end

@implementation MakeBetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"night.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Do any additional setup after loading the view.
    //set username of current usr
    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName = [[PFUser currentUser] objectForKey:@"username"];
    NSLog(self.currentUserName);
}

- (IBAction)makeBetButtonPressed:(id)sender {
    //take input from user for bet
    NSString * userNameForBet = self.usernameForBet.text;
    NSInteger hoursToSleepForBet = [self.sleepHoursForBet.text integerValue];
    NSString *hoursToSleepString = self.sleepHoursForBet.text;
    
    //log the information
    NSLog(@"username for bet: %@", userNameForBet);
    NSLog(@"hours to sleep for bet: %ld", hoursToSleepForBet);
    
    //create bet with user inputs
    PFObject *betObject = [PFObject objectWithClassName:@"betMade"];
    [betObject setObject: userNameForBet forKey:@"username"];
    [betObject setObject:hoursToSleepString forKey:@"betTime"];
    [betObject setObject:[[PFUser currentUser] objectForKey:@"username"] forKey:@"userName"];
    [betObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error) {
             //show if saving object was success with feedback to user
             NSLog(@"saved bet object");
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                            message:@"Bet Sucess!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         } else{
             //show bet creation failed  with feedback to user
             NSLog(@"Failed to save");
             NSLog(@"saved bet object");
             UIAlertController* alertFail = [UIAlertController alertControllerWithTitle:@"Uh Oh!"
                                                                            message:@"Error: Please make sure you have the correct username!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alertFail addAction:defaultAction];
             [self presentViewController:alertFail animated:YES completion:nil];
         }
     }];

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
