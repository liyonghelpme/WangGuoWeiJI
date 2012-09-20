class SoldierMenu extends MyNode
{
    var soldier;
    function SoldierMenu(s, func1, func2)
    {
        soldier = s;
        bg = node();
        var banner = bg.addsprite("buildMenu1.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        init();
//        trace("soldier name", soldier.myName, soldier.data.get("name"));
        //banner.addlabel(, null, 18).pos(44, 30).anchor(0, 50).color(100, 100, 100, 100);

        banner.addsprite("dialogSolLev.png").pos(38, 30).anchor(0, 50);
banner.addlabel(str((soldier.level + 1) + 1), "fonts/heiti.ttf", 18).anchor(0, 50).pos(101, 30).color(100, 100, 100);
        banner.addsprite("dialogSolHealth.png").pos(161, 30).anchor(0, 50);
banner.addlabel((str(soldier.health) + "/") + str(soldier.healthBoundary), "fonts/heiti.ttf", 18).anchor(0, 50).pos(201, 30).color(100, 100, 100);
        banner.addsprite("dialogSolAtt.png").pos(298, 30).anchor(0, 50);
        var attack = soldier.physicAttack;
        if(soldier.magicAttack > 0)
            attack = soldier.magicAttack;
banner.addlabel(str(attack), "fonts/heiti.ttf", 18).anchor(0, 50).pos(332, 30).color(100, 100, 100);

        banner.addsprite("dialogSolDef.png").pos(405, 30).anchor(0, 50);
banner.addlabel(str(soldier.physicDefense), "fonts/heiti.ttf", 18).anchor(0, 50).pos(441, 30).color(100, 100, 100);

        banner.addsprite("dialogSolDetail.png").pos(725, 30).anchor(0, 50).setevent(EVENT_TOUCH, onDetail);


        var nameBanner = sprite("soldierMenu.png").pos(12, -33);
        banner.add(nameBanner, -1);

        var career = getCareerLev(soldier.id); 
        var totalName = getStr(CAREER_TIT[career], null)+soldier.data.get("name");
nameBanner.addlabel(getStr("solNameCareer", ["[NAME]", soldier.myName, "[CAREER]", totalName]), "fonts/heiti.ttf", 18).pos(18, 19).anchor(0, 50).color(38, 86, 93, 100);

        var tranLevel = getTransferLevel(soldier);
        var w;
        if(tranLevel > 0)
            w = getStr("transferLev", ["[LEVEL]", str(tranLevel)]);
        else
            w = getStr("noTransfer", null);
banner.addlabel(w, "fonts/heiti.ttf", 20, FONT_BOLD).pos(458, -30).color(0, 0, 0);

        var level = soldier.id%10;
        var initX = 313;
        var initY = 19;
        for(var i = 0; i < 4; i++)
        {
            var filter = WHITE;
            if(i > level)
                filter = GRAY;
            if(i < 3)
                nameBanner.addsprite("soldierLev0.png", filter).pos(initX, initY).anchor(50, 50);
            else
                nameBanner.addsprite("soldierLev1.png", filter).pos(initX, initY).anchor(50, 50);
            initX += 30;
        }
        
        var left = new ChildMenuLayer(0, func1, soldier, func2);
        var right = new ChildMenuLayer(1, func2, soldier, func1);
        addChildZ(left, -1);
        addChildZ(right, -1);
    }
    function onDetail()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new DetailDialog(soldier), 1, 0);
    }
}
