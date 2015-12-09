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

+(void) make:(NSString *)betterUsername bet:(NSString *)sleeperUsername withBetTime:(NSString *)hoursBet{
    PFQuery * query =[PFQuery queryWithClassName:@"signUpTest"];
    [query whereKey:@"username" equalTo:betterUsername];
    NSArray * better =  [query findObjects];
    NSLog(@" better:%@",better);
    NSString * betterId =better[0];
    NSLog(@"betterId is %@",betterId);
    [query whereKey:@"username" equalTo:sleeperUsername];
    NSArray * sleeper =  [query findObjects];
    NSLog(@" sleeper:%@",sleeper);
    NSString * sleeperId =sleeper[0];
    NSLog(@"betterId is %@",sleeperId);
    
    PFObject * testBet=[PFObject objectWithClassName:@"TestBet"];
    [testBet setObject:betterUsername forKey:@"better"];
    [testBet setObject:sleeperUsername forKey:@"sleeper"];
    [testBet setObject:betterId forKey:@"betterID"];
    [testBet setObject:sleeperId forKey:@"sleeperID"];
    [testBet setObject:hoursBet forKey:@"betTime"];
    [testBet setObject:@"0" forKey:@"betStatus"];
    [testBet saveInBackground];

}
+(BOOL) test:(NSString *)betterUsername bet:(NSString *)sleeperUsername logic:(NSString *)hoursBet inClass:(NSString *)betClass {
    [self make:betterUsername bet:sleeperUsername withBetTime:hoursBet];
    
    PFQuery * testBetQuery = [PFQuery queryWithClassName:betClass];
    NSLog(@"query started");
    [testBetQuery whereKey:@"better" equalTo:betterUsername];
    NSArray *betObject = [testBetQuery findObjects];
    NSLog(@"found object");
    NSLog(@" object has %lu items",(unsigned long)[betObject count]);
    
    
    if ([betObject count]) {
        NSLog(@"true");
        return true;
        
        
    }
    else{
        NSLog(@"false");
        return false;
        
    }
    
    
}

    
    
    


- (void)viewDidLoad {
    [super viewDidLoad];
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"slambleBackdrop.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.usernameForBet setDelegate:self];
    [self.sleepHoursForBet  setDelegate:self];
    
    // Do any additional setup after loading the view.
    //set username of current usr
    self.currentUserName = [[NSString alloc] init];
    self.currentUserName = [[PFUser currentUser] objectForKey:@"username"];
    NSLog(@"%@",self.currentUserName);
    self.currentUserFirstName = [[NSString alloc] init];
    self.currentUserFirstName = [[PFUser currentUser] objectForKey:@"firstName"];
    self.currentUserLastName = [[NSString alloc] init];
    self.currentUserLastName = [[PFUser currentUser] objectForKey:@"lastName"];
    NSLog(@"%@",self.currentUserFirstName);
    NSLog(@"%@",self.currentUserLastName);
    NSLog(@"the user's name is: %@%@%@", self.currentUserFirstName, @" ", self.currentUserLastName);
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
    NSDictionary *data = @{@"better":[[PFUser currentUser] objectForKey:@"username"], @"hoursToSleep":hoursToSleepString, @"betStatus": @"0"};
    
    // query to find the sleeper user's object id
    PFQuery *sleeperQuery = [PFUser query];
    [sleeperQuery whereKey:@"username" equalTo:self.usernameForBet.text];
    [sleeperQuery findObjectsInBackgroundWithBlock:^(NSArray *sleeperInfo, NSError *error){
        // if no error
        if (!error) {
            // and if a user was found set the sleeper id of the sleeper in the bet object
            if(sleeperInfo.count > 0){
                // The find succeeded.
                NSLog(@"Successfully retrieved sleeperInfo %@", sleeperInfo);
                NSArray*sleeperIdArr = [sleeperInfo valueForKey:@"objectId"];
                self.sleeperId = sleeperIdArr[0];
                NSLog(@"sleeper id %@", self.sleeperId);
                
                //


                PFObject *betRequest = [PFObject objectWithClassName:@"betRequest"];
                //create bet object with the below fields
                PFObject *betObject = [PFObject objectWithClassName:@"betClass"];
                [betObject setObject: self.usernameForBet.text forKey:@"sleeper"];
                [betObject setObject: self.sleeperId forKey:@"sleeperId"];
                //    [betObject setObject: [[PFUser sleeperInfo] objectForKey:@"objectId"] forKey:@"sleeperId"];
                [betObject setObject:self.sleepHoursForBet.text forKey:@"betTime"];
                [betObject setObject:[[PFUser currentUser] objectForKey:@"username"] forKey:@"better"];
                [betObject setObject: [PFUser currentUser].objectId forKey:@"betterid"];
                [betObject setValue:@"0" forKey:@"betStatus"];
                [betObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                     if (!error) {
                         
                         [betRequest setObject:[[PFUser currentUser] objectForKey:@"username"] forKey:@"betterName"];
                         [betRequest setObject: self.usernameForBet.text forKey:@"sleeperName"];
                         [betRequest setObject:@"0" forKey:@"betStatus"];
                         [betRequest saveInBackground];
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
                         
                         NSString* message = [NSString stringWithFormat:@"%s%@%s%@%@%@%@", "You have been bet by ", self.currentUserFirstName, "", self.currentUserLastName, @" to sleep ", hoursToSleepString, @" hours"];
                         [self.view endEditing:YES];
                         NSLog(@"message to send via push is %@", message);
                         [PFCloud callFunctionInBackground:@"sendPushNotificationsToSleeper" withParameters:@{@"sleeperId": self.sleeperId, @"message": message}];                      
    
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
                // if no user found with that username, notify the user that they need to check the username they are betting
                UIAlertController* alertFail = [UIAlertController alertControllerWithTitle:@"Uh Oh!"
                                                                                   message:@"Error: Please make sure you have the correct username!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alertFail addAction:defaultAction];
                [self presentViewController:alertFail animated:YES completion:nil];
                
            }
        } else {
            // Log details of the failure, and alert the user that there was an error retriveing the user with that username 
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



}

- (IBAction)viewContactsButtonPressed:(id)sender {
 
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
