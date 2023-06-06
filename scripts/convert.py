'''convert the 3rd code of zrm_pinyin.'''

import string
import os
from cnradical import Radical, RunOption
radical = Radical(RunOption.Radical)  # 获取偏旁

bs_map = {}  # 部首 -> 辅助码 的字典
with open('aux_code.txt', "r", encoding="utf-8") as f0:
    for li0 in f0:
        lst = list(li0)  # 拆成单个字符(含空格, 换行符等)
        for i in lst[1:]:  # 排除首个字符(因其是辅码)
            if i not in string.whitespace:
                # 排除掉 whitespace, 剩下的就是部首
                bs_map[i] = lst[0]

# 用于调整部首的辅助码, item的形式为 'bs_ch':{'orig_ac':'new_ac'}
bs_convert = {}
with open('bs_change.txt', "r", encoding="utf-8") as f0:
    for li0 in f0:
        bs_convert[li0[0]] = {li0[2]: li0[4]}

def resh3(src, temp):
    '''修正原词典中部首与辅助码的对应关系.'''
    # src: "input dict" ; dst: "new file name for the output dict"
    with open(src, "r", encoding="utf-8") as file1, \
            open(temp, "w", encoding="utf-8") as file2:
        for line in file1:

            if '\n' not in line:  # 补 \n.
                line2 = line + '\n'

            bs_ch = radical.trans_ch(line[0])  # 部首, str型
            if line[0].isascii() or bs_ch is None:  # line[0] 不是汉字, 或者“不能拆”
                line2 = line  # 该条件已包含以'\n'开头的空行
            elif line[0] == bs_ch:  # 独体字
                line2 = line
            elif bs_ch in bs_convert and line[5] in bs_convert[bs_ch]:
                line2 = line.replace(';'+line[5],
                                     ';'+bs_convert[bs_ch][line[5]])
            # elif bs_ch in bs_map and line[6] == bs_map[bs_ch]:
            #     # 部首被放在第四码, 则置换第三码和第四码(会导致 dict 文件非常难用)
            #     line2 = line.replace(';'+line[5]+line[6],
            #                          ';'+line[6]+line[5])
            else:
                line2 = line

            file2.write(line2)

# def resh4(temp0, temp):
#     '''整理第四码'''
#     pass

def rm_repeat(temp, dst):
    '''去重'''
    # src: "input dict" ; dst: "new file name for the output dict"
    with open(temp, "r", encoding="utf-8") as file1, \
            open(dst, "w", encoding="utf-8") as file2:
        last10 = ['EMPTY\n']*10
        for line in file1:
            if line not in last10:
                file2.write(line)
                last10 = last10[1:] + [line, ]

FILE_IN = '../zrm_pinyin.standard_unique.dict.yaml'
resh3(FILE_IN, 'temp.yaml')
os.rename(FILE_IN, FILE_IN+'.bak')
rm_repeat('temp.yaml', FILE_IN)
