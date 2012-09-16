/*
图片类型 size
上面正中字体ShadowWords
*/
class NewButton extends MyNode
{
    var callback;
    var param;
    var word;
    var oldSca;
    function NewButton(pic, bs, w, ty, sz, bo, col, cb, pa)
    {
        callback = cb;
        param = pa;
        bg = sprite(pic).size(bs);
        init();
        word = new ShadowWords(w, ty, sz, bo, col);
        word.bg.pos(bs[0]/2, bs[1]/2).anchor(50, 50);
        addChild(word);

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function touchBegan(n, e, p, x, y, points)
    {
        oldSca = bg.scale();
        bg.scale(oldSca[0]*80/100, oldSca[1]*80/100);
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        bg.scale(oldSca);
        if(callback != null)
            callback(param);
    }
    function setCallback(cb)
    {
        callback = cb;
    }
}
