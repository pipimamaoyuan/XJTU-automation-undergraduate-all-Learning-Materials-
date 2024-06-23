import cv2
from skimage.filters import try_all_threshold
from skimage.filters import threshold_otsu
from skimage.exposure import match_histograms
import matplotlib.pyplot as plt


def display_image(images, titles):
    for i in range(2):
        plt.subplot(1, 2, i + 1)
        plt.imshow(images[i], 'gray')
        plt.title(titles[i])
        plt.xticks([]), plt.yticks([])
    plt.show()

lena = cv2.cvtColor(cv2.imread("Resource/lena.bmp", flags=cv2.IMREAD_COLOR), code=cv2.COLOR_BGR2GRAY)
lena1 = cv2.cvtColor(cv2.imread("Resource/lena1.bmp", flags=cv2.IMREAD_COLOR), code=cv2.COLOR_BGR2GRAY)
lena2 = cv2.cvtColor(cv2.imread("Resource/lena2.bmp", flags=cv2.IMREAD_COLOR), code=cv2.COLOR_BGR2GRAY)
lena4 = cv2.cvtColor(cv2.imread("Resource/lena4.bmp", flags=cv2.IMREAD_COLOR), code=cv2.COLOR_BGR2GRAY)
matchLena1WithLena = match_histograms(image=lena1, reference=lena)
images = [lena1, matchLena1WithLena]
titles = ['lena1 original image', 'histogram matching image']
display_image(images, titles)

matchLena2WithLena = match_histograms(image=lena2, reference=lena)
images = [lena2, matchLena2WithLena]
titles = ['lena2 original image', 'histogram matching image']
display_image(images, titles)

matchLena4WithLena = match_histograms(image=lena4, reference=lena)
images = [lena4, matchLena4WithLena]
titles = ['lena4 original image', 'histogram matching image']
display_image(images, titles)














