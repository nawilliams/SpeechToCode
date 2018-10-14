# SignItSayIt

HackUmass 2018

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


### Current working commands
define/set X to Y: used to set variables
if: conditional compares
for: basic loops with a counter
function definitions: "define a function ____" to create a function heading
primitive function calls: can currently print or return variables
custom function calls: "call factorial with 3" translates to "factorial(3)"
