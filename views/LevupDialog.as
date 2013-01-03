class LevupDialog extends MyNode
{
    const POS = [[165, 186], [377, 186]]
    var cmd;
    function LevupDialog(c)
    {
        cmd = c;
        bg = sprite("dialogLoginBack.png");
        var dia = bg.addsprite("dialogLevup.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        var but0 = dia.addsprite("roleNameBut1.png").pos(78, 326).size(173, 53).setevent(EVENT_TOUCH, closeDialog);
        but0.addlabel(getStr("ok", null), "fonts/heiti.ttf", 25).pos(86, 27).anchor(50, 50).color(100, 100, 100);

        but0 = dia.addsprite("roleNameBut0.png").pos(291, 326).size(173, 53);
        but0.addlabel(getStr("share", null), "fonts/heiti.ttf", 25).pos(86, 27).anchor(50, 50).color(100, 100, 100);

        var OFFX = 212;
        var thing = getLevelupThing();
        for(var i = 0; i < 2 && i < len(thing); i++)
        {
            var kind = thing[i][0];
            var id = thing[i][1].get("id");
            var data = getData(kind, id);
            var picName = replaceStr(KindsPre[kind], ["[ID]", str(id)]);
            var pic = dia.addsprite(picName).pos(165+OFFX*i, 186).anchor(50, 50);//.size(109, 108);
            var sca = getSca(pic, [109, 108]);
            pic.scale(sca);

            dia.addlabel(data.get("name"), "fonts/heiti.ttf", 17).pos(165 + (OFFX * i), 250).anchor(50, 50).color(0, 0, 0);
        }


        dia.addlabel(str(global.user.getValue("level") + 1), "fonts/heiti.ttf", 35).pos(502, 60).anchor(50, 50).color(100, 100, 100);

        showCastleDialog();
    }
    function closeDialog()
    {
        closeCastleDialog();
        //掉落奖励 物品 

        var cp = cmd.get("castlePage");
        cp.fallGoods.getLevelUpFallGoods();
//        trace("fallThing", cp);

        var level = global.user.getValue("level");
        if(level == 4 || level == 6 || level == 10)
        {
            if(global.user.rated == 0)
            {
                cp.dialogController.addCmd(dict([["cmd", "rate"]])); 
            }
        }
        //global.director.popView();
    }

}
