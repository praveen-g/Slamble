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
#import <QuartzCore/QuartzCore.h>

//#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this code adds the background image across the entire screen
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"night.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //set the text field delegate as self so you hit return to dismiss keyboard
    [self.usernameSignIn setDelegate:self];
    [self.passwordSignIn setDelegate:self];
    
//    if ([PFUser currentUser]) {
//        [self performSegueWithIdentifier:@"homePage" sender: self];
//    };

    
    

    
//present facebook sign in button
    
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
//    
    
}


-(void) viewDidAppear:(BOOL)animated{
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"homePage" sender: self];
    };
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)LoginButtonPressed:(id)sender{
    //set the username and password inputs
    self.username = self.usernameSignIn.text;
    self.password = self.passwordSignIn.text;
    NSLog(@"self.username.text entered: %@", self.usernameSignIn.text);
    NSLog(@"self.password.text entered: %@", self.passwordSignIn.text);
    NSLog(@"self.username entered: %@", self.username);
    NSLog(@"self.password entered: %@", self.password);
    
    
    //initiate login with username and password
    [PFUser logInWithUsernameInBackground:self.usernameSignIn.text
                                 password:self.passwordSignIn.text
                                    block:^(PFUser *user, NSError *error) {
                                        //if no error , take them to the home page
                                        if (!error) {
                                            NSLog(@"Login is Success");
                                            //                                          ;
                                            // Do stuff after successful login.
                                            [self performSegueWithIdentifier:@"homePage" sender: self];
                                            self.usernameSignIn.text = nil;
                                            self.passwordSignIn.text = nil;
                                            
                                            //updating the installation once the user is logged in
                                            PFInstallation *currentInstallation=[PFInstallation currentInstallation];
                                            currentInstallation[@"currentUser"]=[PFUser currentUser];
                                            [currentInstallation setObject:[PFUser currentUser].username forKey:@"username"];
                                            [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"installationUserId"];
                                            [currentInstallation saveInBackground];

                                            
                                            [self.view endEditing:YES];
                                            
                                        }
                                        else if (error){
                                            //if error, show them an alert and ask them to check credentials
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



 - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
