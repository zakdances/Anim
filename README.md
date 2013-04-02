Anim
====

The iOS Animation Manager

Anim allows you to create simple, declarative timelines which can run complex chains of user interface animation as defined by you.

![Anim demo](/blob/master/AnimTest/anim.gif?raw=true)


History and Purpose

After much searching, I was surprised at my failure to find any sort of animation management library for Objective-C. 
The current best practice for creating sequential animation is to nest your animations in blocks. This can get really ugly as anyone who has attempted this can attest. Anim is a way to create, purely with Objective C code, a cool almost ASCII-like horizontal timeline of animation like the type you might find in a program like Adobe After Effects. Over the course of its development, Anim has been influenced by event-based sequencing projects such as ReactiveCocoa, ifttt, and interesting new animation projects like Adobe's Edge.

Core Principle

Anim consists of 2 parts, Anims and Timelines. Anims represent units of time which can contain either animations or emptiness (delays). After defining an Anim, you create instances of it and assign your views to those instances. You can create multiple instances of any anim and assign different views and durations to each.  Anims are instantiated by placing them in Timelines, which are not special objects, but basic NSArrays (for sequential play) or NSSets (for simultaneous play) which you create. The timeline will play its contents of Anims from left to right. Timelines can contain other nested timelines.

Underlying technology

Understand Anim on a deeper level. There's a few things that'll probably set Anim apart from other animation managing libraries:

 - Anim start and end times are calculated individually for each view in every Anim. Many other libraries will, most likely, have each animation listen for the preceding animation to fire some sort of "I'm finished!" event. That's not how Anim works. This allows Anim more flexibily to, for example, assign negative numbers as delays to create overlaps. The Anim motto: dynamic time calculation, not dependencies.
 
 - The trickiest part of making Anim was the "pathing". To calculate start times for each view, Anim has to walk the timeline, which is essentially a "node tree" consisting of nested arrays, sets, and Anim objects. Each Anim needs the relevant path walked to accurately calculate which other anims precedes it, and their respective durations and start times. 
 
 I'm pretty far from being a math whiz, so my approach to pathing is rudimentary. If you can improve, please do so! Pull requests welcome.
 


Syntax

Step 1 // Define an Anim

```
// Create a name, options, and an animation block for your Anim definition.

[Anim anim:@"slideUp" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.y += -100;
        view.height += 100;
    }];
```
    
    
    
This will place the definition in a global bag. Please notice how you don't assign views, delays, or durations. That's because, in the Anim world, animations are defined seperately from views and durations. You assign those when you instantiate Anims in your timeline. Also in the Anim world, delays are created as seperate Anims, not as attributes (with one small caveat, as you'll see later).

Step 2 // Create a timeline and instantiate Anims inside...then run your timeline.

Choose either a NSArray (sequential play) or NSSet (simultaneous play) to represent your timeline.

```
// Create a name, options, and an animation block for your Anim definition.

[Anim anim:@"slideUp" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.y += -100;
        view.height += 100;
    }];
    
[Anim anim:@"slideOver" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.x += 50;
        view.width += 50;
    }];
    
// This timeline will play from left to right. You don't need to define delay Anims seperately...you just instantiate them
// with a NSNumber literal.

NSArray *timeline = @[ [Anim a:@"slideUp" vs:myViews d:.6] , @.2 , [Anim a:@"slideOver" vs:myViews d:.2] ];
   
[Anim runTimelineArray:timeline];

```

Your timeline will run now. Great job.

Here's another timeline example that demonstrates a bit more complexity:

```
// This NSSet-type timeline contains, at root level, 2 nested timeline arrays (each with their own Anims) and 1 Anim. 
// Because it's a NSSet instead of a NSArray, each root item will start simultaneously.

NSSet *timeline = [NSSet setWithObjects:
//                     Nested SubTimeline 1
                       @[ [Anim a:@"slideUp" vs:buttonBoxes d:.6] , [Anim a:@"rotate" v:myLabel d:.5] ] ,
//                     Nested SubTimeline 2
                       @[ @.2 , [Anim a:@"fadeIn" vs:buttonBoxes d:.2] ] ,
//                     A beautiful glow animation
                       [Anim a:@"glow" vs:buttonBoxes d:5] ,
                        nil];

[Anim runTimelineSet:timeline];
```

Extra Features

Index Offset Delays

If you place a number wrapped in a string directly in front of an Anim that contains animations, Anim will assign each view in the that following Anim a delay of that number multiplayed by the views index.

```NSArray *timeline = @[  @".2" , [Anim a:@"spin" vs:myViews d:.2] ];```

Negative Delays

You can give any delay Anim a negative duration! Create interesting overlapping animations. Obviously it won't work if it's first in a timeline.

Reuse Anims

Once an Anim is defined, its globally available to your timelines across all view controllers. You can instantiate it where ever you want and assign it new views and durations.

Run One Anim

Just want to run a single Anim? There's a convenience method for you:

```
[Anim runOneAnim:@"highlight" view:myView duration:2 delay:0];
```

