class ResourceBanner extends MyNode
{
    var buyable;
    /*
    506 231
    */
    function ResourceBanner(b, ix, iy)
    {
        buyable = b;
        bg = node();
        init();
        var it = buyable.items();
        var num = len(it)-1;
        var initY = iy-num/2*53;
        var initX = ix;
        for(var i = 0; i < len(it); i++)
        {
            if(it[i][0] != "ok")
            {
                var banner = bg.addsprite("storeBlack.png").pos(initX, initY).anchor(50, 50);
banner.addlabel(getStr("resLack", ["[NAME]", getStr(it[i][0], null), "[NUM]", str(it[i][1])]), "fonts/heiti.ttf", 25).pos(154, 25).anchor(50, 50).color(100, 100, 100);
                initY += 53;
            } 
        }
        bg.addaction(sequence(delaytime(2000), callfunc(removeSelf)));
    }
}
