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
        if(bs[0] == 0)
        {
            bs = pic.prepare().size();//如果没有限定按钮宽度则根据图片生成
        }
bg = sprite(pic, ARGB_8888).size(bs).anchor(50, 50);
        init();
        word = new ShadowWords(w, ty, sz, bo, col);
        word.bg.pos(bs[0]/2, bs[1]/2).anchor(50, 50);
        addChild(word);

        var wSize = word.bg.size();
        var width = max(bs[0], wSize[0]+getParam("butWidth"));
        bg.size(width, bs[1]);
        word.bg.pos(width/2, bs[1]/2);


        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function setGray()
    {
        //bg.texture(pc, GRAY); 
        bg.texture("grayButton.png");
    }
    function setWhite()
    {
        bg.texture(pc);
    }

    function touchBegan(n, e, p, x, y, points)
    {
        global.controller.playSound("but.mp3");

        oldSca = bg.scale();
        bg.scale(oldSca[0]*getParam("butScale")/100, oldSca[1]*getParam("butScale")/100);
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var po = n.node2world(x, y);
        //var ret = checkIn(bg, po);
        var ret = 1;

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
