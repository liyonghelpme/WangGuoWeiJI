class SoldierMenu extends MyNode
{
    var left;
    var right;
    var soldier;
    var func1;
    var func2;
    function SoldierMenu(s, f1, f2)
    {
        soldier = s;
        func1 = f1;
        func2 = f2;
        initView();
    }
    var timeLabel = null;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("soldierMenu.png").anchor(0, 0).pos(11, 390).size(428, 37).color(100, 100, 100, 100);
        temp = bg.addsprite("buildMenu1.png").anchor(0, 0).pos(0, 419).size(800, 61).color(100, 100, 100, 100);

        bg.addlabel(str(soldier.healthBoundary), "fonts/heiti.ttf", 20).anchor(0, 50).pos(76, 454).color(100, 100, 100);
        bg.addlabel(str(soldier.attack), "fonts/heiti.ttf", 20).anchor(0, 50).pos(206, 453).color(100, 100, 100);
        temp = bg.addsprite("dialogSolHealth.png").anchor(0, 0).pos(35, 440).size(33, 27).color(100, 100, 100, 100);
        temp = bg.addsprite("dialogSolDef.png").anchor(0, 0).pos(170, 437).size(28, 31).color(100, 100, 100, 100);
        temp = bg.addsprite("dialogSolAtt.png").anchor(0, 0).pos(277, 438).size(26, 32).color(100, 100, 100, 100);
        bg.addlabel(str(soldier.defense), "fonts/heiti.ttf", 20).anchor(0, 50).pos(307, 453).color(100, 100, 100);
        trace("inTransfer", soldier.inTransfer);
        if(soldier.inTransfer)
            timeLabel = bg.addlabel(getStr("transferLeftTime", ["[TIME]", getWorkTime(soldier.getLeftTime())]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(466, 405).color(0, 0, 0);
        
        var solOrMon = soldier.data["solOrMon"];
        if(solOrMon == 0)
        {
            var career = getCareerLev(soldier.id); 
            var totalName = getStr(CAREER_TIT[career], null)+soldier.data.get("name");
            bg.addlabel(getStr("solNameCareer", ["[NAME]", soldier.myName, "[CAREER]", totalName]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(20, 405).color(38, 86, 92);

            var initX = 311;
            var initY = 393;
            for(var i = 0; i < 4; i++)
            {
                var filter = WHITE;
                if(i > career)
                    filter = GRAY;
                if(i < 3)
                    bg.addsprite("soldierLev0.png", filter).pos(initX, initY).anchor(0, 0);
                else
                    bg.addsprite("soldierLev1.png", filter).pos(initX, initY).anchor(0, 0);
                initX += 30;
            }
        }
        else
        {
            bg.addlabel(getStr("solNameCareer", ["[NAME]", soldier.myName, "[CAREER]", soldier.data["name"]]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(20, 405).color(38, 86, 92);
        }



        left = new ChildMenuLayer(0, func1, soldier, func2);
        right = new ChildMenuLayer(1, func2, soldier, func1);
        addChildZ(left, -1);
        addChildZ(right, -1);
    }
    function onDetail()
    {
        global.director.curScene.closeGlobalMenu(this);
        global.director.pushView(new DetailDialog(soldier), 1, 0);
    }
    var removed = 0;
    var passTime = 0;
    function update(diff)
    {
        if(removed)
        {
            if(passTime >= getParam("hideTime"))
                clearChildMenu();
            passTime += diff;
        }
        if(timeLabel != null)
            timeLabel.text(getStr("transferLeftTime", ["[TIME]", getWorkTime(soldier.getLeftTime())]));
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }


    //removeSelf----->exitScene--->update--->clearChildMenu 
    override function removeSelf()
    {
        left.removeSelf();
        right.removeSelf();
        exitScene();
    }

    function closeDialog()
    {
        global.director.popView();
    }

    function clearChildMenu()
    {
        trace("clearChildMenu");
        global.timer.removeTimer(this);
        bg.removefromparent();
        super.exitScene();
    }
    override function exitScene()
    {   
        //clearChildMenu();
        if(removed)
            return;
        //向下移动40
        bg.addaction(sequence(expin(moveby(getParam("hideTime"), 0, 40)), itintto(0, 0, 0, 0)));
        removed = 1;
        trace("childMenu exitScene");
    }
}
