/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png
*/
class TrainDialog extends MyNode
{
    var curChoose = -1;

    const initX = 80;
    const offX = 120;
    const initY = 212;
    var words;
    var but1;
    var but0;
    var buyWord;
    function TrainDialog()
    {

        var curDifLevel = getCurEnableDif();
        var bigLevel = curDifLevel[0]; 
        var posMon = monsterAppear.get(bigLevel);
        var small = posMon[0];
        var mid = posMon[0];
        var dif = posMon[0];
        var tooDif = posMon[0];
        var i;
        for(i = 0; i < len(posMon); i++)
        {
            var kind = getData(SOLDIER, posMon[i]).get("category");
            if(kind == UNDERLING)
                small = posMon[i];
            if(kind == HEALTH_SOL)
                mid = posMon[i];
            if(kind == ATTACK_SOL)
                mid = posMon[i];
            if(kind == MAGIC_SOL)
                dif = posMon[i];
            if(kind == PHYSIC_SOL)
                dif = posMon[i];
            if(kind == ELITE || kind == BOSS)
                tooDif = posMon[i];
        }
        var solIds = [small, mid, dif, tooDif];

        bg = sprite("dialogDetail.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        bg.addlabel(getStr("trainSol", null), null, 30).anchor(50, 50).pos(264, 26).color(33, 34, 40);

        bg.addsprite("roleNameClose.png").pos(499, 9).setevent(EVENT_TOUCH, closeDialog);
        words = bg.addlabel(getStr("equipDrugFast", null), null, 18).pos(264, 122).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("doubleExp", null), null, 18).pos(264, 303).anchor(50, 50).color(100, 0, 0);

        var scroll = bg.addsprite("dialogScroll.png").anchor(50, 50).pos(264, 81);
        scroll.addlabel(getStr("trainSolFast", null), null, 22).pos(252, 32).anchor(50, 50).color(27, 15, 4);


        var difW = [getStr("easy", null), getStr("mid", null), getStr("difficult", null), getStr("abnormal", null)];
        for(i = 0; i < 4; i++)
        {
            var pan = bg.addsprite("chooseStone.png").pos(initX+offX*i, initY).anchor(50, 50).setevent(EVENT_TOUCH, setChoose, i);
            pan.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(solIds[i])])).pos(54, 82).anchor(50, 50);

            pan.addlabel(difW[i], null, 18).pos(57, 20).anchor(50, 50).color(31, 17, 5);

        }

        but0 = bg.addsprite("roleNameBut0.png").pos(147, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, onDouble);
        buyWord = but0.addlabel(getStr("doubleExpNow", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").pos(377, 347).anchor(50, 50).size(214, 65).setevent(EVENT_TOUCH, onTrain);
        but1.addlabel(getStr("generalExp", null), null, 35).pos(107, 32).anchor(50, 50).color(100, 100, 100);

        setChoose(null, null, 0, null, null, null);

    }
    var doubleYet = 0;
    function onDouble()
    {
        var gold = 10;
        var cost = dict([["gold", gold]]);
        var buyable = global.user.checkCost(cost); 
        if(buyable.get("ok") == 0)
        {
            buyable.pop("ok");
            var it = buyable.items()[0];
            global.director.curScene.addChild(new UpgradeBanner(getStr("lack", ["[NUM]", str(it[1]), "[NAME]", getStr(it[0], null)]), [100, 0, 0])); 
            return;
        }
        else
        {
            if(doubleYet == 0)
            {
                global.director.curScene.addChild(new UpgradeBanner(getStr("need10Gold", null), [100, 100, 100])); 
                doubleYet = 1;
                buyWord.text(getStr("ok", null));
            }
            else//花费金币训练
            {
                global.director.popView();
                global.user.doCost(cost);
                global.httpController.addRequest("soldierC/trainDouble", dict([["uid", global.user.uid], ["gold", gold]]), null, null);

                var curDifLevel = getCurEnableDif();
                global.director.pushScene(
                    new TrainScene(curDifLevel[0]-1, 0, 
                        null, CHALLENGE_TRAIN, 1, curChoose
                    )
                );
            }
        }
    }
    function onTrain()
    {
        global.director.popView();
        var curDifLevel = getCurEnableDif();
        global.director.pushScene(
            new TrainScene(curDifLevel[0]-1, 0, 
                null, CHALLENGE_TRAIN, 0, curChoose
            )
        );
        
    }
    //检测石头是否可用

    var greenPan = null;
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
        
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
