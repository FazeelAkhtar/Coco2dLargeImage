//
//  BackgroundLayer.h
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/29/13.//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollView.h"
#import "CCCustomMapImage.h"

@class CCCustomNode;
@interface MapTestLayer : CCLayer <CCScrollViewDelegate>
{
    
    CCCustomNode * sprite;
}


@property (nonatomic , strong) CCLayer * containLayer;
@property (nonatomic , strong) CCScrollView * myScrollView;;

+(CCScene *) scene;
@end
