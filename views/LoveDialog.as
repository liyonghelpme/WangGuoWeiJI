/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

>= 当前等级的 未购买的物品

show update 


bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(520, 312);
bg.addsprite("loginBack.png").anchor(0, 0).pos(18, 43).size(483, 254);
bg.addsprite("whiteBoard.png").anchor(0, 0).pos(34, 84).size(314, 182);
bg.addsprite("diaBack.png").anchor(0, 0).pos(51, -28).size(418, 57);
bg.addsprite("scroll.png").anchor(0, 0).pos(73, 23).size(374, 57);
var but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("buyLoveEquip", null), null, 18, FONT_NORMAL, [100, 100, 100], onBuy, null);
but0.bg.pos(149, 311);
addChild(but0);
but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
but0.bg.pos(369, 311);
addChild(but0);
bg.addsprite("build208.png").anchor(0, 0).pos(387, 124).size(80, 101);
bg.addlabel(getStr("loveTree", null), "fonts/heiti.ttf", 35).anchor(50, 50).pos(272, 2).color(32, 33, 40);
bg.addlabel(getStr("loveIrrigate", null), "fonts/heiti.ttf", 24).anchor(50, 50).pos(264, 54).color(43, 25, 9);
bg.addlabel(getStr("loveAcc", null), "fonts/heiti.ttf", 136).anchor(0, 0).pos(50, 114).color(100, 100, 100);
*/
class LoveDialog extends MyNode
{
    var tree;
    //显示用户的爱心数据
    function LoveDialog(t)
    {
        tree = t;
        bg = sprite("back.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2 ).size(520, 312);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(18, 43).size(483, 254);
        bg.addsprite("whiteBoard.png").anchor(0, 0).pos(34, 84).size(314, 182);
        bg.addsprite("smallBack.png").anchor(0, 0).pos(51, -28).size(418, 57);
        bg.addsprite("scroll.png").anchor(0, 0).pos(73, 23).size(374, 57);
        init();

        var but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("buyLoveEquip", null), null, 27, FONT_NORMAL, [100, 100, 100], onBuy, null);
        but0.bg.pos(149, 311);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(369, 311);
        addChild(but0);

        //bg.addsprite("树a1.png").anchor(50, 50).pos(427, 174).size(80, 101);
        var treePic = bg.addsprite("build"+str(tree.id+tree.buildLevel)+".png").anchor(50, 50).pos(427, 174);
        var sca = getSca(treePic, [80, 101]);
        treePic.scale(sca);

        bg.addlabel(getStr("loveTree", ["[LEV]", str(tree.buildLevel+1), "[NAME]", tree.data["name"]]), "fonts/heiti.ttf", 35).anchor(50, 50).pos(260, 2).color(32, 33, 40);
        bg.addlabel(getStr("loveIrrigate", null), "fonts/heiti.ttf", 22).anchor(50, 50).pos(260, 54).color(43, 25, 9);
        //getStr("loveAcc", null)
        var leftNum = 0;
        if(tree.buildLevel < len(loveTreeHeart))
            leftNum = loveTreeHeart[tree.buildLevel]-global.user.getValue("accNum");
        var con = colorLines(getStr("loveAcc", ["[N0]", str(global.user.getValue("weekNum")),"[N1]", str(global.user.getValue("accNum")), "[N2]", str(leftNum)]), 18, 25);
        con.pos(50, 114);
        bg.add(con);
        var conSize = con.size();

        con = colorLines(getStr("loveAccTip", ["[N0]", str(global.user.getValue("weekNum")),"[N1]", str(global.user.getValue("accNum")), "[N2]", str(leftNum)]), 16, 25);
        con.pos(50, 114+conSize[1]);
        bg.add(con);

    }
    function onBuy()
    {
    }
    function onInvite()
    {
    }
    /*
    function onRank()
    {
        global.director.popView();
        //global.director.pushView(new HeartRankDialog(), 1, 0);
        global.director.pushView(new RankDialog(HEART_RANK), 1, 0);
    }
    */

    function closeDialog()
    {
        global.director.popView();
    }
}
