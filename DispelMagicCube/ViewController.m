//
//  ViewController.m
//  DispelMagicCube
//
//  Created by rui luo on 13-2-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Cube.h"
#import "Gesture.h"

BOOL isChoose = NO;

@implementation ViewController

@synthesize context = _context;

- (void)dealloc
{
    [_context release];
    [_animation release];
    [_particleFire release];
    [_gameLogic release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context. \n");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    // 设置深度缓冲区
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    // 设置抗锯齿
    //view.drawableMultisample = GLKViewDrawableMultisample4X;
    
    [self setupGL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    _particleFire = [[ParticleFire alloc] init];
    
    _animation = [[Animation alloc] init];
    [_animation isDispel];
    
    _gameLogic = [[GameLogic alloc] init];
}

// test
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
// test

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}


#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect 
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_particleFire draw];
    [_animation draw];
    [_gameLogic draw];
}

#pragma mark - GLKViewControllerDelegate

- (void)update 
{
    ++_timeCounter;
    if (_timeCounter % 30 == 0)
    {
        --_gameLogic.time;
    }
    if (_gameLogic.time == 0)
    {
        _animation.gameScore = 0;
    }
    _gameLogic.score = _animation.gameScore;
    
    [_particleFire update];
    [_animation update];
    [_gameLogic update];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (!isChoose) 
    {
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInView:self.view];
        CGPoint lastLoc = [touch previousLocationInView:self.view];
        CGPoint diff = CGPointMake(lastLoc.x - location.x, lastLoc.y - location.y);
        
        float rotX = -1 * GLKMathDegreesToRadians(diff.y / 2.0);
        float rotY = -1 * GLKMathDegreesToRadians(diff.x / 2.0);
        
        [_animation RotateCube:rotX :rotY];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    GLint viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    
    GLfloat x = location.x;
    GLfloat y = 480 - location.y;
    GLubyte pixelColor[4] = {0};
    
    if (viewport[3] == 960) {
        glReadPixels(x*2, y*2, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixelColor);
    }
    else if (viewport[3] == 480) {
        glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixelColor);
    }
    else {
        NSLog(@"Error! Cann't recognize the devide.\n");
    }
    
    if (pixelColor[3] < 162) 
    {
        isChoose = YES;
        
        NSLog(@"pixel is %d, %d, %d, %d. \n", pixelColor[0], pixelColor[1], pixelColor[2], pixelColor[3]);
    }
    else 
    {
        isChoose = NO;
    }
    
    beganPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isChoose) {
    UITouch *touch = [touches anyObject];
    endedPoint = [touch locationInView:self.view];
    
    [self RotateFace:beganPoint:endedPoint];
    }
}

- (void)RotateFace: (CGPoint)p1: (CGPoint)p2
{
    Gesture *gesture = [[Gesture alloc] init];
    GLKMatrix4 centreMatrix = [_animation Matrix:1 :1 :1]; 
    [gesture resolve:p1 :p2 :centreMatrix];
    
    if ([gesture isRotate]) {
        NSInteger axis      = gesture.axis;
        NSInteger value     = gesture.value;
        NSInteger direction = gesture.direction;
        
        [_animation RotateFace:axis :value :direction];
    }
    
    [gesture release];
}

@end