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

        /*
        bg = label(w, "fonts/heiti.ttf", sz, bo).color(col);
        init();
        shadow = label(w, "fonts/heiti.ttf", sz, bo).color(0, 0, 0).pos(1, 1);
        bg.add(shadow, -1);
        */
    }
    function setWords(w)
    {
        picWord.removefromparent();
        picWord = picNumWord(w, wSize, wColor);
        picWord.pos(0, picWord.size()[1]/2);
        bg.add(picWord);
        bg.size(picWord.size());

        //bg.text(w);
        //shadow.text(w);
    }
}
