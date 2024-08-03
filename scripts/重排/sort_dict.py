from opencc import OpenCC
cc = OpenCC('t2s')

def convertTo(a) -> int:
    a_w = cc.convert(a["w"])
    a_num = words_map[a_w] if (a_w in words_map) else 3
    return a_num

dict_map = {}
words_map = {}
with open('./现代汉语常用字表.csv', mode='r') as f:
    for line in f.readlines():
        l = line.replace('\n', '').split(',')
        words_map[l[1]] = int(l[2])
with open('./dict', mode='r') as f:
    for line in f.readlines():
        l = line.replace('\n', '').split('\t')
        if len(l) == 1:
            continue
        w = l[0]
        p = l[1]
        pp = p.split(';')[0]
        if pp in dict_map:
            dict_map[pp].append({ 'w': w, 'p': '\t'.join(l[1:]) })
        else:
            dict_map[pp] = [{ 'w': w, 'p': '\t'.join(l[1:]) }]
lines = []

for k in dict_map.keys():
    item = dict_map[k]
    sorted_item = sorted(item, key = lambda a: convertTo(a))
    for it in sorted_item:
        lines.append(f'{it['w']}\t{it['p']}\n')

with open('./dict_sorted', mode='w') as f:
    f.writelines(lines)
