//
//  BetsTableViewController.h
//  Slamble
//
//  Created by Claire Opila on 10/20/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetsTableViewController : UITableViewController
@property (strong, nonatomic) NSString *currentUserName;
@property (strong, nonatomic) NSString *currentUserId;
@property (strong, nonatomic) NSArray *sleeperObjects;
@property (strong, nonatomic) NSArray *betterObjects;
@property NSInteger *sleeperObjectCount;
@property NSInteger *betterObjectCount;
@property (strong, nonatomic) NSArray *betterArrBetsAgainst;
@property (strong, nonatomic) NSArray *betTimeArrBetsAgainst;
@property (strong, nonatomic) NSArray *sleeperArrBetsFor;
@property (strong, nonatomic) NSArray *betTimeBetsFor;
@property (strong, nonatomic) NSArray *createdAtBetsArrAgainst;
@property (strong, nonatomic) NSArray *createdAtBetsArrsFor;
@property (strong, nonatomic) NSArray *sleeperObjectsComplete;
@property (strong, nonatomic) NSArray *betterObjectsComplete;
@property (strong, nonatomic) NSArray *betterArrBetsAgainstComplete;
@property (strong, nonatomic) NSArray *betTimeArrBetsAgainstComplete;
@property (strong, nonatomic) NSArray *sleeperArrBetsForComplete;
@property (strong, nonatomic) NSArray *betTimeBetsForComplete;
@property (strong, nonatomic) NSArray *createdAtBetsArrAgainstComplete;
@property (strong, nonatomic) NSArray *createdAtBetsArrsForComplete;
@property (strong, nonatomic) NSArray *sleeperPointsBetsForComplete;
@property (strong, nonatomic) NSArray *betterPointsBetsForComplete;
@property (strong, nonatomic) NSArray *sleeperPointsBetsAgainstComplete;
@property (strong, nonatomic) NSArray *betterPointsBetsAgainstComplete;



@end
