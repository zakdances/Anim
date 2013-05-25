//
//  AnimController.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Anim.h"


@interface AnimController : NSObject <AnimDelegate> {
    __strong NSMutableArray *_animDefinitions;
    __weak NSMutableArray *_timelines;
}

// TODO: should be private (protocol only)
@property (strong) NSMutableArray *animDefinitions;
@property (weak) NSMutableArray *timelines;

@end
