import c_lexer
def erf(msg, a, b):
    print msg, a, b

def tylook(name):
    return False
l = c_lexer.CLexer(erf, tylook)
l.build()
