/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class MakeArenaDialog extends MyNode
{
    var scene;
    var curChoose = -1;

    const initX = 107;
    const offX = 132;
    const initY = 238;
    var words;
    var but1;
    var but0;
    function MakeArenaDialog(s)
    {
        scene = s;

        bg = sprite("dialogDetail.png").anchor(50, 50).size(614, 398).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        //bg.addlabel(getStr("makeArena", null), null, 30).anchor(50, 50).pos(264, 26).color(33, 34, 40);
        var tit = new ShadowWords(getStr("makeArena", null), null, 36, FONT_BOLD, [33, 33, 40]);
        tit.bg.pos(317, 31).anchor(50, 50);
        bg.add(tit.bg);

        var scroll = bg.addsprite("dialogScroll.png").anchor(50, 50).pos(317, 92);
        bg.addlabel(getStr("arenaHigh", null), null, 22).pos(317, 92).anchor(50, 50).color(27, 15, 4);

        words = bg.addlabel(getStr("arenaReward", null), null, 18).pos(317, 135).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("arenaTip", null), null, 18).pos(317, 335).anchor(50, 50).color(23, 54, 24);





        var i;
        for(i = 0; i < 4; i++)
        {
            var fData = getCost(FIGHT_COST, i).items();
            var key = fData[0][0];
            var val = fData[0][1];

            var pan = bg.addsprite("chooseStone.png", ARGB_8888).pos(initX+offX*i, initY).anchor(50, 50).setevent(EVENT_TOUCH, setChoose, i);
            pan.addsprite(key+"Big.png", ARGB_8888).pos(54, 82).anchor(50, 50);

            pan.addlabel(getStr("arena"+str(i), null), null, 18).pos(57, 20).anchor(50, 50).color(31, 17, 5);

            pan.addlabel(getStr("costNum", ["[KIND]", getStr(key, null), "[NUM]", str(val)]), null, 18).pos(57, 144).anchor(50, 50).color(0, 0, 0);
        }


        but0 = new NewButton("roleNameBut0.png", [205, 65], getStr("ok", null), null, 35, FONT_BOLD, [100, 100, 100], onOk, null);
        but0.bg.pos(171, 389).anchor(50, 50);
        bg.add(but0.bg);

        //but0 = bg.addsprite("roleNameBut0.png").pos(171, 389).anchor(50, 50).size(205, 65).setevent(EVENT_TOUCH, onOk);
        //but0.addlabel(getStr("ok", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        but1 = new NewButton("roleNameBut1.png", [205, 65], getStr("cancel", null), null, 35, FONT_BOLD, [100, 100, 100], closeDialog, null);
        but1.bg.pos(437, 389).anchor(50, 50);
        bg.add(but1.bg);

        //but1 = bg.addsprite("roleNameBut0.png").pos(437, 389).anchor(50, 50).size(205, 65).setevent(EVENT_TOUCH, closeDialog);
        //but1.addlabel(getStr("cancel", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        setChoose(null, null, 0, null, null, null);

    }

    //检测 资源是否足够 不足 按钮灰色
    var greenPan = null;

    //["arenaReward", "[NAME]每次守擂成功将会获得[NUM][KIND]奖励，有[N1]次守擂失败机会。"],
    function setChoose(n, e, p, x, y, points)
    {
        if(p >= 4)
            return;
        if(curChoose == p)
            return;
        if(greenPan != null)
        {
            greenPan.removefromparent();
            greenPan = null;
        }
        greenPan = bg.addsprite("stoneChoose.png").pos(initX+offX*p, initY).anchor(50, 50);
        curChoose = p;

        var fData = getData(FIGHT_COST, curChoose);
        var cost = getCost(FIGHT_COST, curChoose);

        var defReward = multiScalar(cost, fData.get("defenseReward"))
        var key = defReward.keys()[0];
        var val = defReward.values()[0];

        words.text(getStr("arenaReward", 
                        ["[NAME]", getStr("arena"+str(curChoose), null), 
                         "[NUM]", str(val), 
                        "[KIND]", getStr(key, null),
                        "[N1]", str(PARAMS.get("maxFailNum"))]));
        
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            //but0.setCallback(null);//setevent(EVENT_TOUCH, null);
            but0.bg.texture("roleNameBut0.png", GRAY);
        }
        else
        {
            //but0.setevent(EVENT_TOUCH, onOk);
            //but0.setCallback(onOk);
            but0.bg.texture("roleNameBut0.png");
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function onOk()
    {
        var cost = getCost(FIGHT_COST, curChoose);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            var key = cost.keys()[0];
            var val = cost.values()[0];
            global.director.curScene.addChild(new UpgradeBanner(getStr("fightNot", ["[NAME]", getStr(key, null)]), [100, 100, 100], null));
            return;
        }


        global.director.popView();

        //var cost = getCost(FIGHT_COST, curChoose);
        
        global.httpController.addRequest("fightC/makeFighting", dict([["uid", global.user.uid], ["kind", curChoose], ["crystal", cost.get("crystal", 0)], ["gold", cost.get("gold", 0)]]), null, null);
        global.user.doCost(cost);
        scene.makeArena(curChoose);//建立擂台
    }

}
