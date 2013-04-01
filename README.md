Anim
====

The iOS Animation Manager

Anim allows you to create simple, declarative timelines which can run complex chains of user interface animation as defined by you.

History and Purpose

After much searching, I was surprised at my failure to find any sort of animation management library for Objective-C. 
The current best practice for creating sequential animation is to nest your animations in blocks. This can get really ugly as anyone who has attempted this can attest. Anim is a way to create, purely with Objective C code, a cool almost ASCII-like horizontal timeline of animation like the type you might find in a program like Adobe After Effects. Over the course of its development, Anim has been influenced by event-based sequencing projects such as ReactiveCocoa and interesting new animation projects like Adobe's Edge.

Core Principle

Anim consists of 2 parts, Anims and Timelines. Anims represent units of time which can contain either animations or delays. After defining an Anim, you create instances of it and assign your views to those instances. You can create multiple instances of any anim.  Anims are placed in Timelines, which are not special objects, but basic NSArrays (for sequential play) or NSSets (for simultaneous play) which you create. The timeline will play its contents of Anims from left right. Timelines can contain other nested timelines.


Syntax

Step 1 // Define an Anim

```[Anim anim:@"slideUp" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.y = 0;
    }];```
    
You define an Anim by giving it a name, options, and an animation block. Please notice how you don't assign views, delays, or durations. That's because, in the Anim world, animations are defined seperately from views and durations. You assign those when you instantiate Anims in your timeline. Also in the Anim world, delays are created as seperate Anims, not as attributes of animations.





