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
    [[UIImage imageNamed:@"night.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    

    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.amountSleptInput  setDelegate:self];
//    AppDelegate *delegate =[[UIApplication sharedApplication] delegate];
    
//    PFInstallation *installation = [PFInstallation currentInstallation];
//    [installation setObject:[PFUser currentUser].username forKey:@"username"];
//    [installation setObject:[PFUser currentUser].objectId forKey:@"installationUserId"];;
//    [installation saveInBackground];
//    NSLog(@"installation is: %@", installation);
    
    // Do any additional setup after loading the view.
    // get the username of the current user and log it in the consol
//    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    NSLog(@"current userName is: %@",self.currentUserName);
    self.UserPoints = [[[PFUser currentUser] objectForKey:@"points"] integerValue];
    self.stringUserPoints = [NSString stringWithFormat:@"%i", self.UserPoints];
    self.myPoints.text = self.stringUserPoints;
    self.pointsVal =  self.UserPoints;
    NSLog(@"user points value %ld", self.pointsVal);
    
    //declare variable for points value which we will keep in an object
    

    
   
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
    long timeSlept = [self.amountSleptInput.text integerValue];
    NSLog(@"Timeslept: %ld", timeSlept);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"LALALALALALA DONT FUNK WITH MY HEART");
        //NSLog(@"self.objectd is:%@",self.objectId);
        PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
        //            [query2 whereKey:@"objectId" equalTo:self.objectId];
        [query whereKey:@"sleeperId" equalTo:[PFUser currentUser].objectId];
        //[query2 orderByDescending:@"createdAt"]; // this reverses the query2 order so that the latest bet with self.currentUserName as sleeper, UPDATE THIS AND CHECK
        //            [query2 getFirstObjectInBackgroundWithBlock:^(PFObject * betClassObject, NSError * error) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *betObjects, NSError * error) {
            if(!error){
                //Found betClass
                for (PFObject *bet in betObjects) {
                    [bet setObject:self.amountSleptInput.text forKey:@"hoursSlept"];
                    [bet saveInBackground];
                }
            }
            else{
                // Did not find any betClass for self.currentuserName
                NSLog(@"Error: %@",error);
            }
        }];
        //[PFCloud callFunctionInBackground:@"betWinner" withParameters:@{@"objectId":self.objectId}];
        [PFCloud callFunctionInBackground:@"computeBetOutcomesForSleeper" withParameters:@{@"sleeperId":[PFUser currentUser].objectId}];
    });
    
    
    
    
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
