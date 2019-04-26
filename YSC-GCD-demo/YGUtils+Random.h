//
//  YGUtils+Random.h
//  SuperKoalio
//
//  Created by Jackson on 2017/7/26.
//  Copyright © 2017年 Razeware. All rights reserved.
//

#ifndef YGUtils_h
#define YGUtils_h
#include <stdlib.h>

#define YG_INLINE static __inline__

#ifdef __cplusplus
extern "C" {
#endif

/**
  Generate a random number within a certain range
 */

/**
 Gets a random integer that ranges from [from to to], including from, including to
 */

YG_INLINE int randomNumber(int from, int to)
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

/**
 Gets a random integer that ranges from [min to max], including min, excluding max
 */

YG_INLINE int randomNumber2(int from, int to)
{
    return (arc4random() % (to - from)) + from;
}
    
/**
    The random number function arc4random_uniform (x) can be used to generate random numbers within the range of 0 ~ (x-1), and no modulo operation is necessary. If you want to generate a random number from 1 to x, you can say: arc4random_uniform (x) + 1.
     
    Gets a random integer that ranges from [from to to], including from, including to
*/
    
YG_INLINE int random_uniformNumber(int x)
{
     return (int)arc4random_uniform(x);
}
    
/**

 Gets a random integer that ranges from [from to to], including from, including to
 */

YG_INLINE int random_uniformNumber2(int from, int to)

{
    return (int)(arc4random_uniform(to - from + 1) + from);
}

/**
 Gets a random integer that ranges from [from to to], including from, excluding to
 */

YG_INLINE int random_uniformNumber3(int from, int to)
{
    return (int)(arc4random_uniform(to - from) + from);
}

#ifdef __cplusplus
}
#endif

#endif /* YGUtils_h */
