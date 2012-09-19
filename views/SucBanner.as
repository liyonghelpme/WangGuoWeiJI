/*
class SucBanner extends MyNode
{
    function SucBanner()
    {
        bg = sprite("storeBlack2.png").pos(506, 231).anchor(50, 50);
        bg.addlabel(getStr("buySuc", null), null, 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);
        bg.addaction(sequence(delaytime(2000), fadeout(1000), callfunc(removeSelf)));
    }
}
*/

class UpgradeBanner extends MyNode
{
    var callback;
    function UpgradeBanner(w, col, cb)
    {
        callback = cb;
        if(col == null)
            col = [100, 100, 100];
        bg = sprite("storeBlack2.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        var word = bg.addlabel(w, "fonts/heiti.ttf", 20).pos(154, 25).anchor(50, 50).color(col);

        /*
        根据文字长度 设定 背景长度
        根据背景长度 设定 文字位置
        */
        var wSize = word.prepare().size();
        var bSize = bg.prepare().size();
        bg.size(max(wSize[0]+10, bSize[0]), bSize[1]);
        var nBsize = bg.size();
        word.pos(nBsize[0]/2, nBsize[1]/2);

        bg.addaction(sequence(delaytime(2000), fadeout(1000), callfunc(removeNow)));
    }
    function removeNow()
    {
        removeSelf();
        if(callback != null)
            callback();
    }
}
