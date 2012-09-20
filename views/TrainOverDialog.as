class TrainOverDialog extends MyNode
{
    var ps = [[220, 131], [266, 138], [313, 131]];
    var sca = [[100, 100], [111, 111], [100, 100]];
    //rewards [KIND, id, number]
    //exp added
    //level up 
    //transfer

    //goods ---> [[kind, id, number], []]
    //exp ---> [name, name]
    //level --->[name name]
    //transfer ---> [name, name]
    var but0;
    var but1;
    var map;
    //胜利还是失败 得分 奖励

    function TrainOverDialog(m, sol)//reward, 
    {

        map = m;
        bg = sprite("dialogBreak.png").anchor(50, 0).pos(global.director.disSize[0]/2, 0);
        init();

        bg.addsprite("congratulations.png").pos(269, 51).anchor(50, 50);
        var bSize = bg.prepare().size();
        bg.pos(global.director.disSize[0]/2, -bSize[1]);
        bg.addaction(moveby(500, 0, bSize[1]));
        
        var l = bg.addnode().pos(116, 165);
        var offY = 32;
        for(var i = 0; i < len(sol); i++)
        {
            var name = sol[i].myName;
            var exp = sol[i].addExp;
            var level = sol[i].level;
            var transferLev = getTransferLevel(sol[i]);
            if(level >= transferLev && transferLev != -1)
l.addlabel(getStr("solTrainOver1", ["[NAME]", name, "[EXP]", str(exp), "[LEV]", str(level + 1)]), "fonts/heiti.ttf", 18).color(0, 0, 0).pos(0, offY * i);
            else
l.addlabel(getStr("solTrainOver0", ["[NAME]", name, "[EXP]", str(exp), "[LEV]", str(level + 1)]), "fonts/heiti.ttf", 18).color(0, 0, 0).pos(0, offY * i);
            
        }

        but0 = bg.addsprite("roleNameBut1.png").anchor(50, 50).pos(162, 399).size(209, 61).setevent(EVENT_TOUCH, onOk);
but0.addlabel(getStr("ok", null), "fonts/heiti.ttf", 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(387, 399).size(209, 61).setevent(EVENT_TOUCH, onShare);
but1.addlabel(getStr("share", null), "fonts/heiti.ttf", 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

    }

    var callback;
    function update(diff)
    {
        rollTime += diff; 
        if(rollTime >= 500)
        {
            global.timer.removeTimer(this);
            callback();        
        }
    }
    function closeDialog()
    {
        global.director.popScene();
    }
    function onOk()
    {
        rollUp(closeDialog);
    }
    function onShare()
    {
        rollUp(closeDialog);
    }
    var rollTime = 0;
    function rollUp(cb)
    {
        var bSize = bg.size();
        bg.addaction(moveby(500, 0, -bSize[1]));
        but0.setevent(EVENT_TOUCH, null);
        but1.setevent(EVENT_TOUCH, null);

        rollTime = 0;
        callback = cb;
        global.timer.addTimer(this);
    }
    //存储关卡信息 当前关卡等级信息从map中获取
}
