import os
from cnradical import Radical, RunOption 
radical = Radical(RunOption.Radical) #获取偏旁 

import string

bs_map = dict() # 部首 -> 辅助码 的字典

with open('aux_code.txt', "r", encoding="utf-8") as f1:
    for line in f1:
        lst = list(line) # 拆成单个字符(含空格, 换行符等)
        for i in lst[1:]: # 排除首个字符(因其是辅码)
            if i not in string.whitespace: 
                # 排除掉 whitespace, 剩下的就是部首
                bs_map[i] = lst[0]

# 用于调整部首的辅助码, item的形式为 'bs':{'original_ac':'correct_ac'}
bs_convert = {'彳':{'r':'x'}, '日':{'r':'o'}, '月':{'y':'o'},
              '目':{'m':'o'}, '扌':{'t':'f'}, '亠':{'d':'w'}}

def reShape(src, temp):
    '''修正原词典中部首与辅助码的对应关系.''' 
    # src: "input dict" ; dst: "new file name for the output dict"
    with open(src, "r", encoding="utf-8") as f1, \
    open(temp, "w", encoding="utf-8") as f2:
        for line in f1:

            if '\n' not in line: # 补 \n.
                line2 = line + '\n'  

            bs = radical.trans_ch(line[0]) # 部首
            if line[0].isascii() or bs is None: # line[0] 不是汉字, 或者“不能拆”
                line2 = line # 该条件已包含以'\n'开头的空行
            elif line[0]== bs: # 独体字
                line2 = line
            elif bs in bs_convert and line[5] in bs_convert[bs]: 
                line2 = line.replace(';'+line[5], 
                                     ';'+bs_convert[bs][line[5]])
            elif bs in bs_map and line[6]==bs_map[bs]: 
                # 部首被放在第四码, 则置换第三码和第四码
                line2 = line.replace(';'+line[5]+line[6],
                                     ';'+line[6]+line[5])
            else: 
                line2 = line

            f2.write(line2)

def reShape2(temp0, temp):
    # 计划整理第四码, not finished
    pass
                
def rmRepeat(temp, dst):
    # 去重. 
    # src: "input dict" ; dst: "new file name for the output dict"
    with open(temp, "r", encoding="utf-8") as f1, \
    open(dst, "w", encoding="utf-8") as f2:
        last10 = ['EMPTY\n']*10
        for line in f1:
            if line not in last10:
                f2.write(line)
                last10 = last10[1:] + [line, ]

file_to_convert = '../zrm_pinyin.standard_unique.dict.yaml'
reShape(file_to_convert, 'temp.yaml')   
os.rename(file_to_convert, file_to_convert+'.bak')
rmRepeat('temp.yaml', file_to_convert)