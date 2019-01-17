//
//  CLReversePolishNotation.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLReversePolishNotation.h"

#import "CLStack.h"

@interface CLReversePolishNotation ()

@property (nonatomic) CLStack<CLToken *> *stack;

@end

@implementation CLReversePolishNotation

- (instancetype)initWithTokenizedExpression:(CLTokenizedExpression *)expression
									  error:(NSError * _Nullable __autoreleasing *)error {
	self = [super init];
	
	if (self) {
		
	}
	
	return self;
}

@end
