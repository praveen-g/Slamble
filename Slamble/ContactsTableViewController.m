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
    [[UIImage imageNamed:@"backdrop3.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.automaticallyAdjustsScrollViewInsets=YES;
//    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
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
            //NSLog(@"numbers were saved");
            //            NSString  *number1= @"1111111111";
            //            NSString  *number2= @"6463217895";
            //            //NSArray * phones=[[NSArray alloc]init];
            //            NSArray *phones = @[ number1,number2];
            //            phones = @[number1,number2];
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
            }
            
            //Compare the contacts from the userto the contacts on Parse and get the user "Parse
            [PFCloud callFunctionInBackground:@"getContacts" withParameters:@{@"phoneNumbers":numbers} block:^(NSArray * object, NSError *error){
                if (!error) {
                    
                    //object is an array of dictionaries;
                    //NSLog(@"%@",object);
                    //NSLog(@"%lu",(unsigned long)object.count);
                    //                    NSMutableArray *contactsFirstName=[[NSMutableArray alloc]init];
                    //                    NSMutableArray *contactsLastName=[[NSMutableArray alloc]init];
                    //                    NSMutableArray *contactsUsername=[[NSMutableArray alloc]init];
                    for (NSInteger i=0;i < [object count]; i +=1) {
                        //NSLog(@"%ld",(long)i);
                        //                        NSLog(@"%@",object[i][@"firstName"]);
                        //                        NSLog(@"%@",object[i][@"lastName"]);
                        //                        NSLog(@"%@",object[i][@"username"]);
                        
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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"1");
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section==0) {
    //        return [self.contactsFirstName count];
    //
    //    }
    //    else{
    //        return 3;
    //    }
    //NSLog(@"row %lu",(unsigned long)[self.contactsFirstName count]);
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
    //cell.textLabel.text=[self.contactsFirstName objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    cell.detailTextLabel.text=userName;
    cell.detailTextLabel.textColor=[UIColor blueColor];
    
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = @"Contacts";
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    return headerView;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
