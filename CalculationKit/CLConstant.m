/*
 * CLConstant.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLConstant.h"

@implementation CLConstant

static NSMutableDictionary<NSString *, CLConstant *> *_constants;
static NSMutableDictionary<NSString *, CLConstant *> *_userConstants;

+ (NSMutableDictionary<NSString *, CLConstant *> *)constants {
	if (_constants == nil) {
		_constants = [@{@"pi" : [CLConstant constantWithString:@"pi" value:M_PI formattedValue:@"π"],
						@"e" : [CLConstant constantWithString:@"e" value:M_E formattedValue:@"e"],
						} mutableCopy];
	}
	
	return _constants;
}

+ (NSMutableDictionary<NSString *, CLConstant *> *)userConstants {
	return _userConstants ?: [@{} mutableCopy];
}

+ (NSUInteger)hasConstant:(NSString *)string {
	NSUInteger lenght = 0;
	for (NSString *key in [self.constants allKeys]) {
		if ([string hasPrefix:key] && key.length > lenght)
			lenght = key.length;
	}
	return lenght;
}

+ (CLConstant *)constantWithString:(NSString *)aString {
	return [self.constants valueForKey:aString];
}

- (instancetype)initWithString:(NSString *)string
						 value:(CGFloat)value
				formattedValue:(NSString *)formattedValue {
	self = [super init];
	
	if (self) {
		_stringValue = string;
		_doubleValue = value;
		_formattedValue = formattedValue ?: _stringValue;
	}
	
	return self;
}

+ (instancetype)constantWithString:(NSString *)string
							 value:(CGFloat)value
					formattedValue:(NSString *)formattedValue {
	return [[self alloc] initWithString:string value:value formattedValue:formattedValue];
}

+ (void)addConstant:(NSString *)string value:(CGFloat)value formattedValue:(NSString *)formattedValue {
	if (![self.constants valueForKey:string]) {
		CLConstant *constant = [CLConstant constantWithString:string value:value formattedValue:formattedValue];
		[self.userConstants setValue:constant forKey:string];
		[self.constants setValue:constant forKey:string];
	}
}

+ (void)removeConstant:(NSString *)string {
	if ([self.userConstants valueForKey:string]) {
		[self.userConstants removeObjectForKey:string];
		[self.constants removeObjectForKey:string];
	}
}

@end
