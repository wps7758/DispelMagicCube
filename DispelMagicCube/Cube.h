//
//  Cube.h
//  DispelMagicCube
//
//  Created by rui luo on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>

#define M_TAU (2*M_PI)

@interface Cube : NSObject
{
    GLKMatrix4 _rotMatrix;
    
    GLKVector3 _position;
    GLKVector3 _rotation;
    GLKVector3 _scale;
    
    GLKVector4 _color1;
    GLKVector4 _color2;
    GLKVector4 _color3;
    GLKVector4 _color4;
    GLKVector4 _color5;
    GLKVector4 _color6;
}

@property (nonatomic, assign) GLKMatrix4 rotMatrix;

@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 rotation;
@property (nonatomic, assign) GLKVector3 scale;

@property (nonatomic, assign) GLKVector4 color1;
@property (nonatomic, assign) GLKVector4 color2;
@property (nonatomic, assign) GLKVector4 color3;
@property (nonatomic, assign) GLKVector4 color4;
@property (nonatomic, assign) GLKVector4 color5;
@property (nonatomic, assign) GLKVector4 color6;

- (void)draw;

@end