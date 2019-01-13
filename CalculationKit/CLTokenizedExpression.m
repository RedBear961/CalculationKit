//
//  CLTokenizedExpression.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLTokenizedExpression.h"

@interface CLTokenizedExpression ()

@property (nonatomic) NSArray<CLToken *> *tokensArray;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation CLTokenizedExpression

- (instancetype)init {
	return [self initWithArray:@[]];
}

- (instancetype)initWithArray:(NSArray *)aArray {
	self = [super init];
	
	if (self) {
		_tokensArray = [aArray copy];
		_currentIndex = 0;
	}
	
	return self;
}

- (NSUInteger)count {
	return _tokensArray.count;
}

- (CLToken *)firstObject {
	_currentIndex = 0;
	return _tokensArray.firstObject;
}

- (CLToken *)lastObject {
	_currentIndex = _tokensArray.count - 2;
	return _tokensArray.lastObject;
}

- (CLToken *)nextObject {
	__kindof CLToken *token = nil;
	
	if (_currentIndex < _tokensArray.count) {
		token = [_tokensArray objectAtIndex:_currentIndex];
		++_currentIndex;
	}
	
	return token;
}

- (CLToken *)previousObject {
	__kindof CLToken *token = nil;
	
	if (_currentIndex >= 0) {
		token = [_tokensArray objectAtIndex:_currentIndex];
		--_currentIndex;
	}
	
	return token;
}

@end
