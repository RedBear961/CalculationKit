//
//  CLBase.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLBase.h"

static BOOL _useRadians = NO;
static NSUInteger _countOfDecimal = 5;

BOOL CalculationKitUsesRadians(void) {
	return _useRadians;
}

void CalculationKitSetUseRadians(BOOL flag) {
	_useRadians = flag;
}

NSUInteger CalculationKitCountOfDecimalPlaces(void) {
	return _countOfDecimal;
}

void CalculationKitSetCountOfDecimalPlaces(NSUInteger count) {
	_countOfDecimal = count ?: 1;
}

CGFloat CLRoundFractionPart(CGFloat number, NSUInteger sign) {
	NSUInteger multi = 10;
	for (int i = 0; i < sign; ++i, multi *= 10);
	return round(number * multi) / multi;
}

CGFloat CLRoundIntegerPart(CGFloat number, NSUInteger discharge) {
	return 0;
}
