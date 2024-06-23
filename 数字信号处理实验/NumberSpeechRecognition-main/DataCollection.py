# -----------------------------------------
# @Decription: Collect audio data for digital signal processing
# @Author: Yiwei Ren.
# @Date: 九月 19, 2023, 星期二 11:43:51
# @Copyright (c) 2023 Yiwei Ren.. All rights reserved.
# -----------------------------------------


import pyaudio
import wave
from tqdm import tqdm

def record_audio(wave_path, record_second=2):
    '''
        Collecting .wav data

        Arrguments:
            wave_path: the path to save .wav file
            record_second: every .wav time duration, Default = 2s
    '''
    # audio input stream
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 8000
    p = pyaudio.PyAudio()
    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    frames_per_buffer=CHUNK)
    # save file
    wf = wave.open(wave_path, 'wb')
    wf.setnchannels(CHANNELS)
    wf.setsampwidth(p.get_sample_size(FORMAT))
    wf.setframerate(RATE)
    print("* recording")
    for i in tqdm(range(0, int(RATE / CHUNK * record_second))):
        data = stream.read(CHUNK)
        wf.writeframes(data)
    print("* done recording")
    stream.stop_stream()
    stream.close()
    p.terminate()
    wf.close()

if __name__ == '__main__':
    import os
    print(f'In platform: {os.name}')
    def root_path(path):
        folder = os.path.exists(path)
        if not folder:                 
            os.mkdir(path)
        return path
    root = root_path(f'.{os.sep}DataSet') # Input Root Diretory
    number = input('Input the number: ')
    print('Begin to collect data, input any to begin, "c" to change number, "q" to quit')
    global_times = 0
    while(1):
        state = input()
        if state == 'q':
            break 
        elif state == 'c':
            number = input('Input the number: ')
            print('Begin to collect data, input any to begin, "c" to change number, "q" to quit')
            global_times = 0
        else:
            print(f'In collecting number={number}, times={global_times}')
            record_audio(f'{root}{os.sep}{number}_{global_times}.wav')
            global_times += 1
