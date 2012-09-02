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

        bg = sprite("dialogUpdate.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        var level = tree.get("id")-LOVE_TREE_ID;
        var data = getData(BUILD, tree.get("id"));

        var weekNum = (global.user.serverTime - global.user.registerTime)/(24*3600*7);//7天1周

        var tit = getStr("liveHeart", ["[NUM]", str(weekNum), "[NUM1]", str(global.user.getValue("liveNum"))]);
        bg.addlabel(tit, null, 25, FONT_BOLD).pos(267, 26).anchor(50, 50).color(33, 33, 40);

        var w = getStr("moreHeart", null);

        var pic = bg.addsprite(replaceStr(KindsPre[BUILD], ["[ID]", str(tree.get("id"))])).anchor(50, 50).pos(435, 255);
        var sca = getSca(pic, [170, 220]);
        pic.scale(sca);

        bg.addlabel(w, null, 19, FONT_BOLD).anchor(50, 50).pos(267, 80).color(0, 0, 0);

        var liveNum = global.user.getValue("liveNum");

        if(level >= len(loveTreeHeart))
        {
            w = getStr("heartReward0", ["[N0]", str(liveNum), "[N1]", str(liveNum)]);
        }
        else
        {
            var leftNum = loveTreeHeart[level]-global.user.getValue("accNum");
            w = getStr("heartReward1", ["[N0]", str(liveNum), "[N1]", str(liveNum), "[N2]", str(leftNum)]);
        }

        bg.addlabel(w, null, 19, FONT_NORMAL, 302, 0, ALIGN_LEFT).pos(74, 124).color(28, 16, 4);

        bg.addsprite("close2.png").pos(513, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            
        var but0 = bg.addsprite("blueButton.png").anchor(50, 50).pos(123, 342).setevent(EVENT_TOUCH, onInvite);
        but0.addlabel(getStr("inviteFri", null), null, 26).anchor(50, 50).pos(65, 23);

        but0 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(280, 342).size(130, 47).setevent(EVENT_TOUCH, onRank);
        but0.addlabel(getStr("rank", null), null, 26).anchor(50, 50).pos(65, 23);

        global.httpController.addRequest("friendC/collectHeart", dict([["uid", global.user.uid]]), null, null);
        global.user.collectHeart();
    }
    function onInvite()
    {
    }
    function onRank()
    {
        global.director.popView();
        global.director.pushView(new HeartRankDialog(), 1, 0);
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
