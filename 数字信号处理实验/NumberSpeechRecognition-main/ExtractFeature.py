# -----------------------------------------
# @Decription: This file extracts features of voice signals
# @Author: Yiwei Ren.
# @Date: 十月 07, 2023, 星期六 20:04:03
# @Copyright (c) 2023 Yiwei Ren.. All rights reserved.
# -----------------------------------------

import wave  
import numpy as np
import time

class DataProcessing():
    '''
        This is the class that processes voice data
        When use it, just instantiate the class and call FeatureDetect method.
    '''
    def __init__(self, FilePath:str, segmet_time = 30e-3, cover_time = 10e-3, amp_threshold=5, cr_threshold=0.05) -> None:
        '''
            Arguments:
                FilePath: the path of destination file
                segment_time: the length of time that every segment of voice signals last. Unit: second. Default=30e-3
                cover_time: the length of time that the two signals overlap. Unit: second. Default=10e-3
                amp_threshold: the amplitude thershold of endpoints detection. Default=5
                cr_threshold: the cross rate thershold of endpoints detection. Default=0.05
        '''
        self.file = FilePath
        self.segment_time = segmet_time
        self.cover_time = cover_time
        self.amp_threshold = amp_threshold
        self.cr_threshold = cr_threshold

    def read_data(self):
        f = wave.open(self.file,'rb')
        nframes = f.getnframes()
        str_data  = f.readframes(nframes)
        framerate = f.getframerate()
        f.close()
        self.sample_time_gap = 1 / framerate
        ori_data = np.frombuffer(str_data,dtype = np.int16)
        # normalize
        data = ori_data / max(abs(max(ori_data)), abs(min(ori_data)))
        return data

    def amp_detect(self, data):
        ampsum = 0
        for datum in data:
            ampsum += abs(datum)
        return ampsum
    
    def cross_rate(self, data):
        sum = 0
        for i in range(len(data)-1):
            if data[i]*data[i+1] < 0:
                sum += 1
        return sum / len(data)

    def data_segment(self, data:np.ndarray):
        # signal segment by window
        window = np.hanning(int(self.segment_time / self.sample_time_gap)) # retangle window
        cover = int(self.cover_time / self.sample_time_gap)
        segments = []
        i = 0
        while 1:
            if i + int(len(window)) > len(data):
                break
            else:
                new_segment = np.copy(data[i:(i+len(window))])
                segments.append(new_segment)
                i += len(window)-cover
        segments = np.array(segments)
        for i,seg in enumerate(segments):
            segments[i] = seg * window
        return segments
    
    def segment_choose(self, segments):
        minid = 0
        maxid = 0
        for i,seg in enumerate(segments):
            if self.amp_detect(seg) > self.amp_threshold:
                minid = i
                break
        for j in range(len(segments)-1, -1, -1):
            if self.amp_detect(segments[j]) > self.amp_threshold:
                maxid = j
                break
        for i in range(minid, -1, -1):
            if self.cross_rate(segments[i]) < self.cr_threshold:
                break
            else:
                minid = i
        for j in range(maxid):
            if self.cross_rate(segments[j]) < self.cr_threshold:
                break
            else:
                maxid = j
        return np.copy(segments[minid:maxid+1]), minid, maxid
    
    def choose_data(self, data, indexzone):
        mini = int(indexzone[0]*(self.segment_time-self.cover_time) / self.sample_time_gap)
        maxi = int(indexzone[1]*(self.segment_time-self.cover_time) / self.sample_time_gap)
        return np.copy(data[mini:maxi])

    def self_correlate(self, choosed_data):
        # all data range self-correlating
        bt = time.time()
        core = np.correlate(choosed_data,choosed_data, 'full')
        et = time.time()
        print(f'SelfCorrelating used time:{et-bt:.4f}s')
        return core
    
    def segs_correlate(self, segments):
        bt = time.time()
        seg_core = np.zeros((len(segments),2*len(segments[0])-1))
        seg_frequency = np.zeros(len(segments))
        for i,seg in enumerate(segments):
            if self.amp_detect(seg) > self.amp_threshold:
                seg_core[i] = np.correlate(seg, seg,'full')
                peak_index = self.AMPD(seg_core[i])
                diff = np.zeros(len(peak_index)-1)
                for j in range(len(peak_index)-1):
                    diff[j] = (peak_index[j+1]-peak_index[j])
                seg_frequency[i] = 1 / (diff.mean()*self.sample_time_gap)
        et = time.time()
        print(f'Segments self-correlating used {et-bt:.4f}s')
        return seg_core, seg_frequency
    
    def AMPD(self, data):
        # peaks search
        p_data = np.zeros_like(data, dtype=np.int32)
        count = data.shape[0]
        arr_rowsum = []
        for k in range(1, count // 2 + 1):
            row_sum = 0
            for i in range(k, count - k):
                if data[i] > data[i - k] and data[i] > data[i + k]:
                    row_sum -= 1
            arr_rowsum.append(row_sum)
        min_index = np.argmin(arr_rowsum)
        max_window_length = min_index
        for k in range(1, max_window_length + 1):
            for i in range(k, count - k):
                if data[i] > data[i - k] and data[i] > data[i + k]:
                    p_data[i] += 1
        return np.where(p_data == max_window_length)[0]

    def feature_plot(self, amps, crs, seg_fre, choosed_data):
        import matplotlib.pyplot as plt 
        plt.subplot(412)
        plt.plot(range(len(amps)), amps)
        plt.title('Amplitude:Segment')
        plt.subplot(413)
        plt.plot(range(len(crs)), crs)
        plt.title('CrossRate')
        plt.subplot(411)
        plt.plot(range(len(choosed_data)), choosed_data)
        plt.title('ChoosedData')
        plt.subplot(414)
        plt.plot(range(len(seg_fre)), seg_fre)
        plt.title('SegmentsFrequency')
        plt.show()

    def plot3d_feature(self, amps, crs, seg_fre):
        import matplotlib.pyplot as plt 
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.scatter(amps, crs, seg_fre)
        plt.show()

    def FeatureDetect(self, plot=False, plot3d=False):
        '''
            Arguments:
                plot: if it is True, function will plot the 2d figure of features of sample. Default=False
                plot3d: if it is True, function will plot the 3d figure of features of sample. Default=False
        '''
        data = self.read_data()
        segments = self.data_segment(data)
        choosed_segs, minid, maxid = self.segment_choose(segments)
        choosed_data = self.choose_data(data, (minid,maxid))
        _, seg_fre = self.segs_correlate(choosed_segs)
        amps = np.zeros(len(choosed_segs))
        crs = np.zeros(len(choosed_segs))
        for i,seg in enumerate(choosed_segs):
            amps[i] = self.amp_detect(seg)
            crs[i] = self.cross_rate(seg)
        if plot:
            self.feature_plot(amps,crs,seg_fre,choosed_data)
        if plot3d:
            self.plot3d_feature(amps, crs, seg_fre)
        return amps, crs, seg_fre

if __name__ == '__main__':  
    wavefile = DataProcessing('DataSet/5_0.wav')
    amps, crs, seg_fre = wavefile.FeatureDetect(True,True)
    

