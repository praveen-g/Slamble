//
//  BetsTableViewController.m
//  Slamble
//
//  Created by Claire Opila on 10/20/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import "BetsTableViewController.h"
#import "HomePageViewController.h"
#import "SignUpViewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface BetsTableViewController ()

@end

@implementation BetsTableViewController

+(void) test:(NSString *)betterUsername bet:(NSString *)sleeperUsername outcome:(NSString *)hoursBet withHoursSlept:(NSString *)hoursSlept{
    int hB = [hoursBet intValue];
    int hS = [hoursSlept intValue];
    
    if (hB > hS) {
        NSNumber * betterPoints = [NSNumber numberWithInt:2];
        NSNumber * sleeperPoints = [NSNumber numberWithInt:-1];
        NSString * bPoints = [NSString stringWithFormat:@"%@",betterPoints];
        NSString * sPoints =[NSString stringWithFormat:@"%@",sleeperPoints];
        PFObject * testBet=[PFObject objectWithClassName:@"TestBet"];
        [testBet setObject:betterUsername forKey:@"better"];
        [testBet setObject:sleeperUsername forKey:@"sleeper"];
        [testBet setObject:hoursBet forKey:@"betTime"];
        [testBet setObject:hoursSlept forKey:@"hoursSlept"];
        [testBet setObject:@"0" forKey:@"betStatus"];
        [testBet setObject:bPoints forKey:@"betterPoints"];
        [testBet setObject:sPoints forKey:@"sleeperPoints"];
        [testBet saveInBackground];
        
        
    }
    else if (hB == hS){
        NSNumber * betterPoints = [NSNumber numberWithInt:1];
        NSNumber * sleeperPoints = [NSNumber numberWithInt:1];
        NSString * bPoints = [NSString stringWithFormat:@"%@",betterPoints];
        NSString * sPoints =[NSString stringWithFormat:@"%@",sleeperPoints];
        PFObject * testBet=[PFObject objectWithClassName:@"TestBet"];
        [testBet setObject:betterUsername forKey:@"better"];
        [testBet setObject:sleeperUsername forKey:@"sleeper"];
        [testBet setObject:hoursBet forKey:@"betTime"];
        [testBet setObject:hoursSlept forKey:@"hoursSlept"];
        [testBet setObject:@"0" forKey:@"betStatus"];
        [testBet setObject:bPoints forKey:@"betterPoints"];
        [testBet setObject:sPoints forKey:@"sleeperPoints"];
        [testBet saveInBackground];
        
        
    }
    else{
        NSNumber * betterPoints = [NSNumber numberWithInt:0];
        NSNumber * sleeperPoints = [NSNumber numberWithInt:2];
        NSString * bPoints = [NSString stringWithFormat:@"%@",betterPoints];
        NSString * sPoints =[NSString stringWithFormat:@"%@",sleeperPoints];
        PFObject * testBet=[PFObject objectWithClassName:@"TestBet"];
        [testBet setObject:betterUsername forKey:@"better"];
        [testBet setObject:sleeperUsername forKey:@"sleeper"];
        [testBet setObject:hoursBet forKey:@"betTime"];
        [testBet setObject:hoursSlept forKey:@"hoursSlept"];
        [testBet setObject:@"0" forKey:@"betStatus"];
        [testBet setObject:bPoints forKey:@"betterPoints"];
        [testBet setObject:sPoints forKey:@"sleeperPoints"];
        [testBet saveInBackground];
        
    }
    
}

+(int)querySleeperPoints{
    [self test:@"Better" bet:@"Sleeper" outcome:@"8" withHoursSlept:@"9"];
    
    PFQuery * testBetQuery = [PFQuery queryWithClassName:@"TestBet"];
    NSLog(@"query started");
    // need to include
    [testBetQuery whereKey:@"better" equalTo:@"Better"];
    [testBetQuery orderByDescending:@"createdAt"];
    NSArray *betObject = [testBetQuery findObjects];
    
    NSLog(@"found object");
    NSLog(@" object has %lu items",(unsigned long)[betObject count]);
    NSDictionary * bet = [ betObject firstObject];
    int sleeperPoints = [bet[@"sleeperPoints"]intValue];
    return sleeperPoints;
    
    
}


+(BOOL) test:(NSString *)better bet:(NSString *)sleeper logic:(int)betHours is:(int)HoursSlept correct:(NSString *)predictedWinner{
    if (betHours > HoursSlept && [predictedWinner isEqualToString:better]){
        NSLog(@"a");
        return true;
    
    
    }
    else if(HoursSlept > betHours &&[predictedWinner isEqualToString:sleeper]){
        NSLog(@"b");
        return true;
    }
    else{
        NSLog(@"c");
        return false;
    }
        

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"slambleBackdrop.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.automaticallyAdjustsScrollViewInsets=YES;
//    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//     [self.tableView.tableHeaderView setBackgroundColor:[UIColor whiteColor]];
    
    // initializes two arrays, one to keep all bet objects where the current user is a better
    // the other to keep all bets where the current user is a sleeper
    self.betterObjects = [[NSMutableArray alloc] init];
    self.sleeperObjects = [[NSMutableArray alloc] init];
    
    //calls the current username and assigns it to a string
    self.currentUserName= [[PFUser currentUser] objectForKey:@"username"];
    //calls the current user ID and assings it to a string
    self.currentUserId = [PFUser currentUser].objectId;
    NSLog(@"current userName is: %@",self.currentUserName);
    NSLog(@"current userName is: %@",self.currentUserId);

    
    //creates a query to look at all bets where the current user is a sleeper
    PFQuery *query = [PFQuery queryWithClassName:@"betClass"];
    [query whereKey:@"sleeperId" equalTo:self.currentUserId];
    [query whereKey:@"betStatus" equalTo:@"1"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error){
        if(!error){
            self.sleeperObjects =objects;
//    //counts the number of objects in the sleeper objects array
//    self.sleeperObjectCount = self.sleeperObjects.count;
            NSLog(@"Successfully retrieved bets. %lu", (unsigned long)self.sleeperObjects.count);
            NSLog(@"bet objects are: %@", self.sleeperObjects);
    
            // parses the sleeper objects into 3 arrays to present in the table view controller (the better, bet times, and created Date"
            self.betterArrBetsAgainst = [self.sleeperObjects valueForKey:@"better"];
            self.betTimeArrBetsAgainst= [self.sleeperObjects valueForKey:@"betTime"];
            self.createdAtBetsArrAgainst = [self.sleeperObjects valueForKey:@"createdAt"];
            id anObject = [self.createdAtBetsArrAgainst objectAtIndex:0];
            NSLog(@"%@", NSStringFromClass([anObject class]));
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
        else{
            NSLog(@"error! %@", error);
        }
    }];
    //logs them for testing purposes
//    NSLog(@"betterArray called: %@", self.betterArrBetsAgainst);
//    NSLog(@"timeArray called: %@", self.betTimeArrBetsAgainst);
//    NSLog(@"cretedAt Bets Against called: %@", self.createdAtBetsArrAgainst);

    
    //creates a second query to store all bets where the current user is a better
    PFQuery *query2 = [PFQuery queryWithClassName:@"betClass"];
    [query2 whereKey:@"betterId" equalTo:self.currentUserId];
    [query2 whereKey:@"betStatus" equalTo:@"1"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray * objects2, NSError *error){
        if(!error){
            self.betterObjects =objects2;
            //counts the number of bet objects where the current user is the better
//            self.betterObjectCount =self.betterObjects.count;
            //    NSLog(@"Successfully retrieved bets. %lu", (unsigned long)self.betterObjects.count);
            //    NSLog(@"bet objects are: %@", self.betterObjects);
            
            //parses the betterObjects into three arrays to present to the Table View Controller
            self.sleeperArrBetsFor = [self.betterObjects valueForKey:@"sleeper"];
            self.betTimeBetsFor= [self.betterObjects valueForKey:@"betTime"];
            self.createdAtBetsArrsFor = [self.betterObjects valueForKey:@"createdAt"];
            //    NSLog(@"sleeperArray called: %@", self.sleeperArrBetsFor);
            //    NSLog(@"bettimeArray called: %@", self.betTimeBetsFor);
            //    NSLog(@"bettimeArray called: %@", self.createdAtBetsArrsFor);
             //reload table after query finishes
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
        else{
            NSLog(@"error! %@", error);
        }
    }];
    
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"betClass"];
    [query3 whereKey:@"sleeperId" equalTo:self.currentUserId];
    [query3 whereKey:@"betStatus" equalTo:@"3"];
    [query3 findObjectsInBackgroundWithBlock:^(NSArray * objects3, NSError *error){
        if(!error){
            self.sleeperObjectsComplete =objects3;
            //parses the betterObjects into three arrays to present to the Table View Controller
            self.betterArrBetsAgainstComplete = [self.sleeperObjectsComplete valueForKey:@"sleeper"];
            self.betTimeArrBetsAgainstComplete= [self.sleeperObjectsComplete valueForKey:@"betTime"];
            self.createdAtBetsArrAgainstComplete = [self.sleeperObjectsComplete valueForKey:@"createdAt"];
            self.betterPointsBetsAgainstComplete = [self.sleeperObjectsComplete valueForKey:@"betterPoints"];
            self.sleeperPointsBetsAgainstComplete = [self.sleeperObjectsComplete valueForKey:@"sleeperPoints"];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
        else{
            NSLog(@"error! %@", error);
        }
    }];
    
    
    PFQuery *query4 = [PFQuery queryWithClassName:@"betClass"];
    [query4 whereKey:@"betterId" equalTo:self.currentUserId];
    [query4 whereKey:@"betStatus" equalTo:@"3"];
    [query4 findObjectsInBackgroundWithBlock:^(NSArray * objects4, NSError *error){
        if(!error){
            self.betterObjectsComplete =objects4;
            
            //parses the betterObjects into three arrays to present to the Table View Controller
            self.sleeperArrBetsForComplete= [self.betterObjectsComplete valueForKey:@"sleeper"];
            self.betTimeBetsForComplete= [self.betterObjectsComplete valueForKey:@"betTime"];
            self.createdAtBetsArrsForComplete = [self.betterObjectsComplete valueForKey:@"createdAt"];
            self.betterPointsBetsForComplete = [self.sleeperObjectsComplete valueForKey:@"betterPoints"];
            self.sleeperPointsBetsForComplete = [self.sleeperObjectsComplete valueForKey:@"sleeperPoints"];
            //reloading the table after query finishes
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.tableView reloadData];
            });
        }
        else{
            NSLog(@"error! %@", error);
        }
    }];
    //Parallax
    //Min and Max Values
    CGFloat topBottomMin=-55.0f;
    CGFloat topBottomMAx=55.0f;
    
    //Motion Effect
    UIInterpolatingMotionEffect *topBottom= [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    topBottom.minimumRelativeValue=@(topBottomMin);
    topBottom.maximumRelativeValue=@(topBottomMAx);
    
    //Create motion effect group
    UIMotionEffectGroup *neGroup = [[UIMotionEffectGroup alloc]init];
    neGroup.motionEffects = @[topBottom];
    
    //Add motion effect group to our imageView
    [self.tableView addMotionEffect:neGroup];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   //returns the number of sections based on the number of bet objects for the sleeper array and better array
    return 4;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section based on the length of each array, or the number of bets
    
    if (section == 0){
        if (self.sleeperObjects.count == 0){
            return 1;
        }
        else {
        return self.sleeperObjects.count;
        }
        
    }
    if (section == 1){
        if(self.betterObjects.count ==0){
            return 1;
        }
        else{
        return self.betterObjects.count;
        }
    }
    
    if (section == 2){
        if (self.sleeperObjectsComplete.count == 0){
            return 1;
        }
        else {
            return self.sleeperObjectsComplete.count;
        }
        
    }
    if (section == 3){
        if(self.betterObjectsComplete.count ==0){
            return 1;
        }
        else{
            return self.betterObjectsComplete.count;
        }
    }
    else{
        return 0;
    }
    
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
      UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:155 green:155 blue:155 alpha:.4];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:.7].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];

    if (section == 0){
        headerLabel.text = @"Active Bets Against";

    }
    else if (section == 1){
        headerLabel.text = @"Active Bets For";
    }
    else if (section == 2){
        headerLabel.text = @"Completed Bets Against";
    }
    else if (section == 3){
        headerLabel.text = @"Completed Bets For";
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //The above dequeues a cell, but cell will be nil the first few times this method is called, so we create them here.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        //Note that the firs time through we used UITableViewCellStyleDefault
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    

    //if it is section 0, i.e. the bets where the current user has been bet as the sleeper
    if (indexPath.section ==0){
        if (self.sleeperObjects.count == 0){
            cell.textLabel.text = @"No Outstanding Bets Against You";
            
            cell.detailTextLabel.text = @"";
        }
        else{
        // first creates a string of the better
        NSString *labelText1 = [NSString stringWithFormat:@"%s%@", "You Were Bet By: ", self.betterArrBetsAgainst[indexPath.row]];
        //then creates a string of the hours bet
        NSString *detailText1 = [NSString stringWithFormat:@"%s%@%s", "To Sleep: ", self.betTimeArrBetsAgainst[indexPath.row], " hours"];
        cell.textLabel.text = labelText1;
        cell.detailTextLabel.text  = detailText1;
        }
        //
    }
    if (indexPath.section ==1){
        if (self.betterObjects.count == 0){
            cell.textLabel.text = @"No Oustanding Bets Against Anyone";
            cell.detailTextLabel.text = @"";
        }
        
        else{
        //first creates a string of the person the current user bet
        NSString *labelText2= [NSString stringWithFormat:@"%s%@", "You Bet: ", self.sleeperArrBetsFor[indexPath.row]];
        // then creates a string of the hours the current user bet the other person to sleep.
        NSString *detailText2 = [NSString stringWithFormat:@"%s%@%s",  " To Sleep: " , self.betTimeBetsFor[indexPath.row], " hours"];
        cell.textLabel.text = labelText2;
        cell.detailTextLabel.text  = detailText2;
        }

    }
    if (indexPath.section ==2){
        if (self.sleeperObjectsComplete.count == 0){
            cell.textLabel.text = @"No Completed Bets Against You";
            cell.detailTextLabel.text = @"";
        }
        else{
            // first creates a string of the better
            NSString *labelText3 = [NSString stringWithFormat:@"%s%@%s%@%s", "Bet By: ", self.betterArrBetsAgainstComplete[indexPath.row], " To Sleep: ", self.betTimeArrBetsAgainstComplete[indexPath.row], " hours"];
            //then creates a string of the hours bet
            NSString *detailText3 = [NSString stringWithFormat:@"%s%@%s%@%s%@", "Your points: ", self.sleeperPointsBetsAgainstComplete[indexPath.row], "  ", self.betterArrBetsAgainstComplete[indexPath.row], "'s points: ", self.betterPointsBetsAgainstComplete[indexPath.row]];
            cell.textLabel.text = labelText3;
            cell.detailTextLabel.text  = detailText3;
        }
        //
    }
    if (indexPath.section ==3){
        if (self.betterObjectsComplete.count == 0){
            cell.textLabel.text = @"No Completed Bets Against Anyone";
            cell.detailTextLabel.text = @"";
        }
        
        else{
            
            NSString *labelText4 = [NSString stringWithFormat:@"%s%@%s%@%s", "Bet By: ", self.sleeperArrBetsForComplete[indexPath.row], " To Sleep: ", self.betTimeBetsForComplete[indexPath.row], " hours"];
            //then creates a string of the hours bet
            NSString *detailText4 = [NSString stringWithFormat:@"%s%@%s%@%s%@", "Your points: ", self.betterPointsBetsForComplete[indexPath.row], "  ", self.sleeperArrBetsForComplete[indexPath.row], "'s points: ", self.sleeperPointsBetsForComplete[indexPath.row]];
            cell.textLabel.text = labelText4;
            cell.detailTextLabel.text  = detailText4;
    
        }
        
    }
    
    
    return cell;
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
