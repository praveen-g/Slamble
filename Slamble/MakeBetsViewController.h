//
//  MakeBetsViewController.h
//  Slamble
//
//  Created by Claire Opila on 10/5/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeBetsViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *sleepHoursForBet;
@property (strong, nonatomic) IBOutlet UITextField *usernameForBet;
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSArray  *sleeperInfoArr;
@property (strong, nonatomic) NSString *sleeperId;


@end
