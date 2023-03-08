# Docu

An ARPlaneAnchor grows in all directions. Its center remains the same. 
If a child entity is added it will be added based on the pivot point. The pivot point is in the middle. This means that the added child will stay fixed in the middle.

### Potential Issue nr.1
In some cases, two planes are recognized and growing near each other as separate planes while being part of the same floor.

### Potential Issue nr.2
The image anchors world position moves around as ARKit tries to position it based on the currently recognized state.

### Image anchor
Visulazied image ModelEntities move in different directions but generally towards the camera. Objects move a lot in them.

### Plane anchor
Visulazied plane ModelEntities move towards the outside and objects dont move that much within them.

Models move around with their parent anchor. If a image anchor is used for placement the movement is huge.

### World anchor.
Using a world anchor does not seem to work. The "logged position seems to work", however, the real world position does not. The object positioned in the marker is moving around. 
The yellow line is the world position which is tied to the initial image marker position. 
The black line is the actual image marker center with a green plane for image position.
The grey door is positioned on the blue "floor" plane. It sticks and does not move!
The disappearing red lines are smaller "floor" planes which are removed by Apple since they are part of the actual floor and big "floor" plane.
The further away I get the more the portal moves when the image marker position is used.

Conclusions:
- Image anchor recognition seems volatile and impossible to do for precise positioning.
- Image anchor recognition gets worse with the increase in distance to the marker.
- Image anchor recognition only works properly on really small distances and proper angles.

- Image anchor position can only be used:
    - On small distances
    - "initially" - use the initial position to calculate plane position.
    - "manually" - use the current position which is good enought with user verification (and visualization).

See example:
https://youtube.com/shorts/R5StHjp1c94?feature=share
https://youtube.com/shorts/RW5n8R3yblc?feature=share
