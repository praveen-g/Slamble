//
//  SignUpViewController.m
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *user = [PFUser user];
    user.username = self.nameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    // other fields can be set if you want to save more information
    user[@"phone"] = @"650-555-0000";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            //  NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end