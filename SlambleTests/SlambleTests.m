//
//  SlambleTests.m
//  SlambleTests
//
//  Created by Praveen Gupta on 10/4/15.
//  Copyright © 2015 Praveen Gupta. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SignUpViewController.h"
#import "ViewController.h"
#import "MakeBetsViewController.h"
#import "HomePageViewController.h"

@interface SlambleTests : XCTestCase

@end

@implementation SlambleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testEmailFeature {
    XCTAssert([SignUpViewController isValidEmailAddress:@"francescoperera@yahoo.com"]); // this should be true
    XCTAssertFalse([SignUpViewController isValidEmailAddress:@"asdcsdCEWG"]); // this should be false
    
}

-(void)testPhoneNumber{
    XCTAssert([SignUpViewController isValidPhoneNumber:@"6467247289"]);
    XCTAssertFalse([SignUpViewController isValidPhoneNumber:@"646-724-7289"]);
}

-(void) testSignUp{
    // FOR XCTAssertFalse it is CRITICAL that the signup info is brand new, it must not exist signUpTest
    XCTAssert([SignUpViewController function:@"A" that:@"B" checks:@"C" that:@"D" SignUp:@"E" isValid:@"123" inClass:@"signUpTest"]);
    XCTAssertFalse([SignUpViewController function:@"X2" that:@"Y2" checks:@"Z2" that:@"O2" SignUp:@"L1" isValid:@"789" inClass:@"signUpTestFalse"]);
    

}

-(void) testLogin{
    XCTAssert([ViewController test:@"dc" login:@"dc"]);
    XCTAssertFalse([ViewController test:@"abc" login:@"def"]);
}

-(void) testMakeBet{
    XCTAssert([MakeBetsViewController test:@"cnelson" bet:@"dhart" logic:@"8" inClass:@"TestBet"]);
    XCTAssertFalse([MakeBetsViewController test:@"cnelson" bet:@"rdavis" logic:@"8" inClass:@"TestBetFalse"]);

}


-(void) testHoursSleptSubmission{
    XCTAssert([HomePageViewController test:@"dhart" hoursSleptSubmission:@"6" fromClass:@"TestBet"]);
    XCTAssertFalse([HomePageViewController test:@"dhart" hoursSleptSubmission:@"6" fromClass:@"TestBetFalse"]);
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
