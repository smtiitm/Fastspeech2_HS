class TextReplacer:
    def __init__(self):
        self.replacements = {
        'aa':'A',
        'ae':'ऍ',
        'ag':'ऽ',
        'ai':'ऐ',
        'au':'औ',
        'axx':'अ',
        'ax':'ऑ',
        'bh':'B',
        'ch':'C',
        'dh':'ध',
        'dxhq':'T',
        'dxh':'ढ',
        'dxq':'D',
        'dx':'ड',
        'ee':'E',
        'ei':'ऐ',
        'eu':'உ',
        'gh':'घ',
        'gq':'G',
        'hq':'H',
        'ii':'I',
        'jh':'J',
        'khq':'K',
        'kh':'ख',
        'kq':'क',
        'ln':'ൾ',
        'lw':'ൽ',
        'lx':'ള',
        'mq':'M',
        'nd':'ऩ',
        'ng':'ङ',
        'nj':'ञ',
        'nk':'Y',
        'nn':'N',
        'nw':'ൺ',
        'nx':'ण',
        'oo':'O',
        'ou':'औ',
        'ph':'P',
        'rqw':'ॠ',
        'rq':'R',
        'rw':'ർ',
        'rx':'ऱ',
        'sh':'श',
        'sx':'ष',
        'txh':'ठ',
        'th':'थ',
        'tx':'ट',
        'uu':'U',
        'wv':'W',
        'zh':'Z'

    # ... Add more replacements as needed
        }
    
    def apply_replacements(self, text):
        for key, value in self.replacements.items():
            # print('KEY AND VALUE OF PARSED OUTPUT',key, value)
            text = text.replace(key, value)
        temp=""
        for i in range(len(text)):
            if text[i]!=" ":
                temp=temp+text[i]

        return temp

    def apply_replacements_by_phonems(self, text):
        ans=self.replacements[text]
        # for key, value in self.replacements.items():
        #     # print('KEY AND VALUE OF PARSED OUTPUT',key, value)
        #     text = text.replace(key, value)
        return ans
