//
//  ViewController.h
//  DispelMagicCube
//
//  Created by rui luo on 13-2-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Animation.h"
#import "ParticleFire.h"
#import "ParticleStar.h"
#import "TextSprite.h"
#import "GameLogic.h"

@interface ViewController : GLKViewController
{
    EAGLContext    *_context;
    
    CGPoint        beganPoint;
    CGPoint        endedPoint;
    
    NSInteger      _timeCounter;
    
    Animation      *_animation;
    ParticleFire   *_particleFire;
    GameLogic      *_gameLogic;
}

@property (strong, nonatomic) EAGLContext *context;

@end