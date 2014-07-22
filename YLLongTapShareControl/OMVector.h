//
//   Copyright (c) 2009 BÃ¡lint JÃ¡nvÃ¡ri
//       www.programmaticmagic.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

//
//  OMVector.h
//  ObjectiveMagic
//

/*
 OMVector provides a number of functions that
 let you use CGPoint values as vectors.
 */

//#ifndef OMVECTOR_H_
//#define OMVECTOR_H_

#import <CoreGraphics/CoreGraphics.h>
#import <math.h>

/*
 CGVector is interexchangeable with CGPoint
 */
//typedef CGPoint CGVector;
//#define CGVectorMake CGPointMake

/*
 Create a vector with two points
 */
CG_INLINE CGVector CGVectorMakeWithPoints(CGPoint pt1, CGPoint pt2)
{
	return CGVectorMake(pt2.x - pt1.x, pt2.y - pt1.y);
}

/*
 Create a vector with a length and an angle
 */
CG_INLINE CGVector CGVectorMakeWithLength(CGFloat length, CGFloat radians)
{
	return CGVectorMake(length * sinf(radians), length * cosf(radians));
}

/*
 Returns the length of the vector
 */
CG_INLINE CGFloat CGVectorLength(CGVector v)
{
	return sqrtf(v.dx * v.dx + v.dy * v.dy);
}

/*
 Returns the angle between the vector and the positive x-axis
 */
CG_INLINE CGFloat CGVectorAtan2(CGVector v)
{
	return atan2f(v.dx, v.dy);
}

/*
 Returns the tangent of the vector
 */
CG_INLINE CGFloat CGVectorTan(CGVector v)
{
	return v.dy / v.dx;
}

/*
 Returns the vector rotated by an angle
 */
CG_INLINE CGVector CGVectorRotate(CGVector v, CGFloat radians)
{
	return CGVectorMake(cosf(radians) * v.dx - sinf(radians) * v.dy, sinf(radians) * v.dx + cosf(radians) * v.dy);
}

/*
 Returns the sum of the two vectors
 */
CG_INLINE CGVector CGVectorAdd(CGVector v1, CGVector v2)
{
	return CGVectorMake(v1.dx + v2.dx, v1.dy + v2.dy);
}

/*
 Returns the difference of the two vectors
 */
CG_INLINE CGVector CGVectorSubtract(CGVector v1, CGVector v2)
{
	return CGVectorMake(v2.dx - v1.dx, v2.dy - v1.dy);
}

/*
 Returns the rectangle translated by the vector
 */
CG_INLINE CGRect CGRectTranslateByVector(CGRect r, CGVector v)
{
	return CGRectMake(r.origin.x + v.dx, r.origin.y + v.dy, r.size.width, r.size.height);
}

/*
 Returns the transformation translated by the vector
 */
CG_INLINE CGAffineTransform CGAffineTransformTranslateByVector(CGAffineTransform transform, CGVector v)
{
	return CGAffineTransformTranslate(transform, v.dx, v.dy);
}

/*
 Translates the context with the vector
 */
CG_INLINE void CGContextTranslateCTMByVector(CGContextRef c, CGVector v)
{
	CGContextTranslateCTM(c, v.dx, v.dy);
}

/*
 Returns the angle between two vectors
 */
CG_INLINE CGFloat CGVectorAngle(CGVector v1, CGVector v2)
{
	return CGVectorAtan2(v2) - CGVectorAtan2(v1);
}

/*
 Returns the vector multiplied with a number
 */
CG_INLINE CGVector CGVectorMultiply(CGVector v, float m)
{
	return CGVectorMake(v.dx * m, v.dy * m);
}

CG_INLINE CGVector CGVectorNormalize(CGVector v)
{
    CGFloat len = CGVectorLength(v);
	return CGVectorMake(v.dx / len, v.dy / len);
}

CG_INLINE CGPoint CGPointFromStartAndVector(CGPoint p, CGVector v) {
    return CGPointMake(p.x + v.dx, p.y + v.dy);
}

//#endif