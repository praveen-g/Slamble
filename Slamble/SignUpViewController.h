//
//  SignUpViewController.h
//  Slamble
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

-(void) checkFieldsComplete;
+(BOOL)isValidEmailAddress:(NSString *)emailAddress;
+(BOOL)isValidPhoneNumber:(NSString *) phoneNumber;

+(void) send:(NSString *) firstName user:(NSString *) lastName information:(NSString *) username to:(NSString *) password Parse:(NSString *) email database:(NSString *) phoneNumber withClass:(NSString *) parseClass;
+(BOOL)function:(NSString *) firstName that:(NSString *) lastName checks:(NSString *) username that:(NSString *) password SignUp:(NSString *) email isValid:(NSString *) phoneNumber inClass:(NSString *) parseClass;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end
