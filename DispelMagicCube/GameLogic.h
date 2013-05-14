//
//  GameLogic.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "TextSprite.h"

@interface GameLogic : NSObject
{
    NSInteger  _displayScore;
    NSInteger  _score;
    NSInteger  _time;
    
    TextSprite *_scoreLabel;
    TextSprite *_scoreValue;
    TextSprite *_timeLabel;
    TextSprite *_timeValue;
}

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger time;

- (void)update;
- (void)draw;

@end
