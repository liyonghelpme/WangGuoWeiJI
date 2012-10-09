/*
图片类型 size
上面正中字体ShadowWords

不能使用enterScene exitScene 功能
因为 所在的 panel 不是 MyNode 类型 
*/
class NewButton extends MyNode
{
    var callback;
    var param;
    var word;
    var oldSca;
    var pc;
    function NewButton(pic, bs, w, ty, sz, bo, col, cb, pa)
    {
        pc = pic;
        callback = cb;
        param = pa;
        bg = sprite(pic).size(bs).anchor(50, 50);
        init();
        word = new ShadowWords(w, ty, sz, bo, col);
        word.bg.pos(bs[0]/2, bs[1]/2).anchor(50, 50);
        addChild(word);


        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function setGray()
    {
        bg.texture(pc, GRAY); 
    }
    function setWhite()
    {
        bg.texture(pc);
    }

    var player = null;
    function touchBegan(n, e, p, x, y, points)
    {
        player = global.controller.butMusic.play(0, 80, 80, 0, 100);
        oldSca = bg.scale();
        bg.scale(oldSca[0]*80/100, oldSca[1]*80/100);
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var po = n.node2world(x, y);
        var ret = checkIn(bg, po);

        player.stop();
        bg.scale(oldSca);

        if(ret)
        {
            if(callback != null)
                callback(param);
        }
    }
    function setCallback(cb)
    {
        callback = cb;
    }
}
