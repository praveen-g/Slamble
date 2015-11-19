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

+ (BOOL)isValidEmailAddress:(NSString *)emailAddress {
    
    //Create a regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    
    //Create predicate with format matching your regex string
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    //return true if email address is valid, value of 0= False, 1=True
    return [emailTest evaluateWithObject:emailAddress];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([PFUser currentUser]) {
//        [self performSegueWithIdentifier:@"goToHomePage" sender: self];
//        
//    };
    
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"cloudsNew.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    //set the text field delegate as self so you hit return to dismiss keyboard 
    [self.firstNameTextField setDelegate:self];
    [self.lastNameTextField setDelegate:self];
    [self.userNameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    [self.emailTextField setDelegate:self];
    [self.phoneTextField setDelegate:self];
    
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"night.jpg"]];
    //[self.view addSubview:backgroundView];
    
//    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//    signUpViewController.delegate = self;
//    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional |PFSignUpFieldsEmail |PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
//    [self presentViewController:signUpViewController animated:YES completion:nil];

    
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void) viewDidAppear:(BOOL)animated{
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"goToHomePage" sender: self];
    };
}


- (IBAction)signUpButtonPressed:(id)sender {
    
    //Testing if email is valid
    
    [SignUpViewController isValidEmailAddress:self.emailTextField.text];
    NSLog(@"%d",[SignUpViewController isValidEmailAddress:self.emailTextField.text]);
    
    //create new user with userinputs
    PFUser *user = [PFUser user];
    user[@"firstName"]= self.firstNameTextField.text;
    user[@"lastName"]= self.lastNameTextField.text;
    user.username = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    user[@"points"] = @0;
    user[@"phone"]= self.phoneTextField.text;
    
    // other fields can be set if you want to save more information
    
    //check all fields are complete, and if not show aler
    [self  checkFieldsComplete];
    
    //if user sign up was a success, log the user in
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [PFUser logInWithUsernameInBackground:user.username
                                        password:user.password
                                        block:^(PFUser *user, NSError *error) {
                                            //if login was a success go to homePage
                                                if (user) {
                                                    NSLog(@"Login is Success");
                                                    [self.view endEditing:YES];
                                                    
                                                    //updating the installation with user information to target for push notifications
                                                    PFInstallation *currentInstallation=[PFInstallation currentInstallation];
                                                    currentInstallation[@"currentUser"]=[PFUser currentUser];
                                                    [currentInstallation setObject:[PFUser currentUser].username forKey:@"username"];
                                                    [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"installationUserId"];
                                                    [currentInstallation saveInBackground];
                                                    [self performSegueWithIdentifier:@"goToHomePage" sender: self];
                                                    
                                                    //                                            
                                                    // Do stuff after successful login.
                                                } else {
                                                    //show an alert that login failed
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
            //if sign up failed, show an alert that it failed
            
            
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
    //method to check if fields are complete, and not blank
    //if fields are not complete, it presents an alert
    if ([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""] ||[self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""] || [self.phoneTextField.text isEqualToString:@""])
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