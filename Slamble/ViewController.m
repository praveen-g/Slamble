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
@property HomePageViewController *homePage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homePage = [[HomePageViewController alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
//        [self presentViewController:self.homePage animated:YES completion:NULL];
    } else {
        // show the signup or login screen
    }
    

    
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


- (IBAction)loginButtonPressed:(id)sender{
    self.username = self.usernameSignIn.text;
    self.password = self.passwordSignIn.text;
    
    [PFUser logInWithUsernameInBackground:self.username password:self.password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Login is Success");
//                                            [self presentViewController:self.homePage animated:YES completion:NULL];
                                            // Do stuff after successful login.
                                        } else {
                                            NSLog(@"Login Failed");
                                            // The login failed. Check error to see why.
                                        }
                                    }];
    

}

- (IBAction)ForgotPasswordButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [PFUser requestPasswordResetForEmailInBackground:currentUser.email];
        // do stuff with the user
        //        [self presentViewController:self.homePage animated:YES completion:NULL];
    } else {
        // show the signup or login screen
    }

    [PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
}

 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
