//
//  Anim.h
//  Danceplanet
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewPlus.h"
#import "CAGradientLayerPlus.h"
#import "CAShapeLayerPlus.h"

@class Anim;
@class AnimController;

//extern AnimController <AnimDelegate> *kAnimController;

typedef void (^AnimationBlock)(UIView *view);



@protocol AnimDelegate

@property (strong) NSMutableArray *animDefinitions;
@property (weak) NSMutableArray *timelines;

- (void)runTimeline:(id)timeline completion:( void ( ^ )() )completion;
//- (void)runAnim:(Anim *)anim;

- (Anim *)animInGlobalBagNamed:(NSString *)name copy:(BOOL)copy;
- (void)deleteDuplicateAnimDefinitions;

@end



@interface Anim : NSObject <NSCopying> {
//    __strong NSMapTable *_viewReferences;
    
//    __strong NSMutableDictionary *_animStatusTable;
//    __strong NSMutableSet *_anims;
    
    __strong NSMutableArray *_views;
    __strong NSMutableArray *_startTimes;
    __strong NSMutableArray *_durations;
    __strong NSMutableArray *_endTimes;
}


//@property (weak) AnimController <AnimDelegate> *animController;


//@property (strong) NSMutableSet *anims;
//@property (weak) NSString *test;


// For anim units
@property (strong) NSString *name;
@property (strong) NSMutableArray *startTimes;
@property (strong) NSMutableArray *durations;
@property (strong) NSMutableArray *endTimes;
@property (copy) AnimationBlock animations;
@property UIViewAnimationOptions options;
@property (strong) NSMutableArray *views;
@property (strong) NSString *status;
@property BOOL indexOffset;


//+ (Anim *)a:(NSString *)name vs:(NSArray *)views d:(CGFloat)duration;
//+ (Anim *)a:(NSString *)name v:(UIView *)view d:(CGFloat)duration;
+ (Anim *)a:(NSString *)name vs:(NSArray *)views d:(CGFloat)duration;
+ (Anim *)a:(NSString *)name v:(UIView *)view d:(CGFloat)duration;
+ (Anim *)d_n:(NSString *)name;
+ (Anim *)di_n:(NSString *)name;
//+ (Anim *)d:(NSString *)name d:(CGFloat)duration;
//+ (Anim *)di:(NSString *)name d:(CGFloat)duration;
+ (Anim *)di:(CGFloat)duration;

//+ (AnimController *)aanimController;
+ (Anim *)_makeAnonymousDelayAnim:(NSNumber *)duration;
//+ (NSDictionary *)defAnim:(NSString *)name withView:(UIView *)view options:(UIViewAnimationOptions)options animations:( void (^)( UIView *view ) )animations;
//+ (NSDictionary *)defAnim:(NSString *)name withViews:(NSArray *)views options:(UIViewAnimationOptions)options animations:( void (^)( UIView *view ) )animations;
//+ (NSMutableDictionary *)rootAnim;

//+ (void)makeAnimSingleton;

+ (UIView *)_valueFromView:(UIView *)view;
+ (UIView *)_viewFromValue:(UIView *)view;

//+ (Anim *)anim:(NSString *)name view:(UIView *)view options:(UIViewAnimationOptions)options animations:(AnimationBlock)animations;
+ (Anim *)anim:(NSString *)name options:(UIViewAnimationOptions)options animations:(AnimationBlock)animations;

+ (void)runOneAnim:(NSString *)anim views:(NSArray *)views duration:(CGFloat)duration delay:(CGFloat)delay;
+ (void)runOneAnim:(NSString *)anim view:(UIView *)view duration:(CGFloat)duration delay:(CGFloat)delay;
+ (void)runTimelineArray:(NSArray *)timeline;
+ (void)runTimelineSet:(NSSet *)timeline;
+ (void)runTimelineArray:(NSArray *)timeline completion:( void ( ^ )() )completion;
+ (void)runTimelineSet:(NSSet *)timeline completion:( void ( ^ )() )completion;


//+ (void)manuallyAnimateView:(UIView *)view startTime:(CGFloat)startTime duration:(CGFloat)duration animations:(AnimationBlock)animations;
- (void)assignMyDuration:(CGFloat)duration;
//+ (UIView *)getViewFromUUID:(NSUUID *)uuid;

+ (AnimController *)animCon;
+ (void)setAnimCon:(AnimController *)animCon;
@end
