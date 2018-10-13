import speech_recognition as sr
import sys
import os

r = sr.Recognizer()

with open("api-key.json") as f:
    GOOGLE_CLOUD_SPEECH_CREDENTIALS = f.read()

print(GOOGLE_CLOUD_SPEECH_CREDENTIALS)

text = ""
with sr.Microphone() as source:
    audio = r.listen(source)
    try:
        text = r.recognize_google_cloud(audio,GOOGLE_CLOUD_SPEECH_CREDENTIALS)
        print("{}".format(text))
    except sr.RequestError as e:
        print(text, e)
        sys.exit(-1)
    except sr.UnknownValueError:
        print("unknown")