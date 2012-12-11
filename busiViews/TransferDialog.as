class TransferDialog extends MyNode
{
    var soldier;
    function TransferDialog(s)
    {
        soldier = s;
        initView();
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        var curKind = soldier.id;
        var nextKind = curKind+1;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(167, 133).size(485, 256).color(100, 100, 100, 100);
        temp = bg.addsprite("scoreWhite.png").anchor(0, 0).pos(184, 175).size(314, 182).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57).color(100, 100, 100, 100);
        var curData = getData(SOLDIER, curKind);
        var newData = getData(SOLDIER, nextKind);

        trace("curData newData", curData, newData);
        line = stringLines(
            getStr("transferBenefit", 
            ["[ATT]", str(newData["attack"]-curData["attack"]),
                "[DEF]", str(newData["defense"]-curData["defense"]),
                "[HEALTH]", str(newData["healthBoundary"]-curData["healthBoundary"]),
                "[CRITICAL]", str(newData["criticalHitRate"]-curData["criticalHitRate"]),
                "[MISS]", str(newData["missRate"]-curData["missRate"]),
            ]
            ), 
        18, 20, [28, 15, 4], FONT_NORMAL );
        line.pos(525, 195);
        bg.add(line);

        bg.addlabel(getStr("transferTime", ["[TIME]", getDayTime(curData["transferTime"])]), "fonts/heiti.ttf", 18).anchor(0, 50).pos(192, 337).color(28, 15, 4);
        bg.addlabel(getStr("transferSoldier", null), "fonts/heiti.ttf", 30).anchor(0, 50).pos(355, 93).color(32, 33, 40);
        bg.addlabel(getStr("inTransferNoWar", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(299, 147).color(43, 25, 9);
        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("onTransfer", ["[KIND]", "crystal.png", "[NUM]", str(curData["transferCrystal"])]), null, 27, FONT_NORMAL, [100, 100, 100], onTransfer, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        var buyable = global.user.checkCost(dict([["crystal", curData["transferCrystal"]]]));
        if(buyable["ok"] == 0)
        {
            but0.setGray();
            but0.setCallback(null);
        }

        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("cancel", null), null, 27, FONT_NORMAL, [100, 100, 100], onCancel, null);
        but0.bg.pos(519, 402);
        addChild(but0);

        temp = bg.addsprite("soldier"+str(curKind)+".png").anchor(50, 50).pos(253, 255).color(100, 100, 100, 100);
        sca = getSca(temp, [125, 122]);
        temp.scale(sca);
        temp = bg.addsprite("soldier"+str(curKind+1)+".png").anchor(50, 50).pos(427, 255).color(100, 100, 100, 100);
        sca = getSca(temp, [125, 122]);
        temp.scale(sca);
        temp = bg.addsprite("taskArrow.png").anchor(50, 50).pos(341, 261).size(40, 34).color(100, 100, 100, 100).rotate(-90);
    }
    function onTransfer()
    {
        global.httpController.addRequest("soldierC/doTransfer", dict([["uid", global.user.uid], ["sid", soldier.sid]]), null, null);
        var curData = getData(SOLDIER, soldier.id);
        global.user.doCost(dict([["crystal", curData["transferCrystal"]]]));
        soldier.doTransfer();
        global.director.popView();
    }
    function onCancel()
    {
        global.director.popView();
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
