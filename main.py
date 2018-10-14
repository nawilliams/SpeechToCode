from pyswip import Prolog, registerForeign
import speech_recognition as sr
from subprocess import call

class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

prolog = Prolog()
prolog.consult("hack.pl")


def reset():
    f = open("program.rb", "w")
    f.write("")
    f.close()

def run():
    print("""
#################
### Executing ###
#################
    """)
    call(["ruby", "program.rb"])
    print("""
#################
### Stopping  ###
#################
    """)


def parse(words):

    query = '["' + '", "'.join(words.split(" ")) + '"]'
    out = list(prolog.query('parse(' + query + ', X)'))
    if not out:
        print(colors.WARNING + "failed to parse")
        return ""
    return " ".join(map(lambda x: x.decode('ascii'), out[0]["X"]))

r = sr.Recognizer()
while(True):
    with sr.Microphone() as source:
        print("adjusting for ambient noise")
        r.adjust_for_ambient_noise(source)
        print(colors.OKBLUE + "recording")
        audio = r.listen(source)
        print(colors.OKBLUE + "finished recording")
        try:
            a = r.recognize_google(audio).lower()
            print(colors.OKGREEN + a)
            if a == "reset" or a == "erase":
                reset()
            if a == "run" or a == "execute":
                run()
            f = open("program.rb", "a")
            f.write(parse(a))
            f.close()

        except sr.UnknownValueError:
            print(colors.FAIL + "couldn't understand")
        except sr.RequestError as e:
            print(cololrs.FAIL + "failed: {0}".format(e))
