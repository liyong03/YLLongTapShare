//
//  Evaluate.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/19/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "Evaluate.h"


@implementation BezierEvaluator

- (id)initWithFirst:(double)newFirst second:(double)newSecond
{
	self = [super init];
	if (self != nil)
	{
		firstControlPoint = newFirst;
		secondControlPoint = newSecond;
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	return
    // (1 - position) * (1 - position) * (1 - position) * 0.0 +
    3 * position * (1 - position) * (1 - position) * firstControlPoint +
    3 * position * position * (1 - position) * secondControlPoint +
    position * position * position * 1.0;
}

@end

@implementation ExponentialDecayEvaluator

- (id)initWithCoefficient:(double)newCoeff
{
	self = [super init];
	if (self != nil)
	{
		coeff = newCoeff;
		offset = exp(-coeff);
		scale = 1.0 / (1.0 - offset);
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	return 1.0 - scale * (exp(position * -coeff) - offset);
}

@end

@implementation SecondOrderResponseEvaluator

- (id)initWithOmega:(double)newOmega zeta:(double)newZeta
{
	self = [super init];
	if (self != nil)
	{
		omega = newOmega;
		zeta = newZeta;
	}
	return self;
}

- (double)evaluateAt:(double)position
{
	double beta = sqrt(1 - zeta * zeta);
	double phi = atan(beta / zeta);
	double result = 1.0 + -1.0 / beta * exp(-zeta * omega * position) * sin(beta * omega * position + phi);
	return result;
}

@end

@implementation YLSPringAnimation

+ (NSMutableArray*)calculateKeyFramesFromeStartValue:(double)startValue
                                            endValue:(double)endValue
                                   interstitialSteps:(NSUInteger)steps
{
    NSUInteger count = steps + 2;
    SecondOrderResponseEvaluator* evaluator = [[SecondOrderResponseEvaluator alloc] initWithOmega:20.0 zeta:0.4];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
    
    double progress = 0.0;
    double increment = 1.0 / (double)(count - 1);
    NSUInteger i;
    for (i = 0; i < count; i++)
    {
        double value =
        startValue +
        [evaluator evaluateAt:progress] * (endValue - startValue);
        [valueArray addObject:[NSNumber numberWithDouble:value]];
        
        progress += increment;
    }
    
    return valueArray;
}

@end

