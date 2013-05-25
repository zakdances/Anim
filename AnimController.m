//
//  AnimController.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import "AnimController.h"

@implementation AnimController


- (void)runTimeline:(id)timeline completion:( void ( ^ )() )completion
{
    
    NSDictionary *info = [self calculateStartTimes:timeline];
    
    NSMutableArray *animationAnims = info[@"animationAnims"];
    NSMutableArray *anims = info[@"allAnims"];
//    Remove all delay anims with index offset
    [anims filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Anim *evaluatedAnim, NSDictionary *bindings) {
        if (evaluatedAnim.indexOffset && evaluatedAnim.views.count == 0) {
            return NO;
        }
        return YES;
    }]];

    

    NSMutableArray *IndividualAnimationsOrDelaysArray = [NSMutableArray array];
    
    for (Anim *anim in anims) {

        [anim.durations enumerateObjectsUsingBlock:^(NSNumber *duration, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *IndividualAnimationOrDelay = [NSMutableDictionary dictionary];
            
            if (anim.views.count > 0) {
                IndividualAnimationOrDelay[@"view"] = anim.views[idx];
            }
         
           IndividualAnimationOrDelay[@"startTime"] = anim.startTimes[idx];
           IndividualAnimationOrDelay[@"duration"] = duration;
           IndividualAnimationOrDelay[@"endTime"] = anim.endTimes[idx];
         
           
               [IndividualAnimationsOrDelaysArray addObject:IndividualAnimationOrDelay];
           
        }];
    };
    
    
    [IndividualAnimationsOrDelaysArray sortUsingComparator:^NSComparisonResult(NSMutableDictionary *a, NSMutableDictionary *b) {
        NSNumber *endTimeA = a[@"endTime"];
        NSNumber *endTimeB = b[@"endTime"];
        return [endTimeA compare:endTimeB];
    }];
    
    
    
    
    CGFloat endOfTimeline = [[IndividualAnimationsOrDelaysArray lastObject][@"endTime"] floatValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, endOfTimeline * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        };
        
    });
    
//    TODO: times need to be rounded
//    NSLog(@"all animations sorted: %@",IndividualAnimationsOrDelaysArray);
//    NSArray *sortedArray = [anims sortedArrayUsingComparator:^NSComparisonResult(Anim *a, Anim *b) {
//        NSMutableDictionary *viewMetaData = [NSMutableDictionary dictionary];
//        [a.views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            
//        }];
//        
//        
//        NSDate *first = [(Person*)a birthDate];
//        NSDate *second = [(Person*)b birthDate];
//        return [first compare:second];
//    }];
    
    for (Anim *anim in animationAnims) {
        
        [self runAnim:anim];
        
    };
}




- (NSDictionary *)calculateStartTimes:(id)rootItem
{
//    NSLog(@"anims defined: %@",Anim.animCon.animDefinitions);
    NSMutableDictionary *info = [@{ @"rootItem" : rootItem } mutableCopy];
    info = [self _calculateStartTimes:info pathKey:nil];
    return [info copy];
    
}




- (NSMutableDictionary *)_calculateStartTimes:(NSMutableDictionary *)info pathKey:(NSUUID *)pathKey
{
    
    Class containerClass = info[@"_containerClass"];
    
    // TODO: can this be done without need to loop through all?
    id item = info[@"_item"] ? : info[@"rootItem"];
    NSArray *array = [item isKindOfClass:[NSArray class]] ? item : nil;
    NSSet *set = !array && [item isKindOfClass:[NSSet class]] ? item : nil;
    Anim *anim = nil;

    if (!array && !set) {
        if ([item isKindOfClass:[NSNumber class]]) {
            anim = [Anim _makeAnonymousDelayAnim:item];
        }
        else if ([item isKindOfClass:[Anim class]]) {
            anim = item;
        }
    };
//    anim = !array && !set && !anim && [item isKindOfClass:[Anim class]] ? item : nil;
    

    
    pathKey = pathKey ? : [NSUUID UUID];
    NSMutableDictionary *paths = info[@"_paths"] ? : [@{ pathKey : [NSMutableArray array] } mutableCopy];
    NSMutableArray *pastAnims = paths[pathKey];
    
    //    NSLog(@"past anims: should NEVER be null: %@",pastAnims);
    if (containerClass == [NSSet class]) {
        pathKey = [NSUUID UUID];
        pastAnims = [pastAnims mutableCopy];
        paths[pathKey] = pastAnims;
        info[@"_paths"] = paths;
    }
    
    
    NSMutableArray *allAnims = info[@"allAnims"] ? : [NSMutableArray array];
    NSMutableArray *animationAnims = info[@"animationAnims"] ? : [NSMutableArray array];
    NSMutableArray *delayAnims = info[@"delayAnims"] ? : [NSMutableArray array];
    
    
    
    
    if (!array && !set && !anim) {
        //        TODO: raise exception here
        NSLog(@"uh...something passed here that's not supposed to be.");
        NSLog(@"evil thing: %@",[item class]);
    };
    
    
    
    
    
    
    
    
    
    if (array || set) {
        
        if (array) {
            containerClass = [NSArray class];
        }
        else if (set) {
            containerClass = [NSSet class];
        }
        
        info[@"_containerClass"] = containerClass;
        
        id collection = item;
        for (id child in collection) {
            info[@"_item"] = child;
            info = [self _calculateStartTimes:info pathKey:pathKey];
            
        }
        
        //      TODO: Why do you work? Why does this need to be called?
        return info;
    }
    else if (anim) {
        
        
        

        
        
//        anim.endTimes[0] = [NSNumber numberWithFloat:[anim.startTimes[0] floatValue] + [anim.durations[0] floatValue]];
        [anim.durations enumerateObjectsUsingBlock:^(NSNumber *duration, NSUInteger idx, BOOL *stop) {
    
            CGFloat newStartTime = 0;
            for (Anim *pastAnim in pastAnims) {
                CGFloat pastDuration = [pastAnim.durations[0] floatValue];
                newStartTime += pastAnim.indexOffset ? pastDuration * idx : pastDuration;
//                BOOL pastAnimIndexOffset = pastAnim.indexOffset;
            };

            anim.startTimes[idx] = [NSNumber numberWithFloat:newStartTime];
            if (!(anim.indexOffset && anim.views.count == 0)) {
                anim.endTimes[idx] = [NSNumber numberWithFloat: newStartTime + [duration floatValue] ];
            }
            else {
                anim.endTimes[idx] = anim.startTimes[idx];
            }
            
        }];
        
        
        
        [pastAnims addObject:anim];
        
        
        
        
        [allAnims addObject:anim];
        if (anim.views.count > 0) {
            [animationAnims addObject:anim];
        }
        else {
            [delayAnims addObject:anim];
        }
        
        // _____________________
        
        
        
        
    };
    
    
    
    
    //    TODO: repetiion...
    paths[pathKey] = pastAnims;
    info[@"_paths"] = paths;
    
    info[@"allAnims"] = allAnims;
    info[@"animationAnims"] = animationAnims;
    info[@"delayAnims"] = delayAnims;
    
    
    
    
    return info;
    
}





- (void)runAnim:(Anim *)anim
{
    //    NSLog(@"running anim: %@", anim.name);
    //    NSLog(@"at: %@",anim.startTimes[0]);

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
//        NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
//    });
    [anim.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        
        view = [Anim _viewFromValue:view];
        //            NSLog(@"view gotten!");
        if (!view) {
            NSLog(@"view is nill");
        }
        else {
            //            Retreiving start time and duration for view
            CGFloat startTime = [anim.startTimes[idx] floatValue];
            CGFloat duration = [anim.durations[idx] floatValue];
            
            [self manuallyAnimateView:view startTime:startTime duration:duration options:anim.options animations:anim.animations];
        }
    }];
    
}



- (void)manuallyAnimateView:(UIView *)view startTime:(CGFloat)startTime duration:(CGFloat)duration options:(UIViewAnimationOptions)options animations:(AnimationBlock)animations
{
    //    __weak UIView *weakView = view;
    
    animations = [animations copy];
  //  NSLog(@"view: %@",view);
    //    Anim *anim = [kAnim copy];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, startTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
    
//    NSLog(@"got this far...");
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        animations(view);
       // view.layer.transform = CATransform3DIdentity;
      //  view.alpha = 1;
    } completion:^(BOOL finished) {
        //            NSLog(@"animation done!...");
    }];
    
    });
 
}



- (Anim *)animInGlobalBagNamed:(NSString *)name copy:(BOOL)copy
{
    __block Anim *anim = nil;
    
    //    kAnimController.animDefinitions en
    [self.animDefinitions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Anim *searchedAnim = obj;
        
//        BOOL match = NO;
//        if ([searchedAnim.name isKindOfClass:[NSString class]]) {
//            match = [searchedAnim.name isEqualToString:name];
//        }
//        else {
//            [searchedAnim.name isEqual:name]
//        }
        if ([searchedAnim.name isEqualToString:name]) {
            anim = searchedAnim;
            *stop = YES;
            return;
        }
    }];
    

    
    
    return copy ? [anim copy] : anim;
}




- (void)deleteDuplicateAnimDefinitions
{
    //    NSMutableArray *names = [NSMutableArray array];
    //    NSMutableSet *naames = [NSMutableSet set];
    
    
    NSCountedSet *names = [NSCountedSet set];
    __block int anonymousNames = 0;

    
    NSArray *animDefinitions = [self.animDefinitions copy];
    [animDefinitions enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Anim *animDef = obj;
        NSString *existingName = animDef.name;

        if ([names countForObject:existingName] > 0 || (!existingName && anonymousNames > 0)) {
            [self.animDefinitions removeObject:animDef];
            return;
        }
        

        if (existingName) {
            [names addObject:existingName];
        }
        else {
            anonymousNames += 1;
        }
     
    }];
    
//    [animDefinitions enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, BOOL *stop) {

    
}



- (NSMutableArray *)animDefinitions
{
    if (!_animDefinitions) {
        _animDefinitions = [NSMutableArray array];
    }
    return _animDefinitions;
}
- (void)setAnimDefinitions:(NSMutableArray *)animDefinitions {_animDefinitions = animDefinitions;}

- (NSMutableArray *)timelines
{
    if (!_timelines) {
        _timelines = [NSMutableArray array];
    }
    return _timelines;
}
- (void)setTimelines:(NSMutableArray *)timelines {_timelines = timelines;}
@end
