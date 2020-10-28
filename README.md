# photodiodeStressTests

## Script description:
 This repository hosts a code to run a photodiode stress test with PTB:
 The test consists in flashing the photodiode at different intervals and luminance values. 
 The experiment is built in blocks of three distictive sequences: in the first sequence, a 
 photodiode square (square at the bottom right of the screen) is flashed white every second 
 frame, in the second sequence, every four frames, and in the last sequence every 6 frames. 
 These sequences are repeated several times, with decreasing photodiode square luminance 
 intensity. The intensity is first set to 100%, meaning that the photodiode will be flashed
 on white. Then, in a second iteration, the flash is set to a lower luminance, more greyish.
 The steps of this decrease is dictated by the parameter set in the function 
 runPhotodiodeStressTest.
 
## How to use:
 Open matlab and in the command window, enter:
 *runPhotodiodeStressTest(LumDecrement, PhotodiodeSize, debug)*
 Parameters:
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
|Date | EventNumber | Onset | Event|
| --- | --- | --- | --- |
|Date of the run | Number of the current event | Timestamp of the photodiode onset | Photodiode status (on or off)|
| --- | --- | --- | --- |
