# rime-zrm 配置

## Getting Started

这是自然码+辅助码的 rime 配置方案，文件为 zrm_pinyin.schema.yaml ，字典为 zrm_pinyin.dict.yaml 。

我将词库进行清理，重新写了一些方案，现在内存占用已经减小了一半以上的内存占用了。你可以通过分号使用辅助码，已经比较完善了。不过仍然不建议在手机上使用。添加字库请不要添加大字库，由于重码很多，生成起来非常占用内存。

配置文件使的单字字典 zrm_pinyin.dict.yaml 是我删除了 zrm2000 的所有词组并对一些子码进行删减。目录 zrm_pinyin 是我生成字典所使用的文件。这些字典的作用如下表所示：

|文件      | 作用 |
| ---- | ---- |
| luan_pinyin_single.dict.yaml | 从 luan_pinyin 生成的单字字典 |
| zrm2000.dict.yaml | 自然码 2000 的字典（未修改） |
| zrm2000.schema.yaml | 自然码 2000 的输入法配置方案（个人魔改版，部署即可使用） |
| zrm.dict.yaml | 从 zrm 字典中提取的单字字典（较为驳杂） |

Warning: 请不要给 zrm2000 方案挂载词库，否则部署就会爆内存的。另外，zrm_pinyin 方案外挂词典加起来不要太大，几十兆的肯定会爆内存的，小心点测。

## Feature

1. 可以外挂小型词库
2. 可以适合使用自然码双拼但轻度使用辅助码的用户

## License

GPLv3.