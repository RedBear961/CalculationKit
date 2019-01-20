//
//  CalculationKitTests.m
//  CalculationKitTests
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CalculationKit/CalculationKit.h>

@interface CalculationKitTests : XCTestCase

@end

@implementation CalculationKitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
	CLBase *base = [CLBase shared];
	base.useRadians = YES;
	
	NSString *string = @"sin(pi / 2)";
	CLExpression *expression = [CLExpression expressionWithString:string error:nil];
	CGFloat result = [expression calc:nil];
	
	NSLog(@"1");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
