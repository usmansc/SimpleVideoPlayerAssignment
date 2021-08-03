# SimpleVideoPlayerAssignment

Write a simple iOS or macOS application in Objective-C or Swift that will use AVPlayer to play video. It will have a play/pause button and a slider for scrubbing.
For each video, the app will also receive a set of in/out points from its back-end. Each in/out point pair consists of numbers between 0 and 1. For example, [(0.2, 0.8)] will cause the player to skip the first and last 20% of the video.
In case of multiple in/out pairs, such as [(0.2, 0.4), (0.6, 0.8)], the player will loop within the first pair until the user taps in the slider to jump to one of the other ranges. If the user taps outside of the in/ out ranges, the player will jump to the nearest range.
In/out ranges will be highlighted visually in the slider.
Try to make looping playback seamless (without the pause on the loop point).


For the purposes of this assignment, you may embed static files to simulate back-end requests.
 
 # Note:
 I did not use AVPlayerLooper because I was not sure if I could

# Result
https://user-images.githubusercontent.com/48035232/128065589-d6291bae-4ac4-496c-b5b3-ad3b4e020719.mp4

