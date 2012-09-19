class ResourceWarningDialog extends MyNode
{
    var callback;
    var cost;
    var realCost;
    //var param;
    //buyable 是否可以购买
    //realCost 实际的消耗
    //realCost 中的值不能修改 需要以回调参数的形式传回给callback
    function ResourceWarningDialog(t, c, cb, buyable, rc, pic)
    {
        realCost = rc;
        //param = par;
        cost = buyable;
        callback = cb;

        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addlabel(t, null, 30, FONT_BOLD).pos(243, 29).anchor(50, 50).color(0, 0, 0);
        var con = bg.addlabel(c, null, 20, FONT_NORMAL, 263, 0, ALIGN_LEFT).pos(177, 86).color(0, 0, 0);
        var conSize = con.prepare().size();


        var peop = bg.addsprite(pic).pos(61, 86);
        peop.prepare();
        var sca = getSca(peop, [111, 111]);
        peop.scale(sca);

        var but;
        var fil = [0, 100, 0];
        var showData = realCost;
        if(buyable.get("ok") == 1)
        {
            but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, onOk);
            but.addlabel(getStr("ok", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
            but = bg.addsprite("roleNameBut1.png").size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            but.addlabel(getStr("cancel", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);

        }
        else
        {
            fil = [100, 0, 0];
            showData = buyable;
            buyable.pop("ok");

            but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, onBuy);//资源不足显示
            but.addlabel(getStr("buyIt", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
            but = bg.addsprite("roleNameBut1.png").size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            but.addlabel(getStr("cancel", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        }
        
        var item = showData.items();
        //中间内容的高度+10
        var initY = 86+conSize[1]+10;

        for(var i = 0; i < len(item); i++)
        {
            bg.addlabel(getStr("resList", ["[NAME]", getStr(item[i][0], null), "[VAL]", str(item[i][1])]), null, 18, FONT_NORMAL).pos(177, initY).color(fil[0], fil[1], fil[2]);
            initY += 20;
        }

        showCastleDialog();
    }
    function onOk()
    {
        closeCastleDialog();
        if(callback != null)
            callback(realCost);
    }

    function onBuy()
    {
        closeCastleDialog();
        var c = cost.items()[0];
        var store = new Store(global.director.curScene);
        if(c[0] == "silver")
        {
            store.changeTab(store.SILVER_PAGE);
        }
        else if(c[0] == "crystal")
        {
            store.changeTab(store.CRYSTAL_PAGE);
        }
        else if(c[0] == "gold")
        {
            store.changeTab(store.GOLD_PAGE);
        }
        global.director.pushView(store);
    }
    function closeDialog()
    {
        closeCastleDialog();
    }
}

