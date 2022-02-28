def compare_same(a, b):
    return a[:2] == b[:2]

def is_chinese(uchar):
    """判断一个unicode是否是汉字"""
    if uchar >= u'\u4e00' and uchar<= u'\u9fff':
        return True
    elif uchar >= u'\u3400' and uchar <= u'\u4db5':
        return True
    else:
        return False

base_map = {}
origin_map = {}
bucket = {}
origin_bucket = {}
with open('./base.txt', 'r') as f:
    for line in f.readlines():
        items = line.split('\t')
        if items[1] in origin_bucket:
            origin_bucket[items[1]] += 1
        else:
            origin_bucket[items[1]] = 1
        if items[0] in origin_map:
            origin_map[items[0]].append(items)
        else:
            origin_map[items[0]] = [items]

with open('./base.txt', 'r') as f:
    for line in f.readlines():
        items = line.split('\t')
        if items[1] in bucket:
            bucket[items[1]] += 1
        else:
            bucket[items[1]] = 1
        if items[0] in base_map:
            flag = True
            i = 0
            for it in base_map[items[0]]:
                if compare_same(it[1], items[1]):
                    ao = origin_bucket[it[1]]
                    bo = origin_bucket[items[1]]
                    if ao <= bo:
                        origin_bucket[it[1]] += 1
                        origin_bucket[items[1]] -= 1
                        flag = False
                    else:
                        base_map[items[0]][i] = items
                    break
                i += 1
            if flag:
                base_map[items[0]].append(items)
        else:
            base_map[items[0]] = [items]

col = []
flat = []
utf8c = []

for k in base_map.keys():
    for it in base_map[k]:
        flat.append(it)
        col.append('\t'.join(it))
        if len(it[0]) > 1 or len(it[0].encode()) < 4:
            utf8c.append('\t'.join(it))

#  with open('output.txt', 'w') as f:
    #  f.writelines(''.join(col))

with open('output_chinese.txt', 'w') as f:
    f.writelines(''.join(utf8c))

