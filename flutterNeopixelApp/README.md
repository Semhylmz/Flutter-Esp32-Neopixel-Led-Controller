# Flutter Esp32s Neopixel Led Controller

A new Flutter project.

## Getting Started

power type:
[led_status, on/off]
0x02 = 2 led_status
0x00 = 0 power off
0x01 = 1 power on

single color type:
[0x10, red, green, blue]
0x10 = 16
red
green
blue

animation type:
[animation_status, animation_type]
0x09 = 9 animation_status
0x10 = 16 singleColor
0x11 = 17 rainbow
0x12 = 18 rainbowCycle
0x13 = 19 colorWipe
0x14 = 20 theaterCase
0x15 = 21 theaterCaseRainbow

brightness type:
[brightness_status, brightnessValue]
0x20 = 32
brightness value

request info type:
[0x30, 0x01]
0x30 = 48 readValue
0x01 = 1
response type:
[led_status, led_animation, led_brightness, led_red, led_green, led_blue ]


