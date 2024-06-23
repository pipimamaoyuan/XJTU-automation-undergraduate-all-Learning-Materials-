% img=imread('C:\Users\pc\Desktop\wer.jpg');
% net=alexnet;
% net.classify(imresize(img,[227 227]))

img=imread('C:\Users\pc\Desktop\bn.jpg');
detector=yolov4ObjectDetector("csp-darknet53-coco");
[bboxes,scores,labels]=detector.detect(img);
detecteding=insertObjectAnnotation(img,'rectangle',bboxes,labels,'FontSize',32,'LineWidth',5);
imshow(detecteding);


% % 加载预训练的YOLO v4检测器
% detector = yolov4ObjectDetector("csp-darknet53-coco");
% 
% % 创建一个视频输入对象，指定使用笔记本摄像头
% vid = videoinput("winvideo",1);
% 
% % 设置视频输入对象的属性，如分辨率、帧率等
% set(vid,"FramesPerTrigger",Inf);
% set(vid,"ReturnedColorspace","rgb");
% vid.FrameGrabInterval = 5;
% 
% % 创建一个新的图形窗口
% hFig = figure;
% 
% % 设置图形窗口的属性
% set(hFig,'Visible','on');
% set(hFig,'Position',[100 100 640 480]);
% set(hFig,'WindowStyle','normal');
% 
% % 创建一个视频播放器对象，用于显示检测结果，并将图形窗口句柄作为父对象
% videoPlayer = vision.DeployableVideoPlayer('Parent',hFig);
% 
% % 开始视频采集
% start(vid);
% 
% % 循环执行以下操作，直到关闭视频播放器窗口
% while isOpen(videoPlayer)
%     % 从视频输入对象中获取一帧图像
%     frame = getsnapshot(vid);
%     
%     % 使用检测器对图像进行目标检测，返回边界框、置信度分数和标签
%     [bboxes,scores,labels] = detect(detector,frame);
%     
%     % 在图像上绘制检测到的边界框和标签
%     detectedImg = insertObjectAnnotation(frame,'rectangle',bboxes,labels);
%     
%     % 在视频播放器中显示检测结果
%     step(videoPlayer,detectedImg);
% end
% 
% % 停止视频采集并释放资源
% stop(vid);
% delete(vid);
% clear vid;
% release(videoPlayer);
