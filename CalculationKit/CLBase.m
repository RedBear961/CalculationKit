/*
 * CLBase.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLBase.h"

@implementation CLBase

- (instancetype)init {
	self = [super init];
	
	if (self) {
		_useRadians = NO;
		_countOfDecimalPlaces = 5;
	}
	
	return self;
}

+ (CLBase *)shared {
	static CLBase *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [[CLBase alloc] init];
	});
	return _shared;
}

@end
