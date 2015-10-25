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
    
    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.usernameForBet setDelegate:self];
    [self.sleepHoursForBet  setDelegate:self];
    
    // Do any additional setup after loading the view.
    //set username of current usr
    NSString *currentUserName = [[NSString alloc] init];
    currentUserName = [[PFUser currentUser] objectForKey:@"username"];
    NSLog(@"%@",currentUserName);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)makeBetButtonPressed:(id)sender {
    //take input from user for bet
    NSString * userNameForBet = self.usernameForBet.text;
    NSInteger hoursToSleepForBet = [self.sleepHoursForBet.text integerValue];
    NSString*hoursToSleepString = self.sleepHoursForBet.text;
    PFQuery *sleeperQuery = [PFUser query];
    [sleeperQuery whereKey:@"username" equalTo:self.usernameForBet.text];
    [sleeperQuery findObjectsInBackgroundWithBlock:^(NSArray *sleeperInfo, NSError *error){
        if (!error) {
            if(sleeperInfo.count > 0){
                // The find succeeded.
                NSLog(@"Successfully retrieved sleeperInfo %@", sleeperInfo);
                NSArray*sleeperIdArr = [sleeperInfo valueForKey:@"objectId"];
                self.sleeperId = sleeperIdArr[0];
                NSLog(@"sleeper id %@", self.sleeperId);
                PFObject *betObject = [PFObject objectWithClassName:@"betClass"];
                [betObject setObject: self.usernameForBet.text forKey:@"sleeper"];
                [betObject setObject: self.sleeperId forKey:@"sleeperId"];
                //    [betObject setObject: [[PFUser sleeperInfo] objectForKey:@"objectId"] forKey:@"sleeperId"];
                [betObject setObject:self.sleepHoursForBet.text forKey:@"betTime"];
                [betObject setObject:[[PFUser currentUser] objectForKey:@"username"] forKey:@"better"];
                [betObject setObject: [PFUser currentUser].objectId forKey:@"betterid"];
                [betObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (!error) {
                         //show if saving object was success with feedback to user
                         [self.view endEditing:YES];
                         NSLog(@"saved bet object");
                         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                                        message:@"Bet Sucess!"
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction * action) {}];
                         
                         [alert addAction:defaultAction];
                         [self presentViewController:alert animated:YES completion:nil];
                         self.usernameForBet.text = nil;
                         self.sleepHoursForBet.text = nil;
                         
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
            else if (sleeperInfo.count == 0){
                UIAlertController* alertFail = [UIAlertController alertControllerWithTitle:@"Uh Oh!"
                                                                                   message:@"Error: Please make sure you have the correct username!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alertFail addAction:defaultAction];
                [self presentViewController:alertFail animated:YES completion:nil];
                
            }
            // Do something with the found objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", error);
            UIAlertController* alertFail = [UIAlertController alertControllerWithTitle:@"Uh Oh!"
                                                                               message:@"Error: Please make sure you have the correct username!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alertFail addAction:defaultAction];
            [self presentViewController:alertFail animated:YES completion:nil];
            
        }
    }];
    //sending push notification to user with who bet has been initiated
    //betQuery used to find betters
    PFQuery *betQuery = [PFUser query];
    [betQuery whereKey:@"betStatus" equalTo:@"0"];
    
    //finding corresponding sleeper
    PFQuery *sleepQuery = [PFUser query];
    [sleepQuery whereKey:@"sleeper" matchesQuery:betQuery];
    
    //sending data in push
    NSDictionary *data = @{@"better":[[PFUser currentUser] objectForKey:@"username"], @"hoursToSleep":hoursToSleepString, @"betStatus": @"0"};
    //sending push notification
    PFPush *push = [PFPush new];
    [push setQuery:sleepQuery];
    [push setMessage:[@"you have been bet" stringByAppendingString:hoursToSleepString]];
    [push setData:data];
    [push sendPushInBackground];

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
