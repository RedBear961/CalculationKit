//
//  CLError.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>

typedef NSString *CLErrorDomain;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT CLErrorDomain const CLTokenizerErrorDomain;
FOUNDATION_EXPORT CLErrorDomain const CLReversePolishNotationDomain;
FOUNDATION_EXPORT CLErrorDomain const CLCalculatorDomain;

typedef NS_ENUM(NSInteger, CLTokenizerErrorCode) {
	CLDuplicatePointNumbers = -1000,
	CLUnknownToken = -1001,
};

typedef NS_ENUM(NSInteger, CLReversePolishNotationErrorCode) {
	CLInconsistentBrackets = -1000,
};

typedef NS_ENUM(NSInteger, CLCalculatorErrorCode) {
	CLExtraArguments = -1000,
	CLNotEnoughArguments = -1001,
};

NS_ASSUME_NONNULL_END
