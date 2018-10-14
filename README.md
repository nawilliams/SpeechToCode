# Speech To Code

HackUmass 2018

## Setup

### install dependencies

MacOS:
`brew install portaudio`
`brew install swi-prolog`

Linux:
`sudo apt install libasound-dev portaudio19-dev libportaudio2 libportaudiocpp0 ffmpeg libav-tools`

### install python packages

`pipenv install`

### fix Google cloud recognition

change line `924` in `speech_recognition/__init__.py` (reccomend using go to definition on `r.recognize_google_cloud()`)

## python script
Currently can either use voice recognition to parse code or type in the text.
Run/execute commands run the current ruby code.
Reset clears the ruby file.

## Current working commands that can be translated
define/set X to Y: used to set variables
if: conditional compares
for: basic loops with a counter
function definitions: "define a function ____" to create a function heading
primitive function calls: can currently print or return variables
custom function calls: "call factorial with 3" translates to "factorial(3)"
