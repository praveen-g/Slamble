//
//  SignUpViewController.m
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "SignUpViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//    signUpViewController.delegate = self;
//    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional |PFSignUpFieldsEmail |PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
//    [self presentViewController:signUpViewController animated:YES completion:nil];

    
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)signUpButtonPressed:(id)sender {
    
    PFUser *user = [PFUser user];
    user[@"firstName"]= self.firstNameTextField.text;
    user[@"lastName"]= self.lastNameTextField.text;
    user.username = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    // other fields can be set if you want to save more information
    
    [self  checkFieldsComplete];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [PFUser logInWithUsernameInBackground:user.username
                                        password:user.password
                                        block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    NSLog(@"Login is Success");
                                                    [self performSegueWithIdentifier:@"goToHomePage" sender: self];
                                                    //                                            
                                                    // Do stuff after successful login.
                                                } else {
                                                    NSLog(@"Login Failed");
                                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
                                                                                                                   message:@"There was an issue with the app"
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                    
                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                          handler:^(UIAlertAction * action) {}];
                                                    
                                                    [alert addAction:defaultAction];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                                    // The login failed. Check error to see why.
                                                }
                                            }];
            

        } else {
            
            
              NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            
            NSLog(@"Signup Failed");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Attention!"
                                                                           message:errorString
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
}

-(void) checkFieldsComplete{
    if ([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""] ||[self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""])
        {
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Missing Information"
                                                                           message:@"Make sure you fill out all of the information!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
}
    
    
    //- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    //    BOOL informationComplete = YES;
    //    for (id key in info) {
    //        NSString *field = [info objectForKey:key];
    //        if (!field || field.length == 0) {
    //            informationComplete = NO;
    //            break;
    //        }
    //    }
    //
    //    if (!informationComplete) {
    //
    //
    //        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Missing Information"
    //                                                                       message:@"Make sure you fill out all of the information!"
    //                                                                preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
    //                                                              handler:^(UIAlertAction * action) {}];
    //
    //        [alert addAction:defaultAction];
    //        [self presentViewController:alert animated:YES completion:nil];
    //
    //    }
    //
    //    return informationComplete;
    //}
    //
    //// Sent to the delegate when a PFUser is signed up.
    //- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    //    [self dismissViewControllerAnimated:YES completion:NULL];
    //}
    //
    //// Sent to the delegate when the sign up attempt fails.
    //- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    //    NSLog(@"Failed to sign up...");
    //}
    //
    //// Sent to the delegate when the sign up screen is dismissed.
    //- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    //    NSLog(@"User dismissed the signUpViewController");
    //}
    
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end