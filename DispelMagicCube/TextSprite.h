//
//  TextSprite.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#define M_TAU (2*M_PI)

static inline NSInteger powi(NSInteger x, NSInteger y)
{
    NSInteger z = 1;
    // 不考虑y<0和x=0的情况
    if (y > 0)
    {
        for (NSInteger i = 0; i < y; ++i)
        {
            z *= x;
        }
    }
	return z;
}

@interface TextSprite : NSObject
{
    NSInteger   _word;
    NSInteger   _wordNumber;
    GLKVector2  _position;
    GLKVector2  _size;
    
    NSInteger  _verticesIndex;
    GLfloat    *_vertices;
    GLfloat    *_texture;
}

@property (nonatomic, assign) NSInteger   word;
@property (nonatomic, assign) NSInteger   wordNumber;
@property (nonatomic, assign) GLKVector2  position;
@property (nonatomic, assign) GLKVector2  size;

- (void)update;
- (void)awake;
- (void)draw;

@end
