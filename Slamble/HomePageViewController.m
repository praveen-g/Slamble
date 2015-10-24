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
    
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"night.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    

    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.amountSleptInput  setDelegate:self];
    
    // Do any additional setup after loading the view.
    // get the username of the current user and log it in the consol
//    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    NSLog(@"current userName is: %@",self.currentUserName);
    self.stringUserPoints = [[PFUser currentUser] objectForKey:@"points"];
    self.myPoints.text = self.stringUserPoints;
    self.pointsVal = [self.stringUserPoints integerValue];
    NSLog(@"user points value %ld", self.pointsVal);
    
    //declare variable for points value which we will keep in an object
    
    
   
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)enterSleepButtonPressed:(id)sender {
    //taking input from user regarding sleep to validate bet
    long timeSlept = [self.amountSleptInput.text integerValue];
    NSLog(@"Timeslept: %ld", timeSlept);

/*
//    [[PFUser currentUser] objectForKey:@"username"];
    // retreive betMade for current user
    PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
    [query whereKey:@"sleeper" equalTo:self.currentUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)objects.count);
            
            // parse the bet hours to compare to sleep input
            
            
            NSArray *betValue= [objects valueForKey:@"betTime"];
            NSLog(@"BetValue: %@", betValue);
            NSString* betValueNew = [betValue lastObject];
            long betValueNum = [betValueNew integerValue];
            NSArray * objectIdArray=[objects valueForKey:@"objectId"];
            NSLog(@"objectIdArray includes :%@",objectIdArray);
            self.objectId=[objectIdArray lastObject];
            NSLog(@"objectId is : %@",self.objectId);
            
            NSArray *createdAtArray=[objects valueForKey:@"createdAt"];
            NSLog(@"createdAtArray includes :%@",createdAtArray);
            self.createdAt=[createdAtArray lastObject];
            NSLog(@"createdAt is : %@",self.createdAt);
            [self.view endEditing:YES];
            self.amountSleptInput.text =nil;

            

            
                // compare the amount the user slept to the amount of hours in the bet
                if (betValueNum > timeSlept){
                    // if you slept less than the bet hours you lose
                    self.pointsVal -=1;
                    
                    NSLog(@"You Lose");
                    UIAlertController* alertLoss = [UIAlertController alertControllerWithTitle:@"You Lose"
                                                                                   message:@"Sleep More to beat your opponent next time!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alertLoss addAction:defaultAction];
                    [self presentViewController:alertLoss animated:YES completion:nil];
                    
                }
                else if (betValueNum == timeSlept){
                    self.pointsVal +=1;
                    //if you slept the same amount as the bet hours it's a draw
                    NSLog(@"it's a draw");
                    UIAlertController* alertTie = [UIAlertController alertControllerWithTitle:@"Tie!"
                                                                                   message:@"You AND your opponent benefit"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alertTie addAction:defaultAction];
                    [self presentViewController:alertTie animated:YES completion:nil];
                }
                else if (betValueNum < timeSlept){
                    self.pointsVal +=2;
                    
                    //if you slept more than the bet hours you win
                    NSLog(@"You Win");
                    UIAlertController* alertWin = [UIAlertController alertControllerWithTitle:@"You Won!"
                                                                                   message:@"Congratulations! You slept more than your opponent thought you would!"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alertWin addAction:defaultAction];
                    [self presentViewController:alertWin animated:YES completion:nil];
                }
            self.stringUserPoints = [NSString stringWithFormat:@"%ld", self.pointsVal];
            [[PFUser currentUser] setObject:self.stringUserPoints forKey:@"points"];
            NSLog(@"User points: %@", self.stringUserPoints);
            self.myPoints.text = self.stringUserPoints;
            
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been saved.
                    NSLog(@"userpoints has been saved and updated with: %@", self.stringUserPoints);
                } else {
                    // There was a problem, check error.description
                    NSLog(@"error is: %@", error);
                }
                
            }];
            
//            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"betClass"];
    [query2 whereKey:@"sleeper" equalTo:self.currentUserName];
    [query2 orderByDescending:@"createdAt"]; // this reverses the query2 order so that the latest bet with self.currentUserName as sleeper, UPDATE THIS AND CHECK
    [query2 getFirstObjectInBackgroundWithBlock:^(PFObject * betClassObject, NSError * error) {
        
        if(!error){
            //Found betClass
            [betClassObject setObject:self.amountSleptInput.text forKey:@"hoursSlept"];
            [betClassObject saveInBackground];
        }
        else{
            // Did not find any betClass for self.currentuserName
            NSLog(@"Error: %@",error);
        }
    }];
    
*/
    PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
    [query whereKey:@"sleeper" equalTo:self.currentUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)objects.count);
            
            // parse the bet hours to compare to sleep input
            
            
            NSArray *betValue= [objects valueForKey:@"betTime"];
            NSLog(@"BetValue: %@", betValue);
            //NSString* betValueNew = [betValue lastObject];
            //long betValueNum = [betValueNew integerValue];
            NSArray * objectIdArray=[objects valueForKey:@"objectId"];
            NSLog(@"objectIdArray includes :%@",objectIdArray);
            self.objectId=[objectIdArray firstObject];// objectIDarray displays objectID from most recent first to oldest last
            NSLog(@"objectId is : %@",self.objectId);
            
            /*
            NSArray *createdAtArray=[objects valueForKey:@"createdAt"];
            //NSLog(@"createdAtArray includes :%@",createdAtArray);
            self.createdAt=[createdAtArray lastObject];
            //NSLog(@"createdAt is : %@",self.createdAt);
            */
            
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"LALALALALALA DONT FUNK WITH MY HEART");
            //NSLog(@"self.objectd is:%@",self.objectId);
            PFQuery *query2 = [PFQuery queryWithClassName:@"betClass"];
            [query2 whereKey:@"objectId" equalTo:self.objectId];
            //[query2 orderByDescending:@"createdAt"]; // this reverses the query2 order so that the latest bet with self.currentUserName as sleeper, UPDATE THIS AND CHECK
            [query2 getFirstObjectInBackgroundWithBlock:^(PFObject * betClassObject, NSError * error) {
                
                if(!error){
                    //Found betClass
                    [betClassObject setObject:self.amountSleptInput.text forKey:@"hoursSlept"];
                    [betClassObject saveInBackground];
                }
                else{
                    // Did not find any betClass for self.currentuserName
                    NSLog(@"Error: %@",error);
                }
                
                
            }];
            //[PFCloud callFunctionInBackground:@"betWinner" withParameters:@{@"objectId":self.objectId}];
            [PFCloud callFunctionInBackground:@"betWinner2" withParameters:@{@"objectId":self.objectId}];
            
            
            
            
        });
        
    }];
    
    
    
    
}






- (IBAction)logOutButtonPressed:(id)sender {
    //lout out user
    [PFUser logOut];
    
    //go to initial page
    [self dismissViewControllerAnimated:YES completion:nil];

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

//create object for the current user for points, initially set to 0
//we don't want to create a points object every time a user logins
//    PFObject *pointsObject = [PFObject objectWithClassName:@"userPoints"];
//    [pointsObject setObject: self.currentUserName forKey:@"username"];
//    [pointsObject setObject:@0 forKey:@"Points"];;
//    [pointsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//     {
//         if (!error) {
//             NSLog(@"saved bet object");
//         } else{
//             NSLog(@"Failed to save");
//         }
//     }];

//-(void)queryUserPoints{
//    // a method to query user points and set the label equal to points
//    NSString *currentUserName = [PFUser currentUser] objectForKey:@"username"];
//    PFQuery *query = [PFQuery queryWithClassName:@"userPoints"];
//    [query whereKey:@"username" equalTo:currentUserName];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)objects.count);
//            // Do something with the found objects
//            //        for (PFObject *object in objects) {
//            NSArray *pointsArray= [objects valueForKey:@"Points"];
//            NSLog(@"Current Points are: %@", pointsArray);
//            NSString* pointsString = [pointsArray objectAtIndex:0];
//            long pointsVal = [pointsString integerValue];
//            NSLog(@"BetValueNUm: %ld", pointsVal);
//            self.myPoints.text = pointsString;
//            return pointsVal;
//            //                NSArray *fromUser = [objects valueForKey:@"createdBy"];
//            ////                NSString *fromUserName = [fromUser valueForKey:@"username"];
//
//            //              NSLog(@"Bet from User: %@", fromUser);
//
//        }
//
//        // Retrieve the object by id
//        else {
//            // Log details of the failure
//            NSLog(@"Error calling points: %@ %@", error, [error userInfo]);
//        }
//
//
//    }];
//
//}

@end
