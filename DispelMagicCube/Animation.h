//
//  Animation.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#import "Cube.h"
#import "ParticleStar.h"

@interface Animation : NSObject
{
    NSInteger      _axis;
    NSInteger      _value;
    NSInteger      _direction;
    CGFloat        _currentAngle;
    
    Cube           *_cube[3][3][3];
    GLKMatrix4     _rotMatrix[3][3][3];
    NSMutableArray *_cubes;
    
    NSInteger      _dispelFace[162];
    GLKVector4     _srcColor[162];
    GLKVector4     _dstColor[162];
    NSInteger      _alpha;
    
    NSInteger      _emitterTime;
    ParticleStar   *_particleStar;
    
    NSInteger      _gameScore;
}

@property (nonatomic, assign) NSInteger gameScore;

- (GLKMatrix4)Matrix: (NSInteger)i: (NSInteger)j: (NSInteger)k;
- (void)RotateCube: (CGFloat)rotX: (CGFloat)rotY;
- (void)RotateFace: (NSInteger)axi: (NSInteger)val: (NSInteger)dir;
- (void)draw;
- (void)update;
- (void)isDispel;

@end
