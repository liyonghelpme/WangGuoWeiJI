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
var num = bg.addlabel(str(it[i][1]), "fonts/heiti.ttf", 25).pos(initX + 30, initY).anchor(0, 50);
//            trace("label size", num.prepare().size());
            initX += 112;
        }
        bg.addaction(sequence(delaytime(1000), callfunc(removeSelf)));
    }
}
//taskId finishNum
//taskId data
class TaskDialog extends MyNode
{
    const EXP_HEI = 28;
    const EXP_TOT_WIDTH = 130;
    var cl;
    var flowNode;
    var upNode;



    //exp, title, des, do, need, silver, crystal, gold
    /*
    任务id 任务完成数目
    从global user 数据中心
    一个测试任务 收集大量的掉落物品 30个 任务0
    */
    var tasks;
    //= [[0, 27], [1, 21], [2, 28], [3, 30], [4, 21], [5, 29], [6, 26], [7, 22], [8, 27], [9, 21], [10, 20], [11, 20], [12, 24], [13, 23], [14, 22], [15, 30], [16, 26], [17, 22], [18, 30], [19, 22]];

    /*
    当前用户等级 可以得到所有任务 ALLTASK lev < userLevel - 
        用户已经完成的任务 ---》 任务的需求数目已经满足---》并且已经领取了奖励

        用户私有任务数据： 任务id 完成数目 领取奖励是否
    */
    function onDayTask()
    {
        if(len(global.taskModel.localDayTask) > 0)
            global.director.pushView(new DailyTask(), 1, 0);
    }
    function onTaskTip()
    {
    }
    var expNode = null;
    const EXP_BASE_WIDTH = 173;
    const EXP_MOVE_WIDTH = 185;
    function updateExpBar()
    {
        var but0;
        var line;
        var temp;
        var sca;
        var levelObj;
        var sData;

        if(expNode != null)
            expNode.removefromparent();
        expNode = bg.addnode();

        var level = global.user.getValue("level");
        var exp = global.user.getValue("exp");
        var needExp = getLevelUpNeedExp(level);
        

        temp = expNode.addsprite("taskExpBack.png").anchor(0, 0).pos(118, 137).size(583, 34).color(100, 100, 100, 100);

        var taskExpBar = expNode.addsprite("taskExpBar.png").anchor(0, 0).pos(120, 140).size(578, 28).color(100, 100, 100, 100);
        taskExpBar.size(EXP_BASE_WIDTH+exp*EXP_MOVE_WIDTH/needExp, 28);


        temp = expNode.addsprite("taskSolBack.png").anchor(0, 0).pos(636, 118).size(70, 67).color(100, 100, 100, 100);
        levelObj = getLevelSoldier(level+2);
        if(levelObj != null)
        {
            sData = getData(SOLDIER, levelObj);
            temp = expNode.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(levelObj)]), BLACK ).anchor(50, 50).pos(669, 152).color(100, 100, 100, 100);
            sca = getSca(temp, [51, 56]);
            temp.scale(sca);
            temp = expNode.addlabel(sData["name"], "fonts/heiti.ttf", 20).anchor(50, 50).pos(674, 101).color(0, 0, 0);
            temp = expNode.addsprite("taskLevelBack.png").anchor(0, 0).pos(669, 163).size(38, 21).color(100, 100, 100, 100);
            temp = expNode.addlabel(str(level+2+1), "fonts/heiti.ttf", 35).anchor(50, 50).pos(688, 174).color(76, 97, 34);
        }
        var thirdExp = getLevelUpNeedExp(level+1);
        temp = expNode.addlabel(getStr("needExp", ["[EXP]", str(thirdExp)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(675, 198).color(0, 0, 0);
        temp = expNode.addsprite("taskDialogLock.png").anchor(0, 0).pos(638, 163).size(19, 21).color(100, 100, 100, 100);


        temp = expNode.addsprite("taskSolBack.png").anchor(0, 0).pos(440, 118).size(70, 67).color(100, 100, 100, 100);
        levelObj = getLevelSoldier(level+1);
        if(levelObj != null)
        {
            sData = getData(SOLDIER, levelObj);
            temp = expNode.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(levelObj)]), BLACK).anchor(50, 50).pos(473, 152).color(100, 100, 100, 100);
            sca = getSca(temp, [51, 56]);
            temp.scale(sca);
            temp = expNode.addlabel(sData["name"], "fonts/heiti.ttf", 20).anchor(50, 50).pos(474, 100).color(0, 0, 0);
            temp = expNode.addsprite("taskLevelBack.png").anchor(0, 0).pos(473, 163).size(38, 21).color(100, 100, 100, 100);
            temp = expNode.addlabel(str(level+1+1), "fonts/heiti.ttf", 35).anchor(50, 50).pos(492, 174).color(76, 97, 34);
        }
        var nextExp = expNode.addlabel(getStr("needExp", ["[EXP]", str(needExp)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(479, 198).color(0, 0, 0);
        temp = expNode.addsprite("taskDialogLock.png").anchor(0, 0).pos(442, 163).size(19, 21).color(100, 100, 100, 100);


        temp = expNode.addsprite("taskSolBack.png").anchor(50, 50).pos(288, 151).size(70, 67).color(100, 100, 100, 100);
        levelObj = getLevelSoldier(level);
        if(levelObj != null)
        {
            sData = getData(SOLDIER, levelObj);
            temp = expNode.addsprite(replaceStr(KindsPre[SOLDIER], ["[ID]", str(levelObj)])).anchor(50, 50).pos(288, 152).color(100, 100, 100, 100);
            sca = getSca(temp, [52, 57]);
            temp.scale(sca);
            temp = expNode.addlabel(sData["name"], "fonts/heiti.ttf", 20).anchor(50, 50).pos(287, 100).color(0, 0, 0);
        }

        temp = expNode.addsprite("taskLevel.png").anchor(0, 0).pos(80, 110).size(75, 75).color(100, 100, 100, 100);
        expNode.addlabel(str(level+1), "fonts/heiti.ttf", 35).anchor(50, 50).pos(118, 152).color(76, 97, 34);
        expNode.addlabel(getStr("levelStr", null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(116, 102).color(0, 0, 0);
        expNode.addlabel(getStr("needExp", ["[EXP]", str(exp)]), "fonts/heiti.ttf", 20).anchor(0, 50).pos(99, 196).color(0, 0, 0);
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);
        temp = bg.addsprite("taskTitle.png").anchor(50, 50).pos(157, 43).size(177, 73).color(100, 100, 100, 100);
        updateExpBar();

    }
    /*
    循环任务是否完成 

    最上面所有完成的任务
    接着按照显示优先级 和 任务 id 排序
    */

    function initData()
    {
        tasks = [];
        if(global.taskModel.initYet)
        {
            var finishTask = [];
            var unFinishTask = [];
            var i;
            var tData;
            var taskD;
            var tid;
            var ret;

            //有新手任务则不显示 其他 任务 
            //不显示 新手阶段任务
            var newTask = global.taskModel.getDoNewTask();
            trace("newTask", newTask);
            for(i = 0; i < len(newTask); i++)
            {
                tData = global.taskModel.getNewTask(newTask[i]);
                taskD = getData(TASK, newTask[i]);
                //不显示阶段任务
                //if(taskD["stageTask"] == 0)
                //{
                //新手任务可以完成
                ret = global.taskModel.checkNewTaskState(newTask[i]);
                if(ret == TASK_CAN_FINISH)
                {
                    finishTask.append([NEW_TASK, newTask[i]]); 
                }
                //新手任务没有 获取过奖励
                else if(ret == TASK_DOING) 
                    unFinishTask.append([NEW_TASK, newTask[i]]);
                //}
            }
            //没有新手任务 则 显示下列任务
            if(len(newTask) == 0)
            {
                //添加完成的任务
                var cycleTask = global.taskModel.localCycleTask.keys();
                for(i = 0; i < len(cycleTask); i++)
                {
                    tData = global.taskModel.getCycleTask(cycleTask[i]);
                    taskD = getData(TASK, tData["tid"]);
                    //无限循环 或者 当前阶段 小于 总阶段数
                    if(taskD["stageNum"] == -1 || tData["stage"] < taskD["stageNum"])
                    {
                        tid = cycleTask[i];
                        if(global.taskModel.checkCycleFinish(tid))
                            finishTask.append([CYCLE_TASK, cycleTask[i]]);//显示根据数量 stage 决定是否完成 tid
                    }
                }

                var needFinishBuy = global.taskModel.needToFinishBuyTask;
                for(i = 0; i < len(needFinishBuy); i++)
                {
                    finishTask.append([ONCE_TASK, ["buy", needFinishBuy[i]]]);//显示购买任务 类型 key 参数
                }

                //添加未完成的任务

                for(i = 0; i < len(cycleTask); i++)
                {
                    tData = global.taskModel.getCycleTask(cycleTask[i]);
                    taskD = getData(TASK, tData["tid"]);
                    //无限循环 或者 当前阶段 小于 总阶段数
                    if(taskD["stageNum"] == -1 || tData["stage"] < taskD["stageNum"])
                    {
                        tid = cycleTask[i];
                        if(!global.taskModel.checkCycleFinish(tid))
                            unFinishTask.append([CYCLE_TASK, cycleTask[i]]);//显示根据数量 stage 决定是否完成 tid
                    }
                }
            }

            bubbleSort(unFinishTask, cmpTask);
            tasks = finishTask+unFinishTask;
        }
    }
    const INIT_X = 90;
    const INIT_Y = 214;
    const WIDTH = 620;
    const HEIGHT = 218;
    const PANEL_WIDTH = 592;
    const PANEL_HEIGHT = 69;
    const OFFY = 73;
    const ITEM_NUM = 1;
    const ROW_NUM = 3;
    function TaskDialog()
    {
        initView();
        bg.addsprite("taskWhiteBack.png").anchor(0, 0).pos(83, 206).size(634, 232).color(100, 100, 100, 100);
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
        global.taskModel.doNewTaskByKey("checkTask", 1);

        initData();
        updateTab();
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
            panel.addsprite("taskSeperator.png").anchor(0, 0).pos(14, 69).size(592, 4).color(100, 100, 100, 100);
            var t = tasks[i];
            var kind = t[0];
            var temp;
            var but0;
            var reward;

            var RINIT_X = 538;
            var RINIT_Y = 16;
            var R_OFFY = 36;
            var R_HEIGHT = 38;
            var R_TOT_HEIGHT = 68;
            var tid;
            var tData;//私有数据
            var taskData;//共有数据
            var stageNum;
            var num;
            var needNum;

            if(kind == ONCE_TASK)
            {
                var key = t[1][0];
                if(key == "buy")//购买类任务
                {
                    but0 = new NewButton("greenButton0.png", [91, 37], getStr("finishTask", null), null, 20, FONT_NORMAL, [100, 100, 100], onFinishTask, i);
                    but0.bg.pos(429, 34);
                    panel.add(but0.bg);
                    var goods = getGoodsKindAndId(t[1][1]);
                    var gData = getData(goods[0], goods[1]);

                    temp = panel.addsprite("hook.png").anchor(0, 0).pos(37, 11).size(33, 27).color(100, 100, 100, 100);
                    if(goods[0] == SOLDIER)
                    {
                        panel.addlabel(getStr("buySolTitle", ["[NAME]", gData["name"]]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(94, 17).color(0, 0, 0);
                        panel.addlabel(getStr("buySoldier", null), "fonts/heiti.ttf", 15).anchor(0, 50).pos(92, 51).color(56, 54, 53); 
                    }
                    else
                    {
                        panel.addlabel(getStr("buySth", ["[NAME]", gData["name"]]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(94, 17).color(0, 0, 0);
                        panel.addlabel(getStr("buyGoods", null), "fonts/heiti.ttf", 15).anchor(0, 50).pos(92, 51).color(56, 54, 53); 
                    }
                    reward = getGain(TASK, PARAMS["buyTaskId"]).items();
                }
            }
            /*
            print it out 看到才能测试 但是编译一次比较慢 最好 分批次进行测试
            view 测试 
            主逻辑测试
            其他测试
            */
            else if(kind == CYCLE_TASK)
            {
                tid = t[1];
                tData = global.taskModel.getCycleTask(tid);
                taskData = getData(TASK, tid);
                stageNum = getCycleStageNum(tid, tData["stage"]);
                num = tData["number"];
                //trace(taskData, getStr(taskData["des"], null));
                if(num >= stageNum)//任务可以完成
                {
                    but0 = new NewButton("greenButton0.png", [91, 37], getStr("finishTask", null), null, 20, FONT_NORMAL, [100, 100, 100], onFinishTask, i);
                    but0.bg.pos(429, 34);
                    panel.add(but0.bg);
                    temp = panel.addsprite("hook.png").anchor(0, 0).pos(37, 11).size(33, 27).color(100, 100, 100, 100);
                    panel.addlabel(getStr("taskNum", ["[NUM0]", str(stageNum), "[NUM1]", str(stageNum)]), "fonts/heiti.ttf", 15).anchor(50, 50).pos(54, 53).color(6, 69, 7);

                }
                else//任务没有完成
                {
                    temp = panel.addsprite("taskExpIcon.png").anchor(0, 0).pos(37, 11).size(33, 27).color(100, 100, 100, 100);
                    panel.addlabel(getStr("needExp", ["[EXP]", str(taskData["exp"])]), "fonts/heiti.ttf", 15).anchor(50, 50).pos(54, 53).color(6, 69, 7);
                    panel.addlabel(getStr("taskNum", ["[NUM0]", str(num), "[NUM1]", str(stageNum)]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(382, 22).color(96, 61, 21);

                }
                //登录显示的是累计的天数
                //其它循环任务显示的需求的数字
                if(taskData["key"] == "login")
                    panel.addlabel(replaceStr(taskData["title"], ["[NUM]", str(tData["stage"])]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(94, 17).color(0, 0, 0);
                else
                    panel.addlabel(replaceStr(taskData["title"], ["[NUM]", str(getCycleStageNum(tid, tData["stage"]))]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(94, 17).color(0, 0, 0);
                    
                panel.addlabel(taskData["des"], "fonts/heiti.ttf", 15).anchor(0, 50).pos(92, 51).color(56, 54, 53); 

                reward = getCycleReward(tid, tData["stage"]).items(); 
            }
            else if(kind == NEW_TASK)
            {
                tid = t[1];
                tData = global.taskModel.getNewTask(tid);
                taskData = getData(TASK, tid);
                needNum = taskData["num"];
                num = tData["number"];
                if(num >= needNum)
                {
                    but0 = new NewButton("greenButton0.png", [91, 37], getStr("finishTask", null), null, 20, FONT_NORMAL, [100, 100, 100], onFinishTask, i);
                    but0.bg.pos(429, 34);
                    panel.add(but0.bg);
                    temp = panel.addsprite("hook.png").anchor(0, 0).pos(37, 11).size(33, 27).color(100, 100, 100, 100);
                    panel.addlabel(getStr("taskNum", ["[NUM0]", str(needNum), "[NUM1]", str(needNum)]), "fonts/heiti.ttf", 15).anchor(50, 50).pos(54, 53).color(6, 69, 7);
                }
                else
                {
                    temp = panel.addsprite("taskExpIcon.png").anchor(0, 0).pos(37, 11).size(33, 27).color(100, 100, 100, 100);
                    panel.addlabel(getStr("needExp", ["[EXP]", str(taskData["exp"])]), "fonts/heiti.ttf", 15).anchor(50, 50).pos(54, 53).color(6, 69, 7);
                    panel.addlabel(getStr("taskNum", ["[NUM0]", str(num), "[NUM1]", str(needNum)]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(382, 22).color(96, 61, 21);
                }
                panel.addlabel(taskData["title"], "fonts/heiti.ttf", 23).anchor(0, 50).pos(94, 17).color(0, 0, 0);
                panel.addlabel(taskData["des"], "fonts/heiti.ttf", 15).anchor(0, 50).pos(92, 51).color(56, 54, 53); 
                reward = getGain(TASK, tid).items(); 
            }

            var height = R_OFFY*(len(reward)-1)+R_HEIGHT;
            var curY = R_TOT_HEIGHT/2-height/2+RINIT_Y;

            for(var r = 0; r < len(reward); r++)
            {
                temp = panel.addsprite(reward[r][0]+".png").anchor(50, 50).pos(RINIT_X, curY).size(38, 39).color(100, 100, 100, 100);
                panel.addlabel(str(reward[r][1]), "fonts/heiti.ttf", 23).anchor(0, 50).pos(RINIT_X+22, curY).color(96, 61, 21);
                curY += R_OFFY;
            }
        }
    }
    /*
    注意：客户端的http 请求存在bug 
    post 方法 dict 中嵌套的 dict 中的 字符串key 会被强制去掉字符串
    */
    function onFinishTask(curNum)
    {
        var reward;
        var tid;
        var tData;
        if(tasks[curNum][0] == ONCE_TASK)
        {
            if(tasks[curNum][1][0] == "buy")
            {
                reward = getGain(TASK, PARAMS["buyTaskId"]);
                global.httpController.addRequest("taskC/finishBuyTask", dict([["uid", global.user.uid], ["oid", tasks[curNum][1][1]], ["gain", json_dumps(reward)]]), null, null);
                global.user.doAdd(reward);
                global.taskModel.receiveBuyTaskReward(tasks[curNum][1][1]);

                initData();
                updateTab();
            }
        }
        else if(tasks[curNum][0] == CYCLE_TASK)
        {
            tid = tasks[curNum][1];
            tData = global.taskModel.getCycleTask(tid);
            reward = getCycleReward(tid, tData["stage"]); 
            global.httpController.addRequest("taskC/finishCycleTask", dict([["uid", global.user.uid], ["tid", tid], ["gain", json_dumps(reward)]]), null, null); 
            global.user.doAdd(reward);
            global.taskModel.finishCycleTask(tid);
            initData();
            updateTab();
        }//每日任务不再这里显示
        else if(tasks[curNum][0] == NEW_TASK)
        {
            tid = tasks[curNum][1];
            global.taskModel.finishNewTask(tid);
            initData();
            updateTab();//更新 任务显示数据
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_EXP, this);
    }

    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_EXP)
        {
            updateExpBar();
        }
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_EXP, this);
        super.exitScene();
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
}
