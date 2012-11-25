class SoldierMenu extends MyNode
{
    var left;
    var right;
    //传递模型给 childMenu 去处理
    const MODELS = dict([
         
    ]);
    var soldier;
    function SoldierMenu(s, func1, func2)
    {
        soldier = s;
        bg = node();
        var banner = bg.addsprite("buildMenu1.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        init();
        //banner.addlabel(getStr("level", null), "fonts/heiti.ttf", 19).pos(37, 33).anchor(0, 50);
        banner.addsprite("menuLevel.png").pos(37, 33).anchor(0, 50);

        banner.addlabel(str((soldier.level + 1) + 1), "fonts/heiti.ttf", 19).anchor(0, 50).pos(98, 33).color(100, 100, 100);
        banner.addsprite("dialogSolHealth.png").pos(172, 33).anchor(50, 50);
        banner.addlabel((str(soldier.health) + "/") + str(soldier.healthBoundary), "fonts/heiti.ttf", 18).anchor(0, 50).pos(197, 33).color(100, 100, 100);
        banner.addsprite("dialogSolAtt.png").pos(411, 33).anchor(50, 50);
        var attack = soldier.physicAttack;
        if(soldier.magicAttack > 0)
            attack = soldier.magicAttack;
            banner.addlabel(str(attack), "fonts/heiti.ttf", 19).anchor(0, 50).pos(428, 33).color(100, 100, 100);

        banner.addsprite("dialogSolDef.png").pos(305, 33).anchor(50, 50);
        banner.addlabel(str(soldier.physicDefense), "fonts/heiti.ttf", 19).anchor(0, 50).pos(327, 33).color(100, 100, 100);

        banner.addsprite("dialogSolDetail0.png").pos(754, 33).anchor(50, 50).setevent(EVENT_TOUCH, onDetail);


        var nameBanner = sprite("soldierMenu.png").pos(11, -29);
        banner.add(nameBanner, -1);

        
        var solOrMon = soldier.data["solOrMon"];
        if(solOrMon == 0)//普通士兵
        {
            var career = getCareerLev(soldier.id); 
            var totalName = getStr(CAREER_TIT[career], null)+soldier.data.get("name");
            nameBanner.addlabel(getStr("solNameCareer", ["[NAME]", soldier.myName, "[CAREER]", totalName]), "fonts/heiti.ttf", 18).pos(9, 15).anchor(0, 50).color(38, 86, 93, 100);

            var tranLevel = getTransferLevel(soldier);
            var w;
            if(tranLevel > 0)
            {
                w = getStr("transferLev", ["[LEVEL]", str(tranLevel)]);
                nameBanner.addlabel(w, "fonts/heiti.ttf", 20).anchor(0, 50).pos(442, 15).color(0, 0, 0);
            }
            //else
            //  w = getStr("noTransfer", null);


            var level = soldier.id%10;
            var initX = 300;
            var initY = 15;
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
        }
        else
        {
            nameBanner.addlabel(getStr("solNameCareer", ["[NAME]", soldier.myName, "[CAREER]", soldier.data["name"]]), "fonts/heiti.ttf", 18).pos(9, 15).anchor(0, 50).color(38, 86, 93, 100);
            
        }
        
        left = new ChildMenuLayer(0, func1, soldier, func2);
        right = new ChildMenuLayer(1, func2, soldier, func1);
        addChildZ(left, -1);
        addChildZ(right, -1);
    }
    override function removeSelf()
    {
        left.removeSelf();
        right.removeSelf();
        super.removeSelf();
    }
    function onDetail()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new DetailDialog(soldier), 1, 0);
    }
}
