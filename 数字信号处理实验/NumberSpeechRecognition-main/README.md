# Data Collection

.wav文件命名格式 NUM_TIMES.wav, NUM表示录音数字, TIMES表示次数

- 开启后进入循环, 先输入需要采集的数字(用于自动命名.wav文件)
- 每次要收集该数字数据时, 输入any key(除了q和c). 回车后进行2s的录音转wav
- 更改数字时, 输入c, 回车. 然后在提示后输入数字, 回车. **此时.wav文件命名将从该数字的0开始**
- 要结束. 输入q
- 要更改录音时长改动`record_audio(f'{number}_{global_times}.wav')`为`record_audio(f'{number}_{global_times}.wav'), record_second=NUMBER`将录音NUMBERs.
- 采样率RATE, 采样深度FORMAT, 每个缓冲采样数量CHUNK进入`record_audio`体内修改
