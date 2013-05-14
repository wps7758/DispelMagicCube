//
//  GestureAnalysis.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture

@synthesize axis      = _axis;
@synthesize value     = _value;
@synthesize direction = _direction;
@synthesize isRotate  = _isRotate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)resolve: (CGPoint)p1: (CGPoint)p2 :(GLKMatrix4)centreMatrix
{
    CGFloat icube[3][3][3][6] = {0};
    CGFloat icubeChar[162] = {0};
    
    // 适当的偏移起始触摸点和结束触摸点
    // 修正手指宽度
    if (p1.x < p2.x && p2.x - p1.x < 50) {
        CGFloat pDiffX = p2.x - p1.x;
        p1.x -= (50 - pDiffX) * 0.5;
        p2.x += (50 - pDiffX) * 0.5;
    }
    else if (p2.x < p1.x && p1.x - p2.x < 50) {
        CGFloat pDiffX = p1.x - p2.x;
        p2.x -= (50 - pDiffX) * 0.5;
        p1.x += (50 - pDiffX) * 0.5;
    }
    
    if (p1.y < p2.y && p2.y - p1.y < 50) {
        CGFloat pDiffY = p2.y - p1.y;
        p1.x -= (50 - pDiffY) * 0.5;
        p2.x += (50 - pDiffY) * 0.5;
    }
    else if (p2.y < p1.y && p1.y - p2.y < 50) {
        CGFloat pDiffY = p1.y - p2.y;
        p2.x -= (50 - pDiffY) * 0.5;
        p1.x += (50 - pDiffY) * 0.5;
    }
    
    // 两点斜率
    CGFloat k = (p2.y - p1.y) / (p2.x - p1.x);
    
    // 确定两点构成的长方体平面
    CGFloat pMinX = p1.x < p2.x ? p1.x : p2.x;
    CGFloat pMaxX = p1.x > p2.x ? p1.x : p2.x;
    CGFloat pMinY = p1.y < p2.y ? p1.y : p2.y;
    CGFloat pMaxY = p1.y > p2.y ? p1.y : p2.y;
    
    // 围绕两点之间的线段，做随机离散点，减少误差
    // 统计点经过每个正方体每个面的次数
    for (NSInteger i = pMinX; i < pMaxX; ++i)
    {
        for (NSInteger j = pMinY; j < pMaxY; ++j)
        {
            if ((j-p1.y) - (k*(i-p1.x)) < 2 && (j-p1.y) - (k*(i-p1.x)) > -2)
            {
                GLint viewport[4];
                glGetIntegerv(GL_VIEWPORT, viewport);
                
                // 向左或向右偏移10像素，减少误差
                GLfloat x = i - 10 + arc4random()%21;
                // 向上或向下偏移10像素，减少误差
                GLfloat y = 480 - (j- 10 + arc4random()%21);
                
                GLubyte pixelColor[4] = {0};
                // Retina设备
                if (viewport[3] == 960) {
                    glReadPixels(x*2, y*2, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixelColor);
                }
                // 非Retina设备
                else if (viewport[3] == 480) {
                    glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixelColor);
                }
                // 暂不考虑iPhone5，touch5以上设备
                else {
                    NSLog(@"Error! Cann't recognize the devide.\n");
                }
                
                // alpha通道解析，得到每个正方体面的属性
                if (pixelColor[3] < 162) 
                {
                    NSInteger icubeX =  pixelColor[3] / 54;
                    NSInteger icubeY = (pixelColor[3] % 54) / 18;
                    NSInteger icubeZ = (pixelColor[3] % 18) / 6;
                    NSInteger icubeF =  pixelColor[3] % 6;
                    icube[icubeX][icubeY][icubeZ][icubeF] += 1.0;
                }
            }
        }
    }
    
    // 标记每个正方体的面
    // 在数组小数点中标记，0.ijkl1
    NSInteger a = 0;
    for (NSInteger i = 0; i < 3; ++i) 
    {
        for (NSInteger j = 0; j < 3; ++j)
        {
            for (NSInteger k = 0; k < 3; ++k) 
            {
                for (NSInteger l = 0; l < 6; ++l) 
                {
                    // 最后的+0.0001, 防止.99舍去误差
                    icubeChar[a++] = icube[i][j][k][l] + (CGFloat)i*0.1 + (CGFloat)j*0.01 
                    + (CGFloat)k*0.001 + (CGFloat)l*0.0001 + 0.00001;
                }
            }
        }
    }
    
    // 冒泡排序
    // 可优化，使用快速排序
    CGFloat temp = 0;
    for (NSInteger i = 0; i <= 162-1; ++i)
    {
        for (NSInteger j = 0; j <= 162-2; ++j)
        {
            if (icubeChar[j] < icubeChar[j+1])
            {
                temp = icubeChar[j];
                icubeChar[j] = icubeChar[j+1];
                icubeChar[j+1] = temp;
            }
        }
    }
    
    // 得到经过点最多的面和第二多的面
    NSInteger maxX1, maxY1, maxZ1, maxF1;
    NSInteger maxX2, maxY2, maxZ2, maxF2;
    
    // 解析正方体的面的属性
    maxX1 = ((NSInteger)(icubeChar[0] * 10000) % 10000) / 1000;
    maxY1 = ((NSInteger)(icubeChar[0] * 10000) % 1000)  / 100;
    maxZ1 = ((NSInteger)(icubeChar[0] * 10000) % 100)   / 10;
    maxF1 = ((NSInteger)(icubeChar[0] * 10000) % 10)    + 1;
    
    maxX2 = ((NSInteger)(icubeChar[1] * 10000) % 10000) / 1000;
    maxY2 = ((NSInteger)(icubeChar[1] * 10000) % 1000)  / 100;
    maxZ2 = ((NSInteger)(icubeChar[1] * 10000) % 100)   / 10;
    maxF2 = ((NSInteger)(icubeChar[1] * 10000) % 10)    + 1;
    
    NSLog(@"x1 is %d, y1 is %d, z1 is %d, f1 is %d. \n", maxX1, maxY1, maxZ1, maxF1);
    NSLog(@"x2 is %d, y2 is %d, z2 is %d, f2 is %d. \n", maxX2, maxY2, maxZ2, maxF2);
    
    // 如果线段经过的为同一平面
    if (maxF1 == maxF2 && maxF1 != 0)
    {
        self.isRotate = NO;
        if (maxX1 != maxX2 && maxY1 == maxY2 && maxZ1 == maxZ2) 
        {
            if (maxF1 == 5 || maxF1 == 6) 
            {
                // maxZ1固定, 绕z轴旋转
                self.axis   = 2;
                self.value  = maxZ1;
                self.isRotate = YES;
            }
            else 
            {
                // FACE1 FACE3
                // maxY1固定, 绕y轴旋转
                self.axis = 1;
                self.value = maxY1;
                self.isRotate = YES;
            }
        }
        else if (maxX1 == maxX2 && maxY1 != maxY2 && maxZ1 == maxZ2) 
        {
            if (maxF1 == 2 || maxF1 == 4)
            {
                // maxZ1固定, 绕z轴旋转
                self.axis = 2;
                self.value  = maxZ1;
                self.isRotate = YES;
            }
            else 
            {
                // FACE1 FACE3
                // maxX1固定, 绕x轴旋转
                self.axis = 0;
                self.value  = maxX1;
                self.isRotate = YES;
            }
        }
        else if (maxX1 == maxX2 && maxY1 == maxY2 && maxZ1 != maxZ2) 
        {
            if (maxF1 == 5 || maxF1 == 6)
            {
                // maxX1固定, 绕x轴旋转
                self.axis = 0;
                self.value  = maxX1;
                self.isRotate = YES;
            }
            else 
            {
                // FACE2 FACE4
                // maxY1固定, 绕y轴旋转
                self.axis = 1;
                self.value  = maxY1;
                self.isRotate = YES;
            }
        }
        
        if (_isRotate)
        {
            // 计算旋转方向
            self.direction = [self orientation:centreMatrix :_axis :p1 :p2];
        }
    }
}

// 根据中心立方体，计算旋转方向
- (NSInteger)orientation: (GLKMatrix4)centreMatrix: (NSInteger)axi: (CGPoint)p1: (CGPoint)p2
{
    CGPoint diff = CGPointMake(p1.x - p2.x, p1.y - p2.y);
    
    CGFloat rotX = -1 * GLKMathDegreesToRadians(diff.y);
    CGFloat rotY = -1 * GLKMathDegreesToRadians(diff.x);
    
    bool isInvertible;
    
    GLKVector3 xAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(centreMatrix, &isInvertible),
                                                 GLKVector3Make(1, 0, 0));
    GLKVector3 yAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(centreMatrix, &isInvertible),
                                                 GLKVector3Make(0, 1, 0));
    
    NSInteger dir = 0;
    
    if (axi == 0)
    {
        CGFloat directionX = xAxis.x * rotX + yAxis.x * rotY;
        dir = directionX > 0 ? -1 : 1;
    }
    else if (axi == 1)
    {
        CGFloat directionY = xAxis.y * rotX + yAxis.y * rotY;
        dir = directionY > 0 ? -1 : 1;
    }
    else if (axi == 2)
    {
        CGFloat directionZ = xAxis.z * rotX + yAxis.z * rotY;
        dir = directionZ > 0 ? -1 : 1;
    }
    
    return dir;
}

@end
