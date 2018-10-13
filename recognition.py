import speech_recognition as sr

def recognize_speech():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("adjusting for ambient noise")
        r.adjust_for_ambient_noise(source)
        print("recording")
        audio = r.listen(source)
        print("finished recording")
        try:
            print("Recognized " + r.recognize_google(audio))
        except sr.UnknownValueError:
            print("couldn't understand")
        except sr.RequestError as e:
            print("failed: {0}".format(e))

recognize_speech()