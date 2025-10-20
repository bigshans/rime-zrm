import fs from 'node:fs';

export const dictMap = Object.fromEntries(
  fs.readFileSync('/home/aerian/.local/share/fcitx5/rime/zrm_pinyin.dict.yaml')
  .toString()
  .split('\n')
  .filter(w => w.includes('\t') && w.includes(';'))
  .map(w => {
    const [k, v] = w.split(';')
    const nv = v.split('\t')[0]
    return [k, nv]
  })
)
