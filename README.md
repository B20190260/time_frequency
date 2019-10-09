# time_frequency

时频分析 + 时变阶分数傅立叶变换普 + 时变滤波 相关的毕业设计课题全部代码和论文+PPT，供各位通信、电子信息工程等相关学弟学妹参考。

论文: [基于时频分布的多分量信号提取与重建技术研究](./doc/何亮_基于时频分布的多分量信号提取与重建技术研究.pdf) 哈尔滨工业大学 何亮

毕业答辩PPT: [./doc/何亮_基于时频分布的多分量信号提取与重建技术研究_结题PPT.ppt](./doc/何亮_基于时频分布的多分量信号提取与重建技术研究_结题PPT.ppt)

引用代码的要求不高，请客观引用论文：

```
@INPROCEEDINGS{Wu2002:Time,
AUTHOR="Longwen Wu and Yaqin Zhao and Liang He and Shengyang He and Guanghui Ren",
TITLE="A Time-varying Filtering Algorithm based on Short-time Fractional Fourier
Transform",
BOOKTITLE="2020 International Conference on Computing, Networking and Communications
(ICNC): Wireless Networks (ICNC'20 WN)",
ADDRESS="Big Island, USA",
DAYS=17,
MONTH=feb,
YEAR=2020,
KEYWORDS="time-varying filtering; short-time fractional Fourier transform; order
time-varying; multi-component signal decomposition",
ABSTRACT="This paper presents a novel time-varying filtering (TVF) algorithm based on
order time-varying short-time fractional Fourier transform (OTV-STFrFT) for
multi-component signal analysis, which can process non-linear frequency
modulated (NLFM). The idea of combining TVF and the order time-varying
STFrFT are mainly inspired by the following two aspects: i) NLFM signals
can be locally regarded as segmented linear frequency modulated (LFM)
signals; ii) the fractional Fourier transform is the optimal sparse
representation of LFM signal. The order time-varying STFrFT can overcome
several defects of the existing TVF algorithms in dealing with
multi-component signals, of which the mixed components may intersect in the
time-frequency distribution. The numerical results shows that the proposed
algorithm is superior to the TVF algorithms based on conventional
short-time Fourier transform (STFT) and state-of-the-art synchrosqueezed
wavelet transforms (SsWT) in multi-component signal analysis."
}
```


## 程序运行方法

先运行 time_frequency\load_paths_all.m 和 tf_tool_box\load_toolbox_all.m 以确保所有文件夹被添加到matlab搜索路径中。

如何输出论文所有图像具体参考: [./doc/程序验收清单_何亮.docx](./doc/程序验收清单_何亮.docx)

目录 time_frequency 下全部是论文核心工作，包括了论文从选题到最终实现的所有代码，能封装都尽量封装成可以通用的函数了。

如果遇到问题，最好尝试先自己解决......



如果本源码对你有所帮助，可以[点赞支持](./img/URgood.jpg)

也可以关注作者公众号提问~

<img src="./img/owner.jpg" width = "300" height = "300" alt="关注作者" align="center" />
