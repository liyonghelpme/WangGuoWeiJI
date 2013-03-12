#coding:utf8
from pycparser import *
from pycparser import c_generator
from pycparser.c_ast import *
parser = c_parser.CParser(lex_optimize=False, lextab='lex', yacctab='yacc', yacc_optimize=False, yacc_debug=True)
#lines = open('label.txt').read()
#import json
#lines = json.loads(lines)
generator = c_generator.CGenerator()
#lno = -1
#for l in lines:

def gen(l):
    #lno += 1
    #print lno
    #print l
    t = parser.parse(l)
    kind = t.ext[0].body.block_items[0]
    oldKind = kind

    #kind.show()

    print "old"
    print  generator.visit(oldKind)

    #调试函数调用 addlabel   xxx.addlabel() StructRef  label()
    while type(kind) != type(''):
        print kind.__class__.__name__
        if kind.__class__.__name__ == 'FuncCall':
            if kind.name.__class__.__name__ == 'StructRef':
                #print kind.name.field.name
                if kind.name.field.name == 'addsprite':
                    print 'arguments', kind.args.exprs
                    hasArgb = False
                    for e in kind.args.exprs:
                        if e.__class__.__name__ == 'ID':
                            if e.name.find('RGB') != -1:
                                hasArgb = True
                                break

                    if not hasArgb:
                        kind.args.exprs.append(ID('ARGB_8888'))
            elif kind.name.__class__.__name__  == 'ID':
                if kind.name.name == 'sprite':
                    print 'arguments', kind.args.exprs
                    hasArgb = False
                    for e in kind.args.exprs:
                        if e.__class__.__name__ == 'ID':
                            if e.name.find('RGB') != -1:
                                hasArgb = True
                                break
                    if not hasArgb:
                        kind.args.exprs.append(ID('ARGB_8888'))
        elif kind.__class__.__name__ == 'Assignment':
            kind = kind.rvalue
            continue
        elif kind.__class__.__name__ == 'Decl':
            kind = kind.init
            continue
        if kind.__class__.__name__ == 'ID':
            break
        kind = kind.name
    #print kind
    #print l
    print "new"
    newL = generator.visit(oldKind)
    print newL
    return newL+';'

