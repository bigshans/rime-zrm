import fs from 'node:fs';
import { shouxinMap } from './checkDuplicate.js';

const mergeText = fs.readFileSync('/home/aerian/.local/share/fcitx5/rime/zrm_pinyin.dict.yaml').toString().split('\n');
const mergeTo = fs.readFileSync('../重排/dict').toString().split('\n');

const s = new Set();

const map = Object.fromEntries(
  mergeTo.map((w) => {
    return w.split(';');
  }).filter(([_, v]) => v).filter(([k, v]) => {
    if (s.has(k)) {
      return false;
    }
    s.add(k);
    return true;
  })
);

const dups = new Set();

const output = mergeText.map((w) => {
  if (!w.includes('\t')) {
    return w;
  }
  if (!w.includes(';')) {
    return w;
  }
  const res = w.split(';');
  const kw = res[0].split('\t')[0]
  if (map[res[0]] === 'zz') {
    res[1] = shouxinMap.get(kw)?.[0] || res[1];
  } else {
    res[1] = map[res[0]] || shouxinMap.get(kw)[0] || res[1];
  }
  return res.join(';');
}).filter((l) => {
  if (dups.has(l)) {
    return false;
  }
  dups.add(l);
  return true;
}).join('\n');

console.log(output);

fs.writeFileSync('./output', output);
