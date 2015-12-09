//
//  ContactsTableViewController.m
//  Slamble
//
//  Created by Francesco Perera on 11/8/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()

@end

@implementation ContactsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"slambleBackdrop.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.contactsArray=[[NSMutableArray alloc]init];
    self.contactsFirstName=[[NSMutableArray alloc]init];
    self.contactsLastName=[[NSMutableArray alloc]init];
    self.contactsUsername=[[NSMutableArray alloc]init];
    
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (!granted) return;
        
        NSString *containerId = store.defaultContainerIdentifier;
        NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
        //NSPredicate *predicate = [CNContact predicateForContactsMatchingName:@""];
        NSArray *contactsKeys = [NSArray arrayWithObjects:CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,nil];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.contactsArray=[NSMutableArray arrayWithArray:[store unifiedContactsMatchingPredicate:predicate keysToFetch:contactsKeys error:nil]];
            NSMutableArray *numbers = [[NSMutableArray alloc] init];
            for (CNContact *contact in self.contactsArray) {
                if (contact.phoneNumbers.count > 0) {
                    for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                        CNPhoneNumber *phoneNumber = [labeledValue value];
                        NSString*phoneNumberString=[phoneNumber stringValue];
                        NSString *formattedPhoneNumbers = [[phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                        if ([formattedPhoneNumbers characterAtIndex:0] == '1') {
                            formattedPhoneNumbers = [formattedPhoneNumbers substringFromIndex:1];
                        }
                        [numbers addObject:formattedPhoneNumbers];
                    }
                }
                NSLog(@"the phone numbers are : %@",numbers);
                NSLog(@"My contacts are :,%@",self.contactsArray);
            }
            
            //Compare the contacts from the userto the contacts on Parse and get the user "Parse
            [PFCloud callFunctionInBackground:@"getContacts" withParameters:@{@"phoneNumbers":numbers} block:^(NSArray * object, NSError *error){
                if (!error) {
                   
                    for (NSInteger i=0;i < [object count]; i +=1) {
                        [self.contactsFirstName addObject:object[i][@"firstName"]];
                        [self.contactsLastName addObject:object[i][@"lastName"]];
                        [self.contactsUsername addObject:object[i][@"username"]];
                        
                        
                    }
                    NSLog(@"%@",self.contactsFirstName);
                    NSLog(@"%@",self.contactsLastName);
                    NSLog(@"%@",self.contactsUsername);
                }
                [self.tableView reloadData];
            }];
            
            
        });
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    cell.textColor = [UIColor whiteColor];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"1");
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.contactsFirstName count];
}
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Contacts";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        
    }
    
    NSString * firstName=[self.contactsFirstName objectAtIndex:indexPath.row];
    NSString * lastName=[self.contactsLastName objectAtIndex:indexPath.row];
    NSString * userName=[self.contactsUsername objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text=userName;
    cell.detailTextLabel.textColor=[UIColor blueColor];
    
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:105 green:106 blue:104 alpha:.4];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:.7].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = @"Contacts";
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    return headerView;
}
@end
