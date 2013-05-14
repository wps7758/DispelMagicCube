//
//  ParticleFire.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ParticleSystem.h"

@interface ParticleFire : NSObject
{
    ParticleSystem *_particleSystem;
}

- (void)draw;
- (void)update;

@end
