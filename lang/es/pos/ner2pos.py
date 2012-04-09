#!/usr/bin/python
'''
Converts a file with the CoNLL task format [1] to the format commonly used for
training POS taggers.

This script also allows to use universal POS tags, as described by:

http://code.google.com/p/universal-pos-tags/

[1] http://www.lsi.upc.edu/~nlp/tools/nerc/nerc.html

'''
import sys
import argparse
import codecs
import fileinput

# Universal tags mapping table:
# http://code.google.com/p/universal-pos-tags/
# http://code.google.com/p/universal-pos-tags/source/browse/trunk/es-cast3lb.map
universal_tags = {
    'Fa':'.',
    'Fc':'.',
    'Fd':'.',
    'Fe':'.',
    'Fg':'.',
    'Fh':'.',
    'Fi':'.',
    'Fp':'.',
    'Fs':'.',
    'Fx':'.',
    'Fz':'.',
    'X':'X',
    'Y':'X',
    'Zm':'NUM',
    'Zp':'NUM',
    'AO':'ADJ',
    'AQ':'ADJ',
    'CC':'CONJ',
    'CS':'CONJ',
    'DA':'DET',
    'DD':'DET',
    'DE':'DET',
    'DI':'DET',
    'DN':'DET',
    'DP':'DET',
    'DT':'DET',
    'I':'X',
    'NC':'NOUN',
    'NP':'NOUN',
    'P0':'PRON',
    'PD':'PRON',
    'PE':'PRON',
    'PI':'PRON',
    'PN':'PRON',
    'PP':'PRON',
    'PR':'PRON',
    'PT':'PRON',
    'PX':'PRN',
    'RG':'ADV',
    'RN':'ADV',
    'SN':'ADP',
    'SP':'ADP',
    'VA':'VERB',
    'VM':'VERB',
    'VS':'VERB',
    'W':'NUM',
    'Z':'NUM'
}

def parse_lines(in_file, universal=False):
    '''
    Convert 
    '''
    sentence = []
    for line in in_file:
        parts = line.strip().split()
        
        if not parts and sentence:
            # Skip sentence that have onle a delimiter, such as '-' or '='
            if len(sentence) > 2:
                print u' '.join(sentence)
            sentence = []
        
        if len(parts) != 3:
            continue
        
        word, tag, _ = parts
        if word.startswith('==='):
            continue
          
        if universal:
            tag = universal_tags.get(tag, tag)
          
        sentence.append('%s_%s' % (word, tag))
    


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--universal', '-u', action='store_true', 
        help='Use Universal Part-of-Speech Tags', default=False)
    parser.add_argument('--input_encoding', default='latin1',
        help='Input file encoding (latin1 by default)')
    parser.add_argument('input_file', type=argparse.FileType('r'), nargs='+',
        help='Input files.', default=sys.stdin)

    args = parser.parse_args()

    sys.stdout = codecs.getwriter('utf-8')(sys.stdout)

    
    for in_file in args.input_file:
        in_file = codecs.getreader(args.input_encoding)(in_file)
        parse_lines(in_file, universal=args.universal)
    

if __name__ == '__main__':
    main()
    
