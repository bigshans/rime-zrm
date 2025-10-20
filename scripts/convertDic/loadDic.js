import fs from 'node:fs';
import { convertToZrm } from './convert.js';

const lines = fs.readFileSync('./cn_en_simp.yaml').toString().replaceAll('/r', '').split('\n').filter(t => t !== '').map(t => t.split('\t'));

function isLetter(ch) {
  return /^[A-Za-z]$/.test(ch);
}

export const dicts = lines.map((ls) => {
  const words = ls[0].split('');
  const pinyins = ls[1].split(' ').map((p, index) => isLetter(words[index]) ? p : convertToZrm(p));
  ls[0] = words;
  ls[1] = pinyins;
  return ls;
});
