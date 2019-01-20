/*
 * CLToken.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLToken.h"
#import "CLConstant.h"

@implementation CLToken

- (instancetype)initWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString {
	self = [super init];
	
	if (self) {
		// The preservation of values.
		_name = name;
		_type = type;
		_stringValue = aString;
		
		// Handling the token type to determine whether the constant and variable properties need to be initialized.
		switch (type) {
			case CLTokenTypeConstant:
				// Processing of the token to the existence of unary digits.
				if ([aString hasPrefix:@"+-"] || [aString hasPrefix:@"-+"] || [aString hasPrefix:@"++"])
					_stringValue = [aString substringFromIndex:1];
				else if ([aString hasPrefix:@"--"])
					_stringValue = [aString substringFromIndex:2];
				
				_constant = [_stringValue doubleValue];
				break;
				
			case CLTokenTypeDecimal:
				_constant = [CLConstant constantWithString:aString].doubleValue;
				
			case CLTokenTypeVariable:
				_variable = aString;
				break;
				
			default:
				break;
		}
	}
	
	return self;
}

// Replacing the constructor with a minus.
+ (instancetype)tokenWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString {
	return [[self alloc] initWithName:name type:type stringValue:aString];
}

- (NSString *)description {
	// Returns a string representation, as a descriptor.
	return _stringValue;
}

@end
