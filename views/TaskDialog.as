class RewardBanner extends MyNode
{
    function RewardBanner(gain)
    {
        bg = sprite("storeBlack.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).size(307, 51).anchor(50, 50);
        init();
        var it = gain.items();
        var initX = 10;
        var initY = 25;
        for(var i = 0; i < len(it); i++)
        {
            var pic = bg.addsprite(it[i][0]+".png").pos(initX, initY).anchor(0, 50).size(30, 30);
            var num = bg.addlabel(str(it[i][1]), null, 25).pos(initX+30, initY).anchor(0, 50);
            trace("label size", num.prepare().size());
            initX += 112;
        }
        bg.addaction(sequence(delaytime(1000), callfunc(removeSelf)));
    }
}
//taskId finishNum
//taskId data
class TaskDialog extends MyNode
{
    const OFFX = 194;
    const INITX = 118;
    const INITY = 154;
    var moveExp;
    const EXP_HEI = 28;
    const EXP_TOT_WIDTH = 130;
    var cl;
    var flowNode;
    var upNode;

    const OFFY = 75;
    const ITEM_NUM = 1;
    const ROW_NUM = 3;
    const HEIGHT = OFFY*ROW_NUM;

    //exp, title, des, do, need, silver, crystal, gold
    /*
    任务id 任务完成数目
    从global user 数据中心
    一个测试任务 收集大量的掉落物品 30个 任务0
    */
    var tasks;
    //= [[0, 27], [1, 21], [2, 28], [3, 30], [4, 21], [5, 29], [6, 26], [7, 22], [8, 27], [9, 21], [10, 20], [11, 20], [12, 24], [13, 23], [14, 22], [15, 30], [16, 26], [17, 22], [18, 30], [19, 22]];

    /*
    function getTask(id)
    {
        var keys = ["exp", "title", "des", "do", "need", "silver", "crystal", "gold"];
        var t = tasks[id];
        var res = dict();
        for(var i = 0; i < len(keys); i++)
        {
            res.update(keys[i], t[i]);
        }
        return res;
    }
    */
    /*
    当前用户等级 可以得到所有任务 ALLTASK lev < userLevel - 
        用户已经完成的任务 ---》 任务的需求数目已经满足---》并且已经领取了奖励

        用户私有任务数据： 任务id 完成数目 领取奖励是否
    */
    function initData()
    {
        tasks = getCurLevelAllTask(global.user.getValue("level"));
    }
    function TaskDialog()
    {
        var level = global.user.getValue("level");
        initData();

        bg = sprite("dialogTask.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        bg.addsprite("dialogTaskExp.png").pos(120, 140).size(194, EXP_HEI);
        moveExp = bg.addsprite("dialogTaskExp.png").pos(120+194, 140);
        trace("init Exp bar");

        bg.addsprite("close2.png").anchor(50, 50).pos(764, 29).setevent(EVENT_TOUCH, closeDialog);


        var star = bg.addsprite("dialogTaskStar.png").anchor(50, 50).pos(INITX, 150);

        bg.addlabel(getStr("level", null), null, 18).pos(118, 102).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("needExp", ["[EXP]", str(getExp(level))]), null, 18).anchor(50, 50).pos(118, 195).color(0, 0, 0);

        bg.addlabel(str(level), null, 25).anchor(50, 50).pos(INITX, 154).color(76, 97, 34);
        trace("init star");


        //70 67
        var block = bg.addsprite("dialogTaskBlock.png").anchor(50, 50).pos(INITX+OFFX, 154);
        block.addsprite("soldier0.png").pos(35, 33).anchor(50, 50).size(60, 60);
        bg.addlabel("name", null, 18).pos(INITX+OFFX, 102).anchor(50, 50).color(0, 0, 0);


        block = bg.addsprite("dialogTaskBlock.png").anchor(50, 50).pos(INITX+OFFX*2, 154);
        block.addsprite("soldier1.png", BLACK).pos(35, 33).anchor(50, 50).size(60, 60);

        bg.addlabel("name", null, 18).pos(INITX+OFFX*2, 102).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("needExp", ["[EXP]", str(getExp(level+1))]), null, 18).anchor(50, 50).pos(INITX+OFFX*2, 195).color(0, 0, 0);

        block.addsprite("roleLock.png").pos(12, 56).anchor(50, 50).size(20, 21);
        block.addsprite("dialogTaskShadow.png").anchor(50, 50).pos(49, 56);
        block.addlabel(str(level+1), null, 15).anchor(50, 50).pos(49, 56).color(76, 97, 34);
        trace("init block 1");


        block = bg.addsprite("dialogTaskBlock.png").anchor(50, 50).pos(INITX+OFFX*3, 154);
        block.addsprite("soldier2.png", BLACK).pos(35, 33).anchor(50, 50).size(60, 60);

        bg.addlabel("name", null, 18).pos(INITX+OFFX*3, 102).anchor(50, 50).color(0, 0, 0);
        bg.addlabel(getStr("needExp", ["[EXP]", str(getExp(level+2))]), null, 18).anchor(50, 50).pos(INITX+OFFX*3, 195).color(0, 0, 0);

        block.addsprite("roleLock.png").pos(12, 56).anchor(50, 50).size(20, 21);
        block.addsprite("dialogTaskShadow.png").anchor(50, 50).pos(49, 56);
        block.addlabel(str(level+2), null, 15).anchor(50, 50).pos(49, 56).color(76, 97, 34);
        trace("init block 2");

        cl = bg.addnode().pos(85, 210).size(629, 226).clipping(1);
        flowNode = cl.addnode();
        updateTab();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function getRange()
    {
        var curPos = flowNode.pos(); 
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(tasks);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addnode().pos(0, OFFY*i);
            panel.addsprite("dialogTaskLine.png").pos(315, 75).anchor(50, 50);
            var t = tasks[i];
            var data = getData(TASK, t[0]);
            trace("init task Panel", data, t);
            var need = data.get("need");
            var fin = t[1];
            if(t[1] < need)
            {
                panel.addsprite("exp_star.png").pos(55, 30).anchor(50, 50).size(30, 30);
                panel.addlabel(getStr("needExp", ["[EXP]", str(data.get("exp"))]), null, 15).pos(55, 55).anchor(50, 50).color(13, 72, 14); 
                panel.addlabel(getStr("finTask", ["[DO]", str(t[1]), "[NEED]", str(data.get("need"))]), null, 20).color(96, 62, 22).pos(430, 20).anchor(50, 50);
            }
            else
            {
                panel.addsprite("dialogTaskFinish.png").pos(55, 30).anchor(50, 50).size(30, 30);
                panel.addlabel(getStr("finTask", ["[DO]", str(t[1]), "[NEED]", str(data.get("need"))]), null, 15).pos(55, 55).anchor(50, 50).color(13, 72, 14);
                panel.addsprite("greenButton.png").size(102, 39).pos(434, 45).anchor(50, 50).setevent(EVENT_TOUCH, finishTask, tasks[i][0]);
                panel.addlabel(getStr("finishTask", null), null, 25).pos(434, 45).anchor(50, 50).color(100, 100, 100);

            }
            panel.addlabel(data.get("title"), null, 25).pos(100, 21).anchor(0, 50).color(0, 0, 0);
            panel.addlabel(data.get("des"), null, 17, FONT_NORMAL, 259, 34, ALIGN_LEFT).pos(100, 39).color(56, 54, 54);
            var gain = getGain(TASK, t[0]);
            trace("init task gain", gain);
            var offY = 38;
            var it = gain.items();
            var initY = 19;
            if(len(gain) == 2)//silver crystal gold exp
            {
                initY = 38; 
            }
            for(var j = 0; j < len(it); j++)
            {
                if(it[j][0] != "exp")
                {
                    panel.addsprite(it[j][0]+".png").pos(541, initY).anchor(50, 50).size(30, 30);
                    panel.addlabel(str(it[j][1]), null, 20).pos(541+20, initY).anchor(0, 50).color(96, 62, 22);
                    initY += offY;
                }
            }

        }
    }
    override function enterScene()
    {
        super.enterScene();
        updateValue(global.user.resource);
        global.user.addListener(this);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
        super.exitScene();
    }

    function finishTask(n, e, p, x, y, points)
    {
        trace("finishTask", p);
        global.user.updateTask(p, 0, 1);
        global.director.pushView(new RewardBanner(getGain(TASK, p)), 0, 0);
        initData();
        updateTab();
    }
    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(tasks)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function updateValue(res)
    {
        moveExp.size(50, EXP_HEI);
    }
}
