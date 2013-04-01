Anim
====

The iOS Animation Manager

Anim allows you to create simple, declarative timelines which can run complex chains of user interface animation as defined by you.

History and Purpose

After much searching, I was surprised at my failure to find any sort of animation management library for Objective-C. 
The current best practice for creating sequential animation is to nest your animations in blocks. This can get really ugly as anyone who has attempted this can attest. Anim is a way to create, purely with Objective C code, a cool almost ASCII-like horizontal timeline of animation like the type you might find in a program like Adobe After Effects. Over the course of its development, Anim has been influenced by event-based sequencing projects such as ReactiveCocoa, ifttt, and interesting new animation projects like Adobe's Edge.

Core Principle

Anim consists of 2 parts, Anims and Timelines. Anims represent units of time which can contain either animations or emptiness (delays). After defining an Anim, you create instances of it and assign your views to those instances. You can create multiple instances of any anim and assign different views and durations to each.  Anims are instantiated by placing them in Timelines, which are not special objects, but basic NSArrays (for sequential play) or NSSets (for simultaneous play) which you create. The timeline will play its contents of Anims from left to right. Timelines can contain other nested timelines.


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
    
// This timeline will play from left to right. The can also be a NSSet, which will play all Anim instances simultaneously. You don't need to define delay Anims seperately...you just instantiate them with a NSNumber literal.
NSArray *timeline = @[ [Anim a:@"slideUp" vs:myViews d:.6] , @.2 , [Anim a:@"slideOver" vs:myViews d:.2] ];
   
[Anim runTimelineArray:timeline];

    ```

Your timeline will run now. Great job.

Here's another timeline example that demonstrates a bit more complexity:

```
// This NSSet-type timeline contains, at root level, 2 nested timeline arrays (each with their own Anims) and 1 Anim. Because its a NSSet instead of a NSArray, each root item will start simultaneously.
NSSet *timeline = [NSSet setWithObjects:
                       @[ [Anim a:@"slideUp" vs:buttonBoxes d:.6] , [Anim a:@"rotate" d:.5] ] ,
                       @[ @.2 , [Anim a:@"fadeIn" vs:buttonBoxes d:.2 i:.2] ] ,
                       [Anim a:@"glow" d:5] ,
                        nil];

[Anim runTimelineSet:timeline];
```


Index Offsets

If you place a number wrapped in a string directly in front of an Anim that contains animations, Anim will assign each view in the that following Anim a delay of that number multiplayed by the views index.

```NSArray *timeline = @[  @".2" , [Anim a:@"slideOver" vs:myViews d:.2] ];```


