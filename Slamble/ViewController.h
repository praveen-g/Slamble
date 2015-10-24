//
//  ViewController.h
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameSignIn;
@property (strong, nonatomic) IBOutlet UITextField *passwordSignIn;
@property (weak, nonatomic) NSString*username;
@property (weak, nonatomic) NSString*password;



@end

