# rime-zrm 配置

## Getting Started

这是自然码+辅助码的 rime 配置方案，文件为 zrm_pinyin.schema.yaml ，字典为 zrm_pinyin.dict.yaml ，同时还有其他几个字典。

## Dictionary

| 文件                           | 特点                                                                  |
| ------------------------------ | --------------------------------------------------------------------- |
| zrm_pinyin.dict.yaml           | 从 zrm2000 词库改造而来，删除了一些非文字字符。                       |
| zrm_pinyin.dict.yaml-2         | 结合 zrm_pinyin 与 luna_pinyin 生成的词库，内容很全，包含非文字字符。 |
| zrm_pinyin.unique_fm.dict.yaml        | 从 zrm_pinyin 改 2 改造过来，目的是为了减少重码。                     |
| zrm_pinyin.standard_unique.dict.yaml  | 从`unique_fm`统一辅助码规则并去重，由 [@sharp-tasting](https://github.com/sharp-tasting) 提供。        |
| zrm_pinyin.utf8-lite.dict.yaml | 基于 unique_fm 版再改造而来，去除了不能正常显示的文字。               |
| zrm_pinyin.standard_utf8_lite.dict.yaml  | 从`utf8-lite`统一辅助码规则并去重，由 [@sharp-tasting](https://github.com/sharp-tasting) 提供。         |
| zrm_pinyin.cn_en.dict.yaml     | 从 luna_pinyin.cn_en 改造过来，用以适应中英混输的情况。               |

以上文件除了 zrm_pinyin.cn_en.dict.yaml， zrm_pinyin.utf8-lite.dict.yaml，zrm_pinyin.standard_utf8_lite.dict.yaml 为生成负担最小，其他几个词典都有较大的内存占用。不过 utf8-lite 版相对不是很完整希望能够注意。

以上词典如果出现缺漏的话，建议自行添加即可。

myself 是我个人使用的字词库。

## Feature

1. 可以外挂小型词库
2. 可以适合使用自然码双拼但轻度使用辅助码的用户

## Q&A

### 如何使用辅码？

在需要辅码的字后面跟上辅码即可。

例如，人的编码是 `rf;pd` ，键入 `rf` 、 `rf;p` 、 `rf;pd` 都可以查找该字；多字也是同样的，比如说人类，键入 `rf lz` 、 `rf;p lz` 、 `rf;p lz;m` 等等，就不一一举例了。

### 繁体和字频问题

繁体和简体的辅码并不完全一致，如果只想要简体的话，可以用 opencc 过滤，或者尝试一些我自用的字库（在 myself 文件夹下）。

字频的问题是因为 rime 的 bug ，在 1.8.0 中已经得到修复。

### 模糊音设置

需要 schema 里追加配置。

举个例子，比如说 `en` 和 `eng` 分别对应自然码中的 `g` 和 `f` ，设置模糊音就是在配置中添加一个映射。

```yaml
speller:
    - "derive/^(\\w)g;(\\w)(\\w)$/$1f;$2$3/"
    - "derive/^(\\w)g;(\\w)(\\w)$/$1f;$2/"
    - "derive/^(\\w)g;(\\w)(\\w)$/$1f/"
```

`in` 和 `ing` 同理，需要对 `n` 和 `y` 做一重映射。如此推演。

### 词库

因为用了辅助码，编码与拼音不同，所以你不能完全正常的使用拼音词库，你也可以使用我的词库。

如果你想要增加新的词库，可以编写一个脚本来将全拼与自然码进行转换。

### `standard`字典

`zrm_pinyin.standard_unique.dict.yaml`和`zrm_pinyin.standard_utf8_lite.dict.yaml`把对应的原文件的辅助码统一到了 `自然码2000` 的规则，并进行了去重。在这两个字典里，单音字只对应一组符合`自然码2000`规则的辅助码，多音字的每个音只对应一组辅助码。
`自然码2000`的规则和键位分布可参考以下链接：

1. 官方链接： [自然码2000手册](http://ziranma.com.cn/uiysuomy.htm)
2. 民间整理：
    - [【双拼输入法】自然码辅助码入门教程（辅助码表）](https://www.liuchuo.net/archives/2847)
    - [双拼自然码辅助码方案及键位分布](https://zhuanlan.zhihu.com/p/122866844)
    - [自然码辅助码键位图](https://blog.csdn.net/pmo992/article/details/104963648)

更多关于这两个字典的说明，请查阅 [偏旁规范化以及去重](scripts/standardize.md)。

## License

GPLv3.
