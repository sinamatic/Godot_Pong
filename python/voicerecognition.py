import speech_recognition as sr
import math
import audioop
import pyaudio

recognizer = sr.Recognizer()
recognizer.energy_threshold = 100  # Niedriger Schwellenwert für leisere Umgebungen

# Initialize microphone
mic = sr.Microphone()

with mic as source:
    while True:
        print("Listening for command...")
        try:
            # Capture audio and volume
            audio = recognizer.listen(
                source, phrase_time_limit=1
            )  # Kürzeres Zeitfenster
            data = audio.get_wav_data()
            volume = math.sqrt(audioop.rms(data, 2))

            # Recognize command
            command = recognizer.recognize_google(audio, language="en-US").lower()

            # Write to file only if command is "up" or "down"
            if command in ["up", "down"]:
                with open("voice_input.txt", "w") as f:
                    f.write(f"{command},{volume}")
                print(f"Command: {command}, Volume: {volume}")
            else:
                print("Invalid command detected:", command)

        except sr.UnknownValueError:
            print("Did not recognize command")
