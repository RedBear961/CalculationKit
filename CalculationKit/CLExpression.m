//
//  CLExpression.m
//  CalculationKit
//
//  Created by God on 09.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLExpression.h"
#import "CLTokenizer.h"

@interface CLExpression ()

@end

@implementation CLExpression

- (instancetype)initWithString:(NSString *)aString error:(NSError * _Nullable __autoreleasing *)error {
	self = [super init];
	
	if (self) {
		// Saves the original string.
		_stringValue = aString;
		
		NSError *error = nil;
		CLTokenizer *tokenizer = [[CLTokenizer alloc] initWithExpression:self error:&error];
		CLTokenizedExpression *tokenizedExpression = [tokenizer tokenizedExpression];
	}
	
	return self;
}

@end
