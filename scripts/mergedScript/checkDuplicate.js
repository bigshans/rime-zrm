import fs from 'node:fs';

const lines = fs.readFileSync('./no_duplicate_shouxin.txt').toString().replaceAll('\r', '').split('\n').filter(t => t !== '').map(t => t.split('\t'));

const s = new Map();

for (const [k, v] of lines) {
  if (s.has(k)) {
    s.get(k).push(v);
  } else {
    s.set(k, [v]);
  }
}

const dups = [];

for (const [k, v] of s.entries()) {
  if (v.length > 1) {
    dups.push(k);
  }
}

export const shouxinMap = s;
