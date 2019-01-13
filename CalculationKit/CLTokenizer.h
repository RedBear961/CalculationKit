//
//  CLTokenizer.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>
#import <CalculationKit/CLTokenizedExpression.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLTokenizer : NSObject

@property (readonly, nonatomic) CLTokenizedExpression *tokenizedExpression;

- (instancetype)initWithExpression:(CLExpression *)expression error:(NSError * __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
