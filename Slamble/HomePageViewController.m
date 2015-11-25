//
//  HomePageViewController.m
//  Slamble
//
//  Created by Claire Opila on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//
#import "PendingBetRequests.h"
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
    
  
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"cloudsNew.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    

    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.amountSleptInput  setDelegate:self];
//    AppDelegate *delegate =[[UIApplication sharedApplication] delegate];
    
    
    // Do any additional setup after loading the view.
    // get the username of the current user and log it in the consol
//    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
//    self.UserPoints = [[PFUser currentUser] objectForKey:@"points" integerValue];
    NSLog(@"firstName String is %@", firstName);
    self.welcomeLabel.text = [NSString stringWithFormat:@"%s%@%s", "Welcome ", firstName, "!"];
    NSLog(@"current userName is: %@",self.currentUserName);
    //declare variable for points value which we will keep in an object
    


   
}

-(void) viewDidAppear:(BOOL)animated{
//    self.UserPoints = [[[PFUser currentUser] objectForKey:@"points"] integerValue];
//    NSLog(@"user points are %@", [[PFUser currentUser] objectForKey:@"points"] );
//    self.stringUserPoints = [NSString stringWithFormat:@"%i", self.UserPoints];
//    self.myPoints.text = self.stringUserPoints;
//    //    self.pointsVal =  self.UserPoints;
//    NSLog(@"user points value %@", self.stringUserPoints);

//     counts the number of bets with a status of 0
    PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
    [query whereKey:@"sleeperId" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"betStatus" equalTo: @"0"];
    //    self.listOfBets = [query findObjects];
    [query findObjectsInBackgroundWithBlock:^(NSArray * pendingBets, NSError *error){
        if(!error){
            self.pendingBets.text =[NSString stringWithFormat:@"%lu", (unsigned long)pendingBets.count];
            NSLog(@"setting betsCount");
        }
        else{
            NSLog(@"error is %@", error);
        }
        //declare variable for points value which we will keep in an object
    }];
    
    
    [self updateLabelPoints];
    
    [super viewDidAppear:YES];
    
//    NSLog(@"user points view did appear are %@", [[PFUser currentUser] objectForKey:@"points"] );;
//    NSLog(@"user points view did appear with fetch are %@", [[[PFUser currentUser] fetch] objectForKey:@"points"]);
    

//    NSLog(@"userpoints points2 %ld", [[PFUser currentUser] objectForKey:@"points2"]);
}

-(void)registerToReceivePushNotification {
    // Register for push notifications
    UIApplication* application =[UIApplication sharedApplication];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)betRequestButtonPressed:(id)sender {
    }

- (IBAction)enterSleepButtonPressed:(id)sender {
    //taking input from user regarding sleep to validate bet
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *timeSlept = [f numberFromString:self.amountSleptInput.text];
    NSInteger timeSleptInt = [timeSlept integerValue];
    NSLog(@"Timeslept: %ld", timeSleptInt);
    
            //[PFCloud callFunctionInBackground:@"betWinner" withParameters:@{@"objectId":self.objectId}];
    if ([self.amountSleptInput.text isEqualToString:@""] || timeSleptInt < -1 || timeSleptInt > 14){
        UIAlertController* alertError = [UIAlertController alertControllerWithTitle:@"Ruh Roh!"
                                                                       message:@"Please enter a valid amount of time slept"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alertError addAction:defaultAction];
        [self presentViewController:alertError animated:YES completion:nil];
        
    }

        [PFCloud callFunctionInBackground:@"computeBetOutcomesForSleeper" withParameters:@{@"sleeperId":[PFUser currentUser].objectId, @"hoursSlept": self.amountSleptInput.text} block:^(NSNumber *newPoints, NSError * error) {
            
            if (error) {
                // handle it here
                 NSLog(@"error: %@", error);
                return;
            }
            NSLog(@"newpoints: %@", newPoints);
            
            NSString * userPointsAfterCalc = [NSString stringWithFormat:@"%@", newPoints];
            NSLog(@"userPointsAfterCalc: %@", userPointsAfterCalc);
//            NSString * userPointsAfterCalc =[object objectForKey:@"userPoints"];
            self.myPoints.text = userPointsAfterCalc;

            
        }];
//    [PFCloud callFunction:@"computeBetOutcomesForSleeper" withParameters:@{@"sleeperId":[PFUser currentUser].objectId, @"hoursSlept": self.amountSleptInput.text} ]

    
    PFObject *sleepObject = [PFObject objectWithClassName:@"Sleep"];
    //create bet object with the below field
    [sleepObject setObject: [[PFUser currentUser] objectForKey:@"firstName" ] forKey:@"firstName"];
    [sleepObject setObject: [[PFUser currentUser] objectForKey:@"lastName" ] forKey:@"lastName"];
    [sleepObject setObject: [PFUser currentUser].username forKey:@"username"];
     [sleepObject setObject: [PFUser currentUser].objectId forKey:@"userId"];
    [sleepObject setObject: timeSlept forKey:@"sleep"];
    
    //    [betObject setObject: [[PFUser sleeperInfo] objectForKey:@"objectId"] forKey:@"sleeperId"];
    [sleepObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             
             [sleepObject saveInBackground];
             //show if saving object was success with feedback to user
             [self.view endEditing:YES];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sleep Entered Successfully!"
                                                                            message:@"Let's Hope You Won Your Bets!"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
             self.amountSleptInput.text = nil;
         }
         else
         {
             //show bet creation failed  with feedback to user
             NSLog(@"Failed to save");
             UIAlertController* alertFail = [UIAlertController alertControllerWithTitle:@"Uh Oh!"
                                                                                message:@"Error: Please make sure you have entered a valid number of hours!"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {}];
             
             [alertFail addAction:defaultAction];
             [self presentViewController:alertFail animated:YES completion:nil];
         }
     }];


    [self updateLabelPoints];
    
    
    
    
}

-(void)updateLabelPoints{
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    //    self.listOfBets = [query findObjects];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * userInfo, NSError *error){
        if(!error){
            NSLog(@"userInfo is %@", userInfo);
            NSNumber  *pointsQuery =  [userInfo valueForKey:@"points"][0];
            NSLog(@"pointsQuery %@", pointsQuery);
            NSString *stringPointsQuery = [NSString stringWithFormat:@"%@", pointsQuery];
            self.myPoints.text = stringPointsQuery;
            
        }
        else{
            NSLog(@"error is %@", error);
        }
        //declare variable for points value which we will keep in an object
    }];
    
//
//    
//    self.UserPoints = [[[PFUser currentUser] objectForKey:@"points"] integerValue];
//    NSLog(@"user points are %@", [[PFUser currentUser] objectForKey:@"points"] );
//    self.stringUserPoints = [NSString stringWithFormat:@"%ld", self.UserPoints];
//    self.myPoints.text = self.stringUserPoints;
//    //    self.pointsVal =  self.UserPoints;
//    NSLog(@"user points value %@", self.stringUserPoints);
    
}






- (IBAction)logOutButtonPressed:(id)sender {
    //lout out user
    [PFUser logOut];
    
    //removing installation data upon logout creates issues logging the user in next time if you don't do so.
    PFInstallation *currentInstallation=[PFInstallation currentInstallation];
    [currentInstallation removeObjectForKey:@"currentUser"];
    [currentInstallation removeObjectForKey:@"username"];
    [currentInstallation removeObjectForKey:@"installationUserId"];
    [currentInstallation saveInBackground];

    [currentInstallation saveInBackground];
    
    
    //go to initial page
    [self dismissViewControllerAnimated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
