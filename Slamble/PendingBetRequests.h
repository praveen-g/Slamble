//
//  PendingBetRequests.h
//  Slamble
//
//  Created by Praveen Gupta on 10/28/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingBetRequests : UITableViewController
@property(nonatomic,strong) NSString *currentUserName;
@property(nonatomic,strong) NSString *currentFirstName;
@property(nonatomic,strong) NSString *currentLastName;
@property NSInteger *countOfObjects;
@property(strong, nonatomic) NSMutableArray *listOfBets;
@property(strong, nonatomic) NSArray *better;
@property (strong, nonatomic) NSArray *noOfHours;
@property (strong, nonatomic) NSArray *betsCreatedAt;
@property(strong, nonatomic) NSArray *objectID;
@property(strong, nonatomic) NSArray *betterID;
@end
