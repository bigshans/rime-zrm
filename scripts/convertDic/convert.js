const singlePron = {
  a: 'aa',
  e: 'ee',
  o: 'ee',
  ang: 'ah',
  eng: 'eh',
};

const yunmu = {
  iang: 'd',
  uang: 'd',
  iong: 's',
  ong: 's',
  eng: 'g',
  ang: 'h',
  uan: 'r',
  ian: 'm',
  ing: 'y',
  uai: 'y',
  iao: 'c',
  iu: 'q',
  ia: 'w',
  ua: 'w',
  ue: 't',
  uo: 'o',
  un: 'p',
  en: 'f',
  an: 'j',
  ao: 'k',
  ai: 'l',
  ei: 'z',
  ie: 'x',
  ui: 'v',
  ou: 'b',
  in: 'n',
  a: 'a',
  e: 'e',
  u: 'u',
  i: 'i',
  o: 'o',
  'v': 'v',
}

export function convertToZrm(pinyin) {
  if (singlePron[pinyin]) {
    return singlePron[pinyin];
  }
  const first = pinyin.charAt(0);
  if (['a', 'e'].some(v => first === v)) {
    return pinyin;
  }
  if (pinyin.length === 1) {
    return pinyin;
  }
  let result = '';
  let rest = pinyin;
  if (['zh', 'ch', 'sh'].some(s => pinyin.startsWith(s))) {
    rest = pinyin.replace('zh', 'v').replace('ch', 'i').replace('sh', 'u');
  }
  result = rest.charAt(0);
  const t = yunmu[rest.slice(1)];
  return result + t;
}
