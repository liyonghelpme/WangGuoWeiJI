class LoveUpgradeDialog extends MyNode
{
    //当前等级
    //bg.addlabel(getStr("爱心树升级", null), "fonts/heiti.ttf", 28).anchor(50, 50).pos(404, 92).color(100, 100, 100);
    function LoveUpgradeDialog(lev)
    {
        bg = node();
        bg.add(showFullBack());
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252);
        bg.addsprite("whiteBoard.png").anchor(0, 0).pos(184, 175).size(314, 182);
        bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57);
        bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57);
        bg.addlabel(getStr("loveUp", null), "fonts/heiti.ttf", 35).anchor(50, 50).pos(400, 93).color(32, 33, 40);
        bg.addlabel(getStr("conLoveUp", ["[NUM]", str(lev+2)]), "fonts/heiti.ttf", 21).anchor(50, 50).pos(410, 146).color(43, 25, 9);

/*
bg.addlabel(getStr("恭喜你获得了爱心魔法书! 集齐爱心套装，将会有意想不到的效果哦！", null), "fonts/heiti.ttf", 31).anchor(0, 0).pos(193, 319).color(100, 100, 100);
*/

        var con = colorLines(getStr("lessGetEquip", ["[NUM]", str(0),"[NAME]", str("装备")]), 18, 20);
        con.pos(193, 310);
        bg.add(con);
        var cSize = con.size();

        con = colorLines(getStr("lessTip", null), 14, 20);
        con.pos(193, 310+cSize[1]);
        bg.add(con);

        var but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("share", null), null, 33, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 33, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(519, 402);
        addChild(but0);
        var leftTree = bg.addsprite("build"+str(PARAMS["loveTreeId"]+lev)+".png").anchor(50, 50).pos(254, 241);
        var sca = getSca(leftTree, [131, 122]);
        leftTree.scale(sca);//.size(131, 122);

        var rightTree = bg.addsprite("build"+str(PARAMS["loveTreeId"]+lev+1)+".png").anchor(50, 50).pos(426, 241);
        sca = getSca(rightTree, [131, 122]);
        rightTree.scale(sca);//.size(131, 122);

        bg.addsprite("rightArrow.png").anchor(0, 0).pos(320, 230).size(40, 34);
        bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302);
        bg.addsprite("rightBalloon.png").anchor(0, 0).pos(664, 43).size(120, 343);
        //bg.addlabel(getStr("加10生命值", null), "fonts/heiti.ttf", 17).anchor(50, 50).pos(573, 312).color(29, 16, 4);
        bg.addlabel(getStr("equipDes", null), "fonts/heiti.ttf", 21).anchor(50, 50).pos(573, 312).color(29, 16, 4);
        var equip = bg.addsprite("equip0.png").anchor(50, 50).pos(573, 243);
        sca = getSca(equip, [106, 108]);
        equip.scale(sca);
    }
    function onShare()
    {
        global.director.popView();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
