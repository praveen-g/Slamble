//
//  ContactsTableViewController.h
//  Slamble
//
//  Created by Francesco Perera on 11/8/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeBetsViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ContactsTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *contactsArray;
@property (strong,nonatomic) NSMutableArray *contactsFirstName;
@property (strong,nonatomic) NSMutableArray *contactsLastName;
@property (strong,nonatomic) NSMutableArray *contactsUsername;

@end
