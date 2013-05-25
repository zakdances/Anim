//
//  Anim.m
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

//#import "Anim.h"
//#import "ReactiveCocoa.h"
#import "AnimController.h"
//typedef void (^ArrayOp)(NSMutableArray *array);
//typedef void (^SetOp)(NSMutableSet *set);
//typedef void (^DictionaryOp)(NSMutableDictionary *dictionary);
//typedef void (^AnimationBlock)(UIView *view);
//AnimController *kAnimController = nil;

@implementation Anim

static AnimController <AnimDelegate> *_animCon;

- (id)init
{
    if ((self = [super init]))
    {
//        _delegate = [AnimController new];
    
    }
    return self;
}















+ (Anim *)anim:(NSString *)name options:(UIViewAnimationOptions)options animations:(AnimationBlock)animations
{
//    [Anim makeAnimSingleton];

    Anim *anim = [Anim new];    
//    TODO: make getters/setters for these
    anim.name = name;
    anim.startTimes = [NSMutableArray array];
    anim.options = options;
    anim.animations = animations;
    anim.indexOffset = NO;
    
    [anim views];
    [anim startTimes];
    [anim durations];

    
    


    

    

    [Anim.animCon.animDefinitions addObject:anim];
    [Anim.animCon deleteDuplicateAnimDefinitions];
    return anim;
}

//+ (Anim *)anim:(NSString *)name view:(UIView *)view options:(UIViewAnimationOptions)options animations:(AnimationBlock)animations
//{
//    return [Anim anim:name views:@[view] options:options animations:animations];
//}





// Retreive anim
+ (Anim *)a:(NSString *)name vs:(NSArray *)views d:(CGFloat)duration
{
//    [self makeAnimSingleton];
  //  duration = duration ? : 0.0;
//    NSLog(@"anims defined: %@",Anim.animCon.animDefinitions);
    Anim *anim = [Anim.animCon animInGlobalBagNamed:name copy:YES];
    if (!anim) {
        [NSException raise:@"No anim definition found for that name" format:@"Make sure you've defined an anim with the name '%@'", name];
    }

    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        [anim.views addObject:[Anim _valueFromView:view]];
        anim.startTimes[idx] = @0.0;
        
    }];

    
    [anim.startTimes enumerateObjectsUsingBlock:^(NSNumber *startTime, NSUInteger idx, BOOL *stop) {
        anim.durations[idx] = [NSNumber numberWithFloat:duration];

        if (!(anim.indexOffset && anim.views.count == 0)) {
            anim.endTimes[idx] = [NSNumber numberWithFloat: [startTime floatValue] + duration ];
        }
        
    }];
//    [anim assignMyDuration:duration];
    
//    [kAnimController deleteDuplicateAnimDefinitions];
    return anim;
}


+ (Anim *)a:(NSString *)name v:(UIView *)view d:(CGFloat)duration
{
    return [Anim a:name vs:@[view] d:duration];
}

//+ (Anim *)d:(CGFloat)duration
//{
//    Anim *anim = [[Anim anim:name options:0 animations:nil] copy];
//   
//    anim.durations = [@[[NSNumber numberWithFloat:duration]] mutableCopy];
//    return anim;
//}

+ (Anim *)d_n:(NSString *)name
{
    return [Anim a:name vs:nil d:0];
}
+ (Anim *)di_n:(NSString *)name
{
//    Anim *anim = [Anim a:name vs:nil d:nil];
//    anim.indexOffset = YES;
    return [Anim a:name vs:nil d:0];
}
+ (Anim *)di:(CGFloat)duration
{
    Anim *anim = [Anim _makeAnonymousDelayAnim:[NSNumber numberWithFloat:duration]];
    anim.indexOffset = YES;
    return anim;
}


+ (Anim *)_makeAnonymousDelayAnim:(NSNumber *)duration
{
    Anim *anim = [[Anim anim:nil options:0 animations:nil] copy];
    anim.durations[0] = duration;
    return anim;
}
//+ (Anim *)d:(NSString *)name d:(CGFloat)duration
//{
//    Anim *anim = [[Anim anim:name options:0 animations:nil] copy];
////    [anim assignMyDuration:duration];
//    anim.durations = [@[[NSNumber numberWithFloat:duration]] mutableCopy];
//    return anim;
//}
//
//+ (Anim *)di:(NSString *)name d:(CGFloat)duration
//{
//    Anim *anim = [Anim d:name d:duration];
//    anim.indexOffset = YES;
//    return anim;
//}






+ (void)runTimelineArray:(NSArray *)timeline
{
    [Anim runTimelineArray:timeline completion:nil];
}
+ (void)runTimelineSet:(NSSet *)timeline
{
    [Anim runTimelineSet:timeline completion:nil];
    
}

+ (void)runTimelineArray:(NSArray *)timeline completion:( void ( ^ )() )completion
{
    [Anim.animCon runTimeline:timeline completion:completion];
}
+ (void)runTimelineSet:(NSSet *)timeline completion:( void ( ^ )() )completion
{
    [Anim.animCon runTimeline:timeline completion:completion];
}

+ (void)runOneAnim:(NSString *)anim views:(NSArray *)views duration:(CGFloat)duration delay:(CGFloat)delay
{
//    NSLog(@"imported duration %f",duration);
//    Anim *myAnim = [Anim.animCon animInGlobalBagNamed:anim copy:YES];
    Anim *myAnim = [Anim a:anim vs:views d:duration];
    
//    myAnim.views = [views mutableCopy];
//    for (int i = 0; i < myAnim.views.count; i++) {
//        myAnim.durations[i] = duration ? [NSNumber numberWithFloat:duration] : @0.0;
//        myAnim.startTimes[i] = [NSNumber numberWithFloat:0];
//        
//    }
    
//    if ((!duration || duration == 0) && (!delay || delay == 0)) {
//        
//
//            [Anim.animCon runAnim:myAnim];
//            return;
//
//    }

    
    
    NSArray *timelineArray = @[[NSNumber numberWithFloat:delay],myAnim];
//    NSLog(@"running: %@",myAnim.durations[0]);
    [Anim runTimelineArray:timelineArray];
}

+ (void)runOneAnim:(NSString *)anim view:(UIView *)view duration:(CGFloat)duration delay:(CGFloat)delay
{
    [Anim runOneAnim:anim views:@[view] duration:duration delay:delay];
}














//    
//    __weak Anim *this = self;
//    ArrayOp arrayOp = ^(NSMutableArray *array) {
//        
//    };
//    SetOp SetOp = ^(NSMutableSet *set) {
//        
//    };
//    DictionaryOp dictionaryOp = ^(NSMutableDictionary *dictionary) {
//        if (!dictionary[@"delay"]) {
//            
//        }
//    };




//- (void)scanSet:(NSMutableArray *)set
//{
//    [set enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [self scanUnknownObjects:obj];
//    }];
//}
//
//- (void)scanDictionary:(NSMutableDictionary *)dictionary
//{
//    
//}
//
//- (int)scanUnknownObjects:(id)obj
//{
//    NSMutableArray *array = [obj isKindOfClass:[NSMutableArray class]] ? obj : nil;
//    NSMutableSet *set = [obj isKindOfClass:[NSMutableSet class]] ? obj : nil;
//    NSMutableDictionary *dictionary = [obj isKindOfClass:[NSMutableDictionary class]] ? obj : nil;
//    
//    if (array) {
//        return 1;
//    }
//    else if (set) {
//        return 2;
//    }
//    else if (dictionary) {
//        return 3;
//    }
//    
//    
//    return 0;
//}







- (void)start
{
//    Send RAC signal
  //  NSString *test = @"asd";
//    self.test = test;
}












- (void)assignMyDuration:(CGFloat)duration
{
    if (duration) {
        if (self.views.count == 0) {
            
            self.durations = [@[[NSNumber numberWithFloat:duration]] mutableCopy];
        }
        else {
            for (int i = 0; i < self.views.count; i++) {
                self.durations[i] = [NSNumber numberWithFloat:duration];
            }
        }
    };
}


//+ (NSArray *)findAnimsInTimeline:(id)obj bucket:(NSMutableSet *)bucket
//{
//
//    NSArray *colClasses = @[ [NSArray class], [NSDictionary class], [NSSet class] ];
//    NSArray *array = [obj isKindOfClass:colClasses[0]] ? obj : nil;
//    NSDictionary *dictionary = (!array && [obj isKindOfClass:colClasses[1]]) ? obj : nil;
//    NSSet *set = (!array && !dictionary && [obj isKindOfClass:colClasses[2]]) ? obj : nil;
//    Anim *anim = (!array && !dictionary && !set && [obj isKindOfClass:[Anim class]]) ? obj : nil;
//    
//
//
//    if (array) {
//        for (id obj in array) {
//            [Anim findAnimsInTimeline:obj bucket:bucket];
//        }
//        return array;
//    } else if (dictionary) {
//        for (id key in dictionary) {
//            [Anim findAnimsInTimeline:dictionary[key] bucket:bucket];
//        }
//        
//        return dictionary;
//    } else if (set) {
//        for (id obj in set) {
//            [Anim findAnimsInTimeline:obj bucket:bucket];
//        }
//        return set;
//    } else if (anim) {
//
//
//        [bucket addObject:obj];
//        return obj;
//    } else {
//        return obj;
//    }
//}

           
//+ (id)deepMutableCopy:(id)item removeEmpties:(BOOL)removeEmpties
//{
//   
//   NSArray *colClasses = @[ [NSArray class], [NSDictionary class], [NSSet class] ];
//
//   NSArray *array = [item isKindOfClass:colClasses[0]] ? item : nil;
//   NSDictionary *dictionary = (!array && [item isKindOfClass:colClasses[1]]) ? item : nil;
//   NSSet *set = (!array && !dictionary && [item isKindOfClass:colClasses[2]]) ? item : nil;
//
//
//    
//
//
//   if (array) {
//       NSMutableArray *newArray = [NSMutableArray new];
//       for (id obj in array) {
//          
//               [newArray addObject:[self deepMutableCopy:obj removeEmpties:removeEmpties]];
//           
//       }
//       return newArray;
//   } else if (dictionary) {
//       NSMutableDictionary *newDictionary = [NSMutableDictionary new];
//       for (id key in dictionary) {
//           id value = dictionary[key];
//           
//           [newDictionary setObject:[self deepMutableCopy:value removeEmpties:removeEmpties] forKey:key];
//           
//       }
//       return newDictionary;
//   } else if (set) {
//       NSMutableSet *newSet = [NSMutableSet set];
//       for (id obj in set) {
//          
//              [newSet addObject:[self deepMutableCopy:obj removeEmpties:removeEmpties]];
//           
//       }
//       return newSet;
//   } else {
//       return item;
//   }
//}











//+ (UIView *)getViewFromUUID:(NSUUID *)uuid
//{
//    return uuid ? [kAnim.viewReferences objectForKey:uuid] : nil;
//}






//- (NSMapTable *)viewReferences
//{
//    self.viewReferences = _viewReferences ? : [NSMapTable weakToWeakObjectsMapTable];
//    return _viewReferences;
//}
//- (void)setViewReferences:(NSMapTable *)viewReferences {_viewReferences = viewReferences;}




//+ (AnimController *)animController
//{
//    if (!kAnimController) {
//        kAnimController = [AnimController new];
//    }
//    return kAnimController;
//}
//+ (void)animController:(AnimController *)animController
//{
//    kAnimController = animController;
//}
+ (UIView *)_valueFromView:(UIView *)view
{
//    NSValue *value = [NSValue valueWithNonretainedObject:view];
    return view;
}
+ (UIView *)_viewFromValue:(UIView *)view
{
    //    NSValue *value = [NSValue valueWithNonretainedObject:view];
    return view;
}
//- (NSMutableDictionary *)animStatusTable
//{
//    self.animStatusTable = _animStatusTable ? : [NSMutableDictionary dictionary];
//    return _animStatusTable;
//}
//- (void)setAnimStatusTable:(NSMutableDictionary *)animStatusTable{_animStatusTable = animStatusTable;}

- (id)copyWithZone:(NSZone *)zone
{
	Anim *animCopy = [[Anim allocWithZone: zone] init];
    
	animCopy.animations = [self.animations copy];
    animCopy.name = [self.name copy];
    animCopy.indexOffset = self.indexOffset ? YES : NO;
    animCopy.options = self.options;
	animCopy.durations = [self.durations mutableCopy];
	
    
	return animCopy;
}



+ (AnimController *)animCon {
    if (!_animCon) {
        _animCon = [AnimController new];
    }
    return _animCon;
}

+ (void)setAnimCon:(AnimController *)animCon
{
    _animCon = animCon;
}


- (NSMutableArray *)views
{
    _views = _views ? : [NSMutableArray array];
    return _views;
}
- (void)setViews:(NSMutableArray *)views {_views = views;}


- (NSMutableArray *)startTimes
{
    _startTimes = _startTimes ? : [@[@0.0] mutableCopy];
    return _startTimes;
}
- (void)setStartTimes:(NSMutableArray *)startTimes {_startTimes = startTimes;}

- (NSMutableArray *)durations
{
    _durations = _durations ? : [@[@0.0] mutableCopy];
    return _durations;
}
- (void)setDurations:(NSMutableArray *)durations {_durations = durations;}

- (NSMutableArray *)endTimes
{
    _endTimes = _endTimes ? : [@[@0.0] mutableCopy];
    return _endTimes;
}
- (void)setEndTimes:(NSMutableArray *)endTimes {_endTimes = endTimes;}
@end
