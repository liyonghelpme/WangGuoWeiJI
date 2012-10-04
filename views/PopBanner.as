//可能弹出多个数据
class PopBanner extends MyNode
{
    var showData;
    var showBanner = [];
    var delta = 0;
    const DIF_T = 3000;
    function PopBanner(s)
    {
        showData = s;
        bg = node();
        init();
        delta = 0;
        var its = showData.items();
        var offY = 60;
        var curY = 0;
        for(var i = 0; i < len(its); i++)
        {
            var k = its[i][0];
            var v = its[i][1];
            if(v != 0)
            {
                var banner = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2+curY).anchor(50, 50);
                bg.add(banner);
                var w;
                if(v > 0)
                    w = getStr("opSuc", ["[NUM]", "+"+str(v), "[KIND]", getStr(k, null)]);
                else
                    w = getStr("opSuc", ["[NUM]", str(v), "[KIND]", getStr(k, null)]);
                var word = colorWordsNode(w, 20, [100, 100, 100], [89, 72, 18]);
                word.anchor(50, 50);
                banner.add(word);

                var wSize = word.size();
                var bSize = banner.prepare().size();
                banner.size(max(wSize[0]+10, bSize[0]), bSize[1]);
                var nBsize = banner.size();
                word.pos(nBsize[0]/2, nBsize[1]/2);

                bg.addaction(sequence(delaytime(2000), fadeout(1000)));//, callfunc(removeNow)
                curY -= offY;
            }
        }
    }
    function update(diff)
    {
        delta += diff;
        if(delta >= DIF_T)
        {
            removeSelf();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
}
