//
//  GameLogic.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic

@synthesize score = _score;
@synthesize time  = _time;

- (void)dealloc
{
    [_scoreLabel release];
    [_scoreValue release];
    [_timeLabel release];
    [_timeValue release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _time = 120;
        
        _scoreLabel = [[TextSprite alloc] init];
        _scoreValue = [[TextSprite alloc] init];
        _timeLabel  = [[TextSprite alloc] init];
        _timeValue  = [[TextSprite alloc] init];
        
        _scoreLabel.word = 10;
        _scoreLabel.position = GLKVector2Make(0.2f, 1.1f);
        _scoreLabel.size = GLKVector2Make(0.30f, 0.10f);
        [_scoreLabel awake];
        
        _scoreValue.word = _score;
        _scoreValue.wordNumber = [self lengthOfNumber:_score];
        _scoreValue.position = GLKVector2Make(0.6f, 1.1f);
        _scoreValue.size = GLKVector2Make(0.06f*_scoreValue.wordNumber, 0.10f);
        [_scoreValue awake];
        
        _timeLabel.word = 11;
        _timeLabel.position = GLKVector2Make(-0.6f, 1.1f);
        _timeLabel.size = GLKVector2Make(0.30f, 0.10f);
        [_timeLabel awake];
        
        _timeValue.word = _time;
        _timeValue.wordNumber = [self lengthOfNumber:_time];
        _timeValue.position = GLKVector2Make(-0.2f, 1.1f);
        _timeValue.size = GLKVector2Make(0.06f*_timeValue.wordNumber, 0.10f);
        [_timeValue awake];
    }
    return self;
}

- (void)update
{
    if (_time == 0)
    {
        [self gameOver];
    }
    
    _timeValue.word = _time;
    _timeValue.wordNumber = [self lengthOfNumber:_time];
    _timeValue.size = GLKVector2Make(0.06f*_timeValue.wordNumber, 0.10f);
    [_timeValue update];
    
    if (_displayScore < _score)
    {
        _displayScore += 10;
    }
    
    _scoreValue.word = _displayScore;
    _scoreValue.wordNumber = [self lengthOfNumber:_score];
    _scoreValue.size = GLKVector2Make(0.06f*_scoreValue.wordNumber, 0.10f);
    [_scoreValue update];
}

- (void)draw
{
    [_scoreLabel draw];
    [_scoreValue draw];
    [_timeLabel draw];
    [_timeValue draw];
}

- (void)gameOver
{
    self.score = 0;
    self.time  = 120;
}

// 只考虑到第10位数
- (NSInteger)lengthOfNumber: (NSInteger)num
{
    NSInteger len = 1;
    for (NSInteger i = 1; i < 10; ++i)
    {
        if (num / powi(10, i) > 0)
        {
            len = i + 1;
        }
    }
    return len;
}

@end
