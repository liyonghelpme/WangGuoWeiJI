class ShadowWords extends MyNode
{
    //var shadow;
    var picWord;
    var wSize;
    var wColor;
    function ShadowWords(w, ty, sz, bo, col)
    {
        wSize = sz;
        wColor = col;
        bg = node();
        init();
        picWord = picNumWord(w, wSize, wColor);
        picWord.pos(0, picWord.size()[1]/2);
        bg.add(picWord);
        bg.size(picWord.size());

    }
    function setWords(w)
    {
        picWord.removefromparent();
        picWord = picNumWord(w, wSize, wColor);
        picWord.pos(0, picWord.size()[1]/2);
        bg.add(picWord);
        bg.size(picWord.size());

    }
    function setSize(n)
    {
        wSize = n; 
    }
}
