//
//  CLToken.m
//  CalculationKit
//
//  Created by God on 12.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLToken.h"

@implementation CLToken

- (instancetype)initWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString {
	self = [super init];
	
	if (self) {
		_name = name;
		_type = type;
		_stringValue = aString;
		
		switch (type) {
			case CLTokenTypeConstant:
				if ([aString hasPrefix:@"+-"] || [aString hasPrefix:@"-+"] || [aString hasPrefix:@"++"])
					_stringValue = [aString substringFromIndex:1];
				else if ([aString hasPrefix:@"--"])
					_stringValue = [aString substringFromIndex:2];
				
				_constant = [_stringValue doubleValue];
				break;
				
			case CLTokenTypeVariable:
				_variable = aString;
				break;
				
			default:
				break;
		}
	}
	
	return self;
}

+ (instancetype)tokenWithName:(NSString *)name type:(CLTokenType)type stringValue:(NSString *)aString {
	return [[self alloc] initWithName:name type:type stringValue:aString];
}

- (NSString *)description {
	return _stringValue;
}

@end
