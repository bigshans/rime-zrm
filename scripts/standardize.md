# 偏旁规范化以及去重

偏旁规范化, 指的是让辅助码更符合 `zrm2000` 的映射规则, 以此降低一个字同时对应多组辅助码的问题, 从而减少重码. 对于大多数汉字, 自然码的辅助码取决于部首和偏旁.

- [**部首** 与 *偏旁* 的区别 --- 以'高'为例](http://www.xychild.com/zhongxiaoxue/shuokepingke/5750.html)
- 如果一个字由部首(可以理解为"主要"的偏旁)和其它部分(也是偏旁), "自然码+辅助码"的第三码取做部首, 第四码取为最后一个偏旁.
- 如果一个字本身就是部首, 即独体字, 不能进一步拆分出部件, 只能由笔画构成. "自然码+辅助码"的第三码是第一笔, 第四码是最后一笔.

部首和偏旁在`zrm2000`方案中对应的辅助码和键位, 可参考以下链接：

1. 官方链接: [自然码2000手册](http://ziranma.com.cn/uiysuomy.htm)
2. 民间整理:
    - [【双拼输入法】自然码辅助码入门教程（辅助码表）](https://www.liuchuo.net/archives/2847)
    - [双拼自然码辅助码方案及键位分布](https://zhuanlan.zhihu.com/p/122866844)
    - [自然码辅助码键位图](https://blog.csdn.net/pmo992/article/details/104963648)

如果一个文件(比如 `zrm-pinyin.dict.yaml`) 存在一个字同一发音多个辅码的情况, 比如说 `星` 字, 有 `xy;ou` 和 `xy;ru` 两个码, 则可以通过 `convert.py` 将辅助码统一到 `xy;ou`, 并且移除重复条目.

1. 用`resh3`函数对`zrm-pinyin.dict.yaml`修改, 将辅助码重新映射以符合规范(例如`xy;ru -> xy;ou`), 输出至文件`zrm-pinyin.temp.dict.yaml`.
2. 用`rm_repeat`函数对`zrm-pinyin.temp.dict.yaml`操作, 对相邻行且重复的条目进行去重, 输出至文件`zrm-pinyin.wanted.dict.yaml`.
3. 删除(或备份)原来的`zrm-pinyin.dict.yaml`, 再手动重命名`zrm-pinyin.wanted.dict.yaml -> zrm-pinyin.dict.yaml`, rime就会使用这个新的字典.

## 1. 拆字准备

通过`pip`安装`cnradical`, 这个软件包用于获取汉字的部首.

### 1.1 有明显部首的字

`cnradical`可以正确地拆出大多数部首.

```python
import sys
from cnradical import Radical, RunOption 
radical = Radical(RunOption.Radical) #获取偏旁 
# 测试部首结果
print(radical.trans_ch('伍'))
print(radical.trans_ch('变'))
print(radical.trans_ch('充'))
```

```output
亻
又
亠
```

```python
print(radical.trans_ch('膀'))
print(radical.trans_ch('臂'))
print(radical.trans_ch('瞥'))
print(radical.trans_ch('撻'))
print(radical.trans_ch('循'))
```

```output
月
月
目
扌
彳
```

### 1.2 独体字

一般是部首汉字, 如：“金木水火土辶皿马皮日月目衣耳”等. 独体字全部看成部首, 不能进一步拆分出部件, 只能由笔画构成.
对于这类字, `cnradical`可能不准.

```python
radical.trans_ch('由')
```

```output
'田'
```

### 1.3 ”拆不动“的字

- 独体字, 自身即部首.
- `cnradical`未收录的字, 输出自不准确.

```python
print(radical.trans_ch('一'))
print(radical.trans_ch('禾'))
print(radical.trans_ch('鯈'))
print(radical.trans_ch('擜'))
```

```output
一
禾
魚
扌
```

非汉字:

```python
print(radical.trans_ch('a'))
print(radical.trans_ch(' '))
print(radical.trans_ch('\t'))
print(radical.trans_ch('\n'))
```

```output
None
None
None
None
```

## 2. 构造用于分析文件的函数

`convert.py` 中定义了如下两个函数:

- `resh3()` 函数用于规范化第三码(部首辅助码). 目前暂未考虑第四码, 因为"最后一个偏旁"很难从程序上消除模糊性, 为了避免更多的模棱两可, 所有字的第四码一律不做修改.

- `rm_repeat()` 函数用于去除 行数相差小于或等于10行 且 完全重复 的编码条目.

## 3. 分析文件

`convert.py` 中的如下行将字典 `FILE_IN` 调整部首码并输出为临时文件

```python
resh3(FILE_IN, 'temp.yaml')   
```

而下面一行则用于去重. 输入上一步的临时文件, 去重之后输出覆盖原文件. 这样得到有“更符合规范”的码, 且无重复条目.

```python
rm_repeat('temp.yaml', FILE_IN)
```

经过上述过程, 第三码(部首/首个偏旁)得到了部分纠正, 而第四码(末个偏旁)未被调整.

所以肯定仍然存在不准确的码. 欢迎提issue, 以便完善筛选部首的函数, 以及为第四码的错码找规律.

## 4. 可能有错的编码

- 独体字, 如前所述, `cnradical`拆不准.
- 生僻字, `cnradical` 拆不准或拆不了.
- 极少比例的第四码可能不正确, 因为`cnradical`只拆分部首.
