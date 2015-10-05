//
//  ViewController.m
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "ViewController.h"
#import "HomePageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <Parse/PFUser.h>
#import <ParseUI/ParseUI.h>
//#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFUser *currentUser = [PFUser currentUser];
//    if (currentUser) {
//        [self performSegueWithIdentifier:@"homePage" sender: self];
//        // do stuff with the user
////        [self presentViewController:self.homePage animated:YES completion:NULL];
//    } else {
//        // show the signup or login screen
//    }
    

    
//    PFLogInViewController *login = [[PFLogInViewController alloc]init];
////        [self presentViewController:login animated:YES completion:nil];
//    login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook | PFLogInFieldsPasswordForgotten  | PFLogInFieldsDismissButton;
//    login.delegate = self;
//    login.facebookPermissions = @[@"public_profile", @"email", @"user_friends"];
//
//[self presentViewController:login animated:YES completion:NULL];

    
//    [login release];
        // Do any additional setup after loading the view, typically from a nib.
    
    
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =@[@"public_profile", @"email", @"user_friends"];
    
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:@"public_profile", @"email", @"user_friends" block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];
    
    
}


- (IBAction)LoginButtonPressed:(id)sender{
    self.username = self.usernameSignIn.text;
    self.password = self.passwordSignIn.text;
    
    
    [PFUser logInWithUsernameInBackground:self.username
                                 password:self.password
                                    block:^(PFUser *user, NSError *error) {
                                        if (!error) {
                                            NSLog(@"Login is Success");
                                            //                                          ;
                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:@"homePage" sender: self];
                                            self.usernameSignIn.text = nil;
                                            self.passwordSignIn.text = nil;
                                        }
                                        else{
                                            NSLog(@"Login Failed");
                                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                                                           message:@"Please Check Credentials and Try Again"
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                  handler:^(UIAlertAction * action) {}];
                                            
                                            [alert addAction:defaultAction];
                                            [self presentViewController:alert animated:YES completion:nil];

                                            // The login failed. Check error to see why.
                                        }
                                    }];


    
                                            // The login failed. Check error to see why.
    
    
}


//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    PFLogInViewController *login = [[PFLogInViewController alloc]init];
//    [self presentViewController:login animated:YES completion:nil];
//    login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook | PFLogInFieldsPasswordForgotten  | PFLogInFieldsDismissButton;
//    login.delegate = self;
//    login.facebookPermissions = @[@"public_profile", @"email", @"user_friends"];
//}

//- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
//    if (username && password && username.length && password.length) {
//        return YES;
//    }
//    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Missing Information"
//                                                                   message:@"Make sure you fill out all of the information!"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
//    return NO;
//}


//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
////    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self presentViewController: self.homePage animated:(YES) completion:nil];
//}
//
//// Sent to the delegate when the log in attempt fails.
//- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
//    
//       NSLog(@"Failed to log in...");
//}
//
//// Sent to the delegate when the log in screen is dismissed.
//- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
//    NSLog(@"User dismissed the logInViewController");
//}


 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
