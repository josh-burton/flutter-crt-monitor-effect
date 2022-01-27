# CRT Monitor Effect

A attempt at replicating the CRT monitor effect from [phantom.sh](https://www.phantom.sh) in Flutter.

This uses a few techniques:

- a repeated 2x3 'pixel' that is overlayed across all content with an ImageShader
- a transparent flicker overlayed on all content that flickers every 100ms.
- blue/red text shadows with an offset that is animated across keyframes. The keyframes tween package is used to achieve this.