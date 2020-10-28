# photodiodeStressTests

## Script description:
 This repository hosts a code to run a photodiode stress test with PTB:
 This test flashes a square at the corner of the screen on and off at different frequencies.
 The luminance value of the square is also varied. The aim of this script is to stress test
 photodiode recording devices to see if they are able to keep up with super fast flashing and 
 whether the gain of the photodiode recordings is sufficient to discriminate the flashes from
 background noise at different luminance values
 
## Test structure:
 The test consists in flashing the photodiode square on an off first every frame, then
 every second and then every third frame. In each phase, the photodidoe is flashed a set amount
 of times depending on the value passed to the function. This sequence is repeated for different 
 photodiode square luminance values. The luminance of the square decreases in a stepwise fashion 
 according to the set luminance decrement factor.
 
## How to use:
 Open matlab and in the command window, enter:
 - *runPhotodiodeStressTest(LumDecrement, PhotodiodeSize, debug)*
 \nParameters:
 - flashIterations: how often the photodiode should be flashed
 - LumDecrement: number between 0 an 1, representing the steps of luminance decrease during
 the test. If set to 0.25, the first block will present photodiode at luminance 100%, second
 at 75%, third 50%... Default: 0.25
 - PhotodiodeSize: size of the photodiode square in pixels. Default: 200
 - debug: when set to 1, the experiment will be run in windowed mode, PTB sync test will be 
 skipped. Default: 0
 
## Outputs
The test outputs a csv table, containing information about what happened. The output csv can
be found in the directory ./data
The table are in the following format:

### Output csv:
|Date | FlipRate | EventNumber | Onset | Event|
| --- | --- | --- | --- | --- |
|Date of the run | How often the photodiode is turned on | Number of the current event | Timestamp of the photodiode onset | Photodiode status (on or off)|
| --- | --- | --- | --- | --- |

## Recommandation:
While this script varies the luminance of the photodiode square on screen, this is not 
equivalent to manually changing the brightness of the screen in the systems settings. It is 
therefore recommended to repeat this test several times, changing the brightness of the screen 
in a stepwise fashion
