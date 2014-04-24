//
//  DWZShareSDKDemoTests.m
//  DWZShareSDKDemoTests
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DWZShareSDKDemoTests : XCTestCase{
    NSArray *dataArray;
}
@end

@implementation DWZShareSDKDemoTests

- (void)setUp
{
    [super setUp];


}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    dataArray = nil;
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    XCTAssertNotNil(dataArray.firstObject, @"array firstobject must not nil");
}

@end
