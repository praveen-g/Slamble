//
//  HomePageViewController.h
//  Slamble
//
//  Created by Claire Opila on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *amountSleptInput;
@property (strong, nonatomic) IBOutlet UITextField *usernameForBet;
@property (strong, nonatomic) IBOutlet UITextField *sleepHoursForBet;
@property (strong, nonatomic) NSString *currentUserName;
@end
