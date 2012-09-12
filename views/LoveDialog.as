/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

>= 当前等级的 未购买的物品

show update 
*/
class LoveDialog extends MyNode
{
    var tree;
    //显示用户的爱心数据
    function LoveDialog(t)
    {
        tree = t;
        bg = sprite("dialogUpdate.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        var level = tree.id-LOVE_TREE_ID;
        var data = tree.data;
        var tit = getStr("loveTree", ["[LEV]", str(level+1), "[NAME]", data.get("name")]);
        bg.addlabel(tit, null, 25, FONT_BOLD).pos(267, 26).anchor(50, 50).color(33, 33, 40);

        var w = getStr("moreHeart", null);

        var pic = bg.addsprite(replaceStr(KindsPre[BUILD], ["[ID]", str(tree.id)])).anchor(50, 50).pos(435, 255);
        var sca = getSca(pic, [170, 220]);
        pic.scale(sca);

        bg.addlabel(w, null, 19, FONT_BOLD).anchor(50, 50).pos(267, 80).color(0, 0, 0);

        if(level >= len(loveTreeHeart))
        {
            w = stringLines(
                getStr("topHeartNum", ["[WEEKNUM]", str(global.user.getValue("weekNum")), "[ACCNUM]", str(global.user.getValue("accNum"))]), 
                19, 35, [28, 16, 4], FONT_NORMAL);
        }
        else
        {
            var leftNum = loveTreeHeart[level]-global.user.getValue("accNum");
            w = stringLines(
                getStr("heartNum", ["[WEEKNUM]", str(global.user.getValue("weekNum")), "[ACCNUM]", str(global.user.getValue("accNum")), "[LEV]", str(level+1+1), "[LEFTNUM]", str(leftNum)]),
                19, 35, [28, 16, 4], FONT_NORMAL);
            
        }
        w.pos(74, 124);
        bg.add(w);

        bg.addlabel(getStr("heartTip", null), null, 15, FONT_NORMAL, 302, 0, ALIGN_LEFT).pos(74, 124+w.size()[1]).color(50, 50, 50);

        bg.addsprite("close2.png").pos(513, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
            
        var but0 = bg.addsprite("blueButton.png").anchor(50, 50).pos(123, 342).setevent(EVENT_TOUCH, onInvite);
        but0.addlabel(getStr("inviteFri", null), null, 26).anchor(50, 50).pos(65, 23);

        but0 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(280, 342).size(130, 47).setevent(EVENT_TOUCH, onRank);
        but0.addlabel(getStr("rank", null), null, 26).anchor(50, 50).pos(65, 23);
    }
    function onInvite()
    {
    }
    function onRank()
    {
        global.director.popView();
        //global.director.pushView(new HeartRankDialog(), 1, 0);
        global.director.pushView(new RankDialog(HEART_RANK), 1, 0);
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
