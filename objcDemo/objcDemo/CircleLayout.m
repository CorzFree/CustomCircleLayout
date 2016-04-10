//
//  CircleLayout.m
//  objcDemo
//
//  Created by crw on 4/7/16.
//  Copyright © 2016 crw. All rights reserved.
//代码是看着http://www.jianshu.com/p/455981779117重新敲了一遍

#import "CircleLayout.h"
#define ItemWidth 55
#define ItemHieght ItemWidth
#define RightMargin 5

@interface CircleLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) CGFloat angle;

@end

@implementation CircleLayoutAttributes

- (instancetype)init {
    if (self = [super init]) {
        self.angle = 0;
    }
    return self;
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    
    self.zIndex = angle * -1000000;
    // 将角度同时用做item 的旋转
    self.transform = CGAffineTransformMakeRotation(angle);
}

// UICollectionViewLayoutAttributes 实现 <NSCoping> 协议
- (id)copyWithZone:(NSZone *)zone {
    CircleLayoutAttributes *copyAttributes = (CircleLayoutAttributes *)[super copyWithZone:zone];
    copyAttributes.angle = self.angle;
    return copyAttributes;
}


@end

@interface CircleLayout()

@property (nonatomic, assign) CGFloat     radius;
@property (nonatomic, assign) CGSize      itemSize;
@property (nonatomic, assign) CGFloat     anglePerItem;///< 单位夹角
@property (nonatomic, copy  ) NSArray<CircleLayoutAttributes *> *attributesList;
@property (nonatomic, assign) CGFloat     offsetAngle;

@end

@implementation CircleLayout

- (instancetype)init {
    if (self = [super init]) {
        [self initSelf];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf {
    self.itemSize     = CGSizeMake(ItemWidth, ItemHieght);
    self.radius       = (CGRectGetWidth([UIScreen mainScreen].bounds) - ItemWidth * 2 - RightMargin * 2) * 0.5f;
    self.anglePerItem = M_PI / 4.0;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.bounds) * .5f;
    CGFloat centerY = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.bounds) * .5f;
    
    NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *mAttributesList = [NSMutableArray arrayWithCapacity:numberOfItem];
    
    for (NSInteger index = 0; index < numberOfItem; index++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        CircleLayoutAttributes *attributes = [CircleLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = self.itemSize;
        
        CGFloat changeAngle =  M_PI + M_PI_4;
        attributes.center = CGPointMake(
                                        centerX + self.radius * cosf(-(self.anglePerItem*index + self.offsetAngle - changeAngle)),
                                        centerY + self.radius * sinf(-(self.anglePerItem*index + self.offsetAngle - changeAngle))                                        );
        
        attributes.angle = -(self.anglePerItem * index + self.offsetAngle - changeAngle);
        
        if (attributes.angle <= - M_PI / 6) {
            CGFloat alpha = ((M_PI / 6 + M_PI/6) + attributes.angle)/(M_PI/6);
            attributes.alpha = alpha;
        } else if (attributes.angle > M_PI + M_PI/4) {
            CGFloat alpha = (M_PI + M_PI/4 + M_PI/6 - attributes.angle) / (M_PI/6);
            attributes.alpha = alpha;
        }
        
        [mAttributesList addObject:attributes];
    }
    self.attributesList = [mAttributesList copy];
}

- (CGFloat)offsetAngle{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems > 0) {
        NSInteger lastItem = numberOfItems - 7;
        //滚动的总度数
        CGFloat angleTotal = lastItem * self.anglePerItem;
        //计算collectionView滑动的距离
        CGFloat offsetWidth = self.collectionView.contentSize.width - self.collectionView.bounds.size.width;
        //偏移的度数 ＝ 滚动的总度数 / contentOffsetX所占的比例，即 result = angleTotal * (contentOffsetX / offsetWidth)
        //(contentOffsetX / offsetWidth)为单位偏移量所占的比例
        return -angleTotal * (self.collectionView.contentOffset.x / offsetWidth);
    }
    return 0;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesList;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.attributesList[indexPath.row];
}

- (CGSize)collectionViewContentSize{
    NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(ItemWidth * numberOfItem, self.collectionView.bounds.size.height);
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

+ (Class)layoutAttributesClass{
    return [CircleLayoutAttributes class];
}

@end
