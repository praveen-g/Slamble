//
//  HomePageViewController.h
//  Slamble
//
//  Created by Claire Opila on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *amountSleptInput;
@property (strong, nonatomic) IBOutlet UITextField *usernameForBet;
@property (strong, nonatomic) IBOutlet UITextField *sleepHoursForBet;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) IBOutlet UILabel *myPoints;
@property long pointsVal;
@property (strong, nonatomic) NSArray *objectIdArray;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *createdAt;
@property int UserPoints;
@property (strong, nonatomic) NSString *stringUserPoints;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *pendingBets;
//-(void) queryUserPoints;
@end
