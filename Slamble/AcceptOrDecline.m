//
//  AcceptOrDecline.m
//  Slamble
//
//  Created by Praveen Gupta on 10/25/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "AcceptOrDecline.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@implementation AcceptOrDecline
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUsername = [[PFUser currentUser]objectForKey:@"username"];
}


- (IBAction)declineButton:(id)sender {
    PFObject *obj = [PFObject objectWithClassName:@"betClass"];
    [obj setObject:@"2" forKey:@"betStatus"];
    
    PFQuery *decision = [PFQuery new];
    [decision whereKey:@"sleeper" equalTo: self.currentUsername];
    [decision whereKey:@"betStatus" equalTo:@"2"];
    
    PFQuery *reply = [PFQuery new];
    [reply whereKey:@"better" matchesQuery:decision];
    
    PFPush *push = [PFPush new];
    [push setQuery:reply];
    [push setMessage:@"Your bet has been declined"];
    [push sendPushInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)acceptButton:(id)sender {
    PFObject *obj = [PFObject objectWithClassName:@"betClass"];
    [obj setObject:@"1" forKey:@"betStatus"];
    
    PFQuery *decision = [PFQuery new];
    [decision whereKey:@"sleeper" equalTo: self.currentUsername];
    [decision whereKey:@"betStatus" equalTo:@"1"];
    
    PFQuery *reply = [PFQuery new];
    [reply whereKey:@"better" matchesQuery:decision];
    
    PFPush *push = [PFPush new];
    [push setQuery:reply];
    [push setMessage:@"Your bet has been accepted"];
    [push sendPushInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
