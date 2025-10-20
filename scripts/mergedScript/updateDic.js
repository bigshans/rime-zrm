import fs from 'node:fs';

const dictMap = Object.fromEntries(
  fs.readFileSync('./output')
  .toString()
  .split('\n')
  .filter(w => w.includes('\t') && w.includes(';'))
  .map(w => {
    const [k, v] = w.split(';')
    const nv = v.split('\t')[0]
    return [k, nv]
  })
)

function main(path, outputPath) {
  const dictText = fs.readFileSync(path).toString()
    .split('\n').map((w) => {
    if (w.startsWith('#')) {
      return w;
    }
    if (w === '') {
      return w;
    }
    if (!(w.includes('\t') && w.includes(';'))) {
      return w;
    }
    const res = w.split('\t')
    const [word, value] = res;
    const char = word.split('');
    const charV = value.split(' ');
    const newValue = [];
    for (let i = 0, len = charV.length; i < len; i++) {
      if (charV[i].includes(';')) {
        const [k, a] = charV[i].split(';');
        const aux = dictMap[`${char[i]};${k}`]
        newValue.push(`${k};${aux || a || ''}`);
      } else {
        newValue.push(charV[i]);
      }
    }
    res[1] = newValue.join(' ');
    return res.join('\t');
  }).join('\n');
  fs.writeFileSync(outputPath, dictText);
}

[
  'zrm_pinyin.cn_en.dict.yaml',
  'zrm_pinyin.poem.dict.yaml',
  'zrm_pinyin.user.dict.yaml',
  'zrm_pinyin.phrase.dict.yaml',
  'zrm_pinyin.computer.dict.yaml',
  'zrm_pinyin.sogou.dict.yaml',
  'zrm_pinyin.yuanshen.dict.yaml',
  'zrm_pinyin.append.dict.yaml',
].map(p => `/home/aerian/.local/share/fcitx5/rime/${p}`).forEach((p) => {
  main(p, p);
});
