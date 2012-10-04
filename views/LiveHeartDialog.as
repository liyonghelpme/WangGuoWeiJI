/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

>= 当前等级的 未购买的物品

show update 


*/
class LiveHeartDialog extends MyNode
{
    var tree = null;
    //显示用户的爱心数据
    function LiveHeartDialog()
    {
        var allBuildings = global.user.buildings.values();

        for(var i = 0; i < len(allBuildings); i++)
        {
            var kind = allBuildings[i].get("id");
            var bd = getData(BUILD, kind);
            if(bd.get("funcs") == LOVE_TREE)
            {
                tree = allBuildings[i];
                break;
            }
        }

        bg = node();
        bg.add(showFullBack());

        init();
        var back = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312);

        back.addsprite("loginBack.png").anchor(0, 0).pos(18, 43).size(483, 254);
        back.addsprite("whiteBoard.png").anchor(0, 0).pos(33, 83).size(316, 184);
        back.addsprite("scroll.png").anchor(0, 0).pos(73, 23).size(374, 57);
        back.addsprite("smallBack.png").anchor(0, 0).pos(51, -28).size(418, 57);
        back.addlabel(getStr("congHeart", ["[NUM]", str(global.user.getValue("weekNum"))]), "fonts/heiti.ttf", 24).anchor(50, 50).pos(263, 55).color(43, 25, 9);

        var treePic = back.addsprite("build"+str(PARAMS["loveTreeId"]+tree.get("level"))+".png").anchor(50, 50).pos(428, 177);
        var sca = getSca(treePic, [78, 113]);//.size(78, 113);
        treePic.scale(sca);

        bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302);
        bg.addsprite("rightBalloon.png").anchor(0, 0).pos(665, 40).size(120, 342);

        var level = tree.get("level");//建筑物等级数据
        var data = getData(BUILD, tree.get("id"));

        var weekNum = (global.user.serverTime - global.user.registerTime)/(24*3600*7);//7天1周
        back.addlabel(getStr("numWeek", ["[NUM]", str(weekNum)]), "fonts/heiti.ttf", 35).anchor(50, 50).pos(257, 2).color(32, 33, 40);

        
        var leftNum = loveTreeHeart[tree["level"]]-global.user.getValue("accNum");
        var con = colorLines(getStr("liveCon", ["[N0]", str(global.user.heartRank),"[NAME]", str("未知")]), 18, 25);
        con.pos(49, 114);
        back.add(con);
        var cSize = con.size();

        con = colorLines(getStr("liveTip", null), 16, 18);
        con.pos(49, 114+cSize[1]);
        back.add(con);

        var but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("buyLoveEquip", null), null, 25, FONT_NORMAL, [100, 100, 100], onBuy, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 25, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(519, 402);
        addChild(but0);


        global.httpController.addRequest("friendC/collectHeart", dict([["uid", global.user.uid]]), null, null);
        global.user.collectHeart();
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
        //global.director.pushView(new RankDialog(HEART_RANK), 1, 0);

    }
    */

    function closeDialog()
    {
        global.director.popView();
    }
}
