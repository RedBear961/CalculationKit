//
//  CLBase.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLBase.h"

static BOOL _useRadians = NO;

BOOL CalculationKitUsesRadians(void) {
	return _useRadians;
}

void CalculationKitSetUseRadians(BOOL flag) {
	_useRadians = flag;
}
