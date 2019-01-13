//
//  CLAction.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CLAction <NSObject>

@property (readonly, nonatomic) NSString *stringValue;

+ (NSUInteger)containsAction:(NSString *)signature;
- (BOOL)isUserAction:(id<CLAction>)action;

@end

NS_ASSUME_NONNULL_END
