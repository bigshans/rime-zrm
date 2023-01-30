# rime-zrm 配置

## Getting Started

这是自然码+辅助码的 rime 配置方案，文件为 zrm_pinyin.schema.yaml ，字典为 zrm_pinyin.dict.yaml ，同时还有其他几个字典。

## Dictionary

| 文件                           | 特点                                                                  |
| ------------------------------ | --------------------------------------------------------------------- |
| zrm_pinyin.dict.yaml           | 从 zrm2000 词库改造而来，删除了一些非文字字符。                       |
| zrm_pinyin.dict.yaml-2         | 结合 zrm_pinyin 与 luna_pinyin 生成的词库，内容很全，包含非文字字符。 |
| zrm.unique_fm.dict.yaml        | 从 zrm_pinyin 改 2 改造过来，目的是为了减少重码。                     |
| zrm_pinyin.utf8-lite.dict.yaml | 基于 unique_fm 版再改造而来，去除了不能正常显示的文字。               |
| zrm_pinyin.cn_en.dict.yaml     | 从 luna_pinyin.cn_en 改造过来，用以适应中英混输的情况。               |

以上文件除了 zrm_pinyin.cn_en.dict.yaml ， zrm_pinyin.utf8-lite.dict.yaml 为生成负担最小，其他几个词典都有较大的内存占用。不过 utf8-lite 版相对不是很完整希望能够注意。

以上词典如果出现缺漏的话，建议自行添加即可。

myself 是我个人使用的字词库。

## Feature

1. 可以外挂小型词库
2. 可以适合使用自然码双拼但轻度使用辅助码的用户

## License

GPLv3.

