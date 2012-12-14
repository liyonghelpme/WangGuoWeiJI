//点击按钮 调用回调函数
class ResLackBanner extends MyNode
{
    var movAni = moveto(0, 0, 0);
    //var callback;
    var store;
    function ResLackBanner(w, col, butWord, buyParam, s)
    {
        store = s;
        //callback = cb;
        if(col == null)
            col = [100, 100, 100];
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        var word = colorWordsNode(w, 20, col, [89, 72, 18]);
        word.anchor(0, 50);
        bg.add(word);

        var but0 = new NewButton("roleNameBut0.png", [95, 39], getStr(butWord, null), null, 18, FONT_NORMAL, [100, 100, 100], buyIt, buyParam);
        but0.bg.pos(333, 27);
        addChild(but0);

        /*
        根据文字长度 设定 背景长度
        根据背景长度 设定 文字位置
        */
        var MARGIN = 20;
        var wSize = word.size();
        var bSize = bg.prepare().size();
        var butSize = but0.bg.size();
        var totalSize = wSize[0]+10+MARGIN+butSize[0];//字符宽度+间隔5+按钮宽度+两侧空余宽度
        bg.size(max(totalSize, bSize[0]), bSize[1]);
        var nBsize = bg.size();

        trace("nBSize", nBsize, totalSize);
        var wOffx = (nBsize[0]-totalSize)/2;
        word.pos(wOffx, nBsize[1]/2);
        but0.bg.pos(wOffx+wSize[0]+MARGIN+butSize[0]/2, nBsize[1]/2);

        bg.addaction(sequence(delaytime(2000), fadeout(1000), callfunc(removeNow)));
    }
    function buyIt(param)
    {
        removeSelf();
        //var store = new Store(global.director.curScene);
        //global.director.pushView(store,  1, 0);
        if(store == null)
        {
            store = new Store(global.director.curScene);
            global.director.pushView(store, 1, 0);
        }
        store.changeTab(param);
    }
    function removeNow()
    {
        removeSelf();
        //if(callback != null)
        //    callback();
    }

    function setMoveAni(X, Y)
    {
        trace("setMoveAni", X, Y);
        movAni.stop();
        trace("addaction", movAni);
        movAni = expout(moveto(getParam("bannerMoveTime"), X, Y));
        bg.addaction(movAni);
    }
}
