//
//  ParticleStar.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ParticleSystem.h"

@interface ParticleStar : NSObject
{    
    NSInteger      _emitterNumber;
    GLKVector3     _emitterPosition[27];
    GLKVector4     _emitterColor[27];
    
    ParticleSystem *_particleSystem[27];
}

@property (nonatomic, assign) NSInteger emitterNumber;

- (void)draw;
- (void)awake;
- (void)update;

- (void)setEmitterPosition: (GLKVector3)position: (int)i;
- (void)setEmitterColor: (GLKVector4)color: (int)i;

@end
