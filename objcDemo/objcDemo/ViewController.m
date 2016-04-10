//
//  ViewController.m
//  objcDemo
//
//  Created by crw on 4/7/16.
//  Copyright © 2016 crw. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat centerX = self.view.bounds.size.width/2.0f;
    CGFloat centerY = self.view.bounds.size.height/2.0f + 10;
    CGFloat radius  = (CGRectGetWidth([UIScreen mainScreen].bounds) - 55 * 2 - 5 * 2) * 0.5f;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:UIColor.clearColor.CGColor];
    [shapeLayer setStrokeColor:UIColor.blackColor.CGColor];
    [shapeLayer setLineWidth:1];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, centerY);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.view.frame), centerY);
    
    CGPathMoveToPoint(path, NULL, centerX, centerY);
    CGPathAddLineToPoint(path, NULL, centerX, self.view.bounds.size.height);
    
    CGPathMoveToPoint(path, NULL, centerX, 0);
    CGPathAddLineToPoint(path, NULL, centerX, centerY);
    
    CGPathMoveToPoint(path, NULL, centerX, centerY);
    CGPathAddArc(path, NULL, centerX, centerY, radius - 27.5,2 * M_PI, 0, YES);
    CGPathAddArc(path, NULL, centerX, centerY, radius,2 * M_PI, 0, YES);
    
    [shapeLayer setPath:path];
    
    [self.view.layer addSublayer:shapeLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
