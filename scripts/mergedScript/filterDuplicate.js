import fs from 'node:fs';

const lines = fs.readFileSync('./shouxin.txt').toString().split('\n').filter(t => t !== '');
const s = new Set();

const newLines = lines.filter((l) => {
  if (s.has(l)) {
    return false;
  }
  s.add(l);
  return true;
});

fs.writeFileSync('./no_duplicate_shouxin.txt', newLines.join('\n'));
