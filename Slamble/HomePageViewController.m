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
    // Do any additional setup after loading the view.
    // get the username of the current user and log it in the consol
//    NSString *currentUserName = [[NSString alloc] init];
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    NSLog(@"current userName is: %@",self.currentUserName);
    
    //declare variable for points value which we will keep in an object
   
}
- (IBAction)enterSleepButtonPressed:(id)sender {
    //taking input from user regarding sleep to validate bet
    long timeSlept = [self.amountSleptInput.text integerValue];
    NSLog(@"Timeslept: %ld", timeSlept);

    
//    [[PFUser currentUser] objectForKey:@"username"];
    // retreive betMade for current user
    PFQuery *query = [PFQuery queryWithClassName:@"betMade"];
    [query whereKey:@"username" equalTo:self.currentUserName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)objects.count);
            
            // parse the bet hours to compare to sleep input
                NSArray *betValue= [objects valueForKey:@"betTime"];
                NSLog(@"BetValue: %@", betValue);
                NSString* betValueNew = [betValue lastObject];
                long betValueNum = [betValueNew integerValue];

            
                // compare the amount the user slept to the amount of hours in the bet
                if (betValueNum > timeSlept){
                    // if you slept less than the bet hours you lose
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
            
//            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
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
