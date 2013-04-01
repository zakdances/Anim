Anim
====

The iOS Animation Manager

The purpose of anim is to create a simple, declarative way to create complex chains of user interface animation. After much searching, I was surprised at my failure to find any sort of animation management library for Objective-C. The current best practice for creating sequential animation is to nest your animations in blocks. This can get really ugly as anyone who has attempted this can attest. Anim is a way to create, purely with Objective C code, a cool ASCII-like horizontal timeline of animation like the type you might find in a program like Adobe After Effects. Over the course of its development, Anim has been influenced by event-based sequencing projects such as ReactiveCocoa.