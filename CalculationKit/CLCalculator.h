//
//  CLCalculator.h
//  CalculationKit
//
//  Created by God on 17.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLCalculator : NSObject

- (CGFloat)calcExpression:(CLExpression *)expression withError:(NSError **)error;

@end


@interface CLExpression (CLCalculator)

- (CGFloat)calc:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
