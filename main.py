from pyswip import Prolog, registerForeign
import speech_recognition as sr
from subprocess import call
import re

class colors:
    gray = '\033[1;30m'
    red = '\033[1;31m'
    green  ='\033[1;32m'
    yellow = '\033[1;33m'
    blue = '\033[1;34m'
    magenta = '\033[1;35m'
    cyan = '\033[1;36m'
    white = '\033[1;37m'
    crimson = '\033[1;38m'
    h_red = '\033[1;41m'
    h_green = '\033[1;42m'
    h_brown = '\033[1;43m'
    h_blue = '\033[1;44m'
    h_magenta = '\033[1;45m'
    h_cyan = '\033[1;46m'
    h_gray = '\033[1;47m'
    h_crimson = '\033[1;48m'

def color(string, color):
    return color + string + '\033[1;m'

def reset():
    f = open("program.rb", "w")
    f.write("")
    f.close()

def run():
    print(color("""
#################
### Executing ###
#################
    """, colors.gray))
    call(["ruby", "program.rb"])
    print(color("""
#################
### Stopping  ###
#################
    """, colors.gray))


def clean(words):
    r = re.match(r'.*\d[a-zA-Z].*', words)
    while(r):
        words = re.sub(r'(.*)(\d)([a-zA-Z])(.*)', r'\1\2 \3\4', words)
        r = re.match(r'.*\d[a-zA-Z].*', words)
    if words and words[0] == '4':
        words = 'for' + words[1:]
    return words


def parse(words):
    query = '["' + '", "'.join(words.split(" ")) + '"]'
    out = list(prolog.query('parse(' + query + ', X)'))
    if not out:
        print(color("failed to parse", colors.red))
        return ""
    return " ".join(map(lambda x: x.decode('ascii'), out[0]["X"]))

prolog = Prolog()
prolog.consult("hack.pl")

with open("api-key.json") as f:
    GOOGLE_CLOUD_SPEECH_CREDENTIALS = f.read()

r = sr.Recognizer()

while(True):
    a = input("Press enter to record or type in command:\n")
    if not a:
        with sr.Microphone() as source:
            print(color("adjusting for ambient noise", colors.cyan))
            r.adjust_for_ambient_noise(source)
            print(color("Recording...", colors.green))
            audio = r.listen(source)
            print(color("finished recording\n", colors.cyan))
            try:
                a = r.recognize_google(audio).lower()
                #a = r.recognize_google_cloud(audio,GOOGLE_CLOUD_SPEECH_CREDENTIALS, preferred_phrases=["define", "set", "as", "print", b]).lower()
            except sr.UnknownValueError:
                print(color("couldn't understand", colors.red))
            except sr.RequestError as e:
                print(color("failed: {0}".format(e), colors.h_red))

    if a == "reset" or a == "erase":
        print(color("Resetting...", colors.magenta))
        reset()
    elif a == "run" or a == "execute":
        run()
    else:
        a = clean(a)
        print(color(a, colors.yellow))

        f = open("program.rb", "a")
        f.write(parse(a))
        f.close()
    print()
