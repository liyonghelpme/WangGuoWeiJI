/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class MakeArenaDialog extends MyNode
{
    var scene;
    var curChoose = -1;

    const initX = 80;
    const offX = 120;
    const initY = 212;
    var words;
    var but1;
    var but0;
    function MakeArenaDialog(s)
    {
        scene = s;

        bg = sprite("dialogDetail.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        bg.addlabel(getStr("makeArena", null), null, 30).anchor(50, 50).pos(264, 26).color(33, 34, 40);

        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        words = bg.addlabel(getStr("arenaReward", null), null, 18).pos(264, 122).anchor(50, 50).color(0, 0, 0);

        bg.addlabel(getStr("arenaTip", null), null, 18).pos(264, 303).anchor(50, 50).color(100, 0, 0);

        var scroll = bg.addsprite("dialogScroll.png").anchor(50, 50).pos(264, 81);
        scroll.addlabel(getStr("arenaHigh", null), null, 22).pos(252, 32).anchor(50, 50).color(27, 15, 4);


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


        but0 = bg.addsprite("roleNameBut0.png").pos(147, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, onOk);
        but0.addlabel(getStr("ok", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").pos(377, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, closeDialog);
        but1.addlabel(getStr("cancel", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

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
        cost = multiScalar(cost, fData.get("defenseReward"))
        var key = cost.keys()[0];
        var val = cost.values()[0];

        words.text(getStr("arenaReward", 
                        ["[NAME]", getStr("arena"+str(curChoose), null), 
                         "[NUM]", str(val), 
                        "[KIND]", getStr(key, null),
                        "[N1]", str(PARAMS.get("maxFailNum"))]));
        
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            but0.setevent(EVENT_TOUCH, null);
            but0.texture("roleNameBut0.png", GRAY);
        }
        else
        {
            but0.setevent(EVENT_TOUCH, onOk);
            but0.texture("roleNameBut0.png");
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function onOk()
    {
        global.director.popView();
        var cost = getCost(FIGHT_COST, curChoose);
        
        global.httpController.addRequest("fightC/makeFighting", dict([["uid", global.user.uid], ["kind", curChoose], ["crystal", cost.get("crystal", 0)], ["gold", cost.get("gold", 0)]]), null, null);
        global.user.doCost(cost);
        scene.makeArena(curChoose);//建立擂台
    }

}
