/*
const TASK_COFF = 100000;
function getBuyTaskKindAndId(tid)
{
    return [tid/TASK_COFF, tid%TASK_COFF];
}
function getBuyTaskTid(kind, id)
{
    return kind*TASK_COFF+id;
}
*/
/*
/*
确保所有 修改 localCycleTask 的地方 都 自动存储到了本地数据库

login 循环任务 用户第一次登录的时候 因为没有初始化localCycleTask 因此不能完成之后 只有同步服务器数据之后 才可以进行
*/
class TaskModel
{
    var initYet = 0;
    var newUserTask = null;
    var localCycleTask = null;
    var localSolTask = null;
    function getFinishNum()
    {
        if(initYet)
        {
            var count = 0;
            var i;
            var ret;
            //新手任务 显示数量 则 不显示 循环任务 和 购买任务
            var newTask = getCurNewTask();
            for(i = 0; i < len(newTask); i++)
            {
                //ret = checkNewTaskFin(newTask[i]);
                ret = checkNewTaskState(newTask[i]);
                if(ret == TASK_CAN_FINISH)
                    count++;
            }
            if(len(newTask) > 0)
                return count;

            var key = localCycleTask.keys();
            for(i = 0; i < len(key); i++)
            {
                ret = checkCycleFinish(key[i]);
                if(ret)
                    count++;
            }
            key = localSolTask.keys();
            for(i = 0; i < len(key); i++)
            {
                ret = checkSolTaskFinish(key[i]);
                if(ret)
                    count++;
            }

            return count;//循环任务完成   
        }
        return 0;
    }
    //如果需要 通知 则由 经营页面 弹出 提醒 提醒之后才 出现 箭头
    var delayTime = 0;
    //const SLOW_TASK = 3000;
    function update(diff)
    {
        if(initYet == 0 && initCycleTask && initNewTask && initSolTask)
        {
            initYet = 1;
            global.msgCenter.sendMsg(UPDATE_TASK, null);
            trace("initTaskOver", len(localCycleTask), len(localSolTask), len(newUserTask));
        }
        //当前没有任务 显示 则 自动发现任务 执行
        if(initYet && !inCommand && newTaskStage < getParam("showFinish"))
        {
            delayTime += diff;
            if(delayTime >= getParam("slowTask"))
            {
                delayTime = 0;
                findAvailableNewTask();
            }
        }
    }

    function TaskModel()
    {
        global.msgCenter.registerCallback(INITDATA_OVER, this);
        global.msgCenter.registerCallback(DO_NEW_TASK, this);
        global.timer.addTimer(this);
    }

    /*
    已经完成的购买任务
    需要领取奖励的购买任务----》完成之后 显示在 任务对话框页面---》finishTask--->任务对话框更新显示
    */
    var newTaskStage = 0;
    //初始化 任务数据
    //当前新手任务完成状态-----> TASKID
    //任务状态存储在服务器段 task中
    //同时完成多个新手任务
    //完成一个阶段 才能进入下一个阶段
    //当前新手任务的阶段
    function receiveMsg(param)
    {
        var msid = param[0];
        if(msid == INITDATA_OVER)
        {
            //初始化新手任务 阶段 和 所有任务 完成状态 ---> 完成则更新阶段
            newTaskStage = global.user.getValue("newTaskStage");
            newUserTask = global.user.db.get("newUserTask");
            if(newUserTask == null)
            {
                newUserTask = dict();
                global.user.db.put("newUserTask", newUserTask);
            }
            trace("newUserTask len", len(newUserTask));
            checkAvailableNewUserTask();

            //初始化循环任务 和 一次性任务
            localCycleTask = global.user.db.get("localCycleTask");
            if(localCycleTask == null)
            {
                localCycleTask = dict();
                global.user.db.put("localCycleTask", localCycleTask);
            }
            checkAvailableCycleTask();

            localSolTask = global.user.db.get("localSolTask");
            if(localSolTask == null)
            {
                localSolTask = dict();
                global.user.db.put("localSolTask", localSolTask);
            }
            checkAvailableSolTask();
            
            //完成每日登录循环任务
            //第一次登录 没有初始化 localCycle 中的任务所以无法显示
            //显示 任务完成提示对话框 ----> 可以将需求发给 场景来处理
            var diff = checkFirstLogin();
            trace("loginTask", diff);
            //第一次登录初始化 每日任务
            if(diff >= 1)
            {
                doAllTaskByKey("login", 1);
                //getDayTaskFromServer();
            }
            else//同一天多次登录 不用初始化 每日任务
            {

            }
            trace("init all task", initCycleTask, initSolTask);
        }
        //获取当前阶段没有完成的新手任务
        else if(msid == DO_NEW_TASK)
        {
        }
    }
    function findAvailableNewTask()
    {
        var allNew = getCurNewTask();
        //trace("findAvailableNewTask", len(allNew));
        for(var i = 0; i < len(allNew); i++)
        {
            //未完成 且 新手任务 没有被领取
            var ret = checkNewTaskState(allNew[i]);
            //trace("alNew", allNew[i], ret);
            if(ret == TASK_DOING)
            {
                startNewTask(allNew[i]);
                break;
            }
        }
    }
    function realShowHintArrow(pic, bSize, cmd)
    {
        //trace("realshowHintArrow", pic, bSize, cmd, commandList, curCmd, inCommand);

        if(inCommand)
        {
            var find = -1;
            for(var i = 0; i < len(commandList); i++)
            {
                if(commandList[i]["msgId"] == cmd)
                {
                    find = i;
                    break;
                }
            }
            //未找到命令
            if(find == -1)
                return;
            //没有完成依赖的命令 所以不显示
            if(find > 0)
            {
                var depend = commandList[find-1]["msgId"];
                if(doCmdYet.get(depend) == null)
                    return;
            }

            var dir = commandList[find].get("arrDir", DOWN);
            //箭头的x y 偏移
            var offY = commandList[find].get("arrOffY", 0);
            var offX = commandList[find].get("arrOffX", 0);
            var sca = commandList[find].get("arrScale", 100);
            //激活某个进度的箭头 但是没有 退后的功能
            trace("state", inCommand, find, curCmd, dir);
            //查找的命令 大于当前 命令 则 移动当前命令 进入新的提示体系
            //查找命令 等于当前命令 
            //如果当前命令 已经最大 curCmd == len(commandList) 则清空 命令历史 重新开始
            //if(find == curCmd || curCmd == len(commandList))
            {
                doCmdYet.update(commandList[find]["msgId"], 1);
                curCmd = find+1;
                clearHintArrow();
                //确认当前存在该命令 显示该命令的 hintArrow
                if(dir == DOWN)
                {
                    hintArrow = pic.addsprite("taskArrow.png").pos(bSize[0]/2+offX, -5+offY).anchor(50, 100).scale(sca);
                    hintArrow.addaction(repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20)));
                }
                else if(dir == LEFT)
                {
                    hintArrow = pic.addsprite("taskArrow.png").pos(bSize[0]+5+offX, bSize[1]/2+offY).anchor(50, 100).rotate(90).scale(sca);
                    hintArrow.addaction(repeat(moveby(500, -20, 0), delaytime(300), moveby(500, 20, 0)));
                }
                else if(dir == RIGHT)
                {
                    hintArrow = pic.addsprite("taskArrow.png").pos(-5+offX, bSize[1]/2+offY).anchor(50, 100).rotate(-90).scale(sca);
                    hintArrow.addaction(repeat(moveby(500, -20, 0), delaytime(300), moveby(500, 20, 0)));
                }
                else if(dir == UP)
                {
                    hintArrow = pic.addsprite("taskArrow.png").pos(bSize[0]/2+offX, bSize[1]+5+offY).anchor(50, 100).rotate(180).scale(sca);
                    hintArrow.addaction(repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20)));
                }
                //其它情况不显示箭头
                //默认显示向上箭头
                
                //提示文字 招募士兵页面的文字 普通页面的 文字 接受 体 显示 hintArrow 检测上一个任务 结束了 但是 下一个任务还在当前页面的覆盖下面 需要 close之类的 操作来提示
                if(commandList[find].get("tip") != null)
                {
                    //global.director.curScene.addChildZ(new UpgradeBanner(getStr(commandList[find]["tip"], null), [100, 100, 100], null), MAX_BUILD_ZORD);
                    global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr(commandList[find]["tip"], null), [100, 100, 100], null));
                }

            }
        }
    }

    function showHintArrow(pic, bSize, cmd)
    {
        //trace("showHintArrow", pic, bSize, cmd, commandList, curCmd, inCommand);
        realShowHintArrow(pic, bSize, cmd);
    }
    function getCurNewTid()
    {
        return curNewTid;
    }

    var hintArrow = null;

    var commandList = [];
    var curCmd = 0;
    var inCommand = 0;
    var curNewTid = null;
    //记录完成了哪些 命令 命令存在前后依赖关系
    //只有完成 某些命令 才能 显示其它命令
    var doCmdYet = dict();
    function checkNewTaskCurCmd(cmd)
    {
        trace("checkNewTaskCurCmd", curCmd, commandList, cmd);
        if(curCmd < len(commandList) && commandList[curCmd]["msgId"] == cmd)
        {
            return 1;
        }
        return 0;
    }
    //执行 新手任务的 命令List
    function startNewTask(tid)
    {
        if(inCommand)
            return;
        trace("startNewTask", tid);
        inCommand = 1;
        curCmd = 0;
        curNewTid = tid;
        var tData = getData(TASK, tid);
        commandList = tData["commandList"];
        //脚本中静态写的commandList 是 数组格式 转化成字典格式
        if(len(commandList) > 0)
        {
            if(type(commandList[0]) == type([]))
            {
                for(var i = 0; i < len(commandList); i++)
                {
                    commandList[i] = dict(commandList[i]);
                }
            }
        }

        doCmdYet = dict();
        trace("taskCommandList", commandList);
        //检测 是否有经营页面的处理？
        //if(tData["stageTask"])
        //{
        //    global.msgCenter.sendMsg(SHOW_NEW_TASK_REWARD, null);
            //global.director.pushView(new NewTaskReward(), 1, 0);//getStageReward
        //}
        //else if(tData["tipTask"])
        //else
        realDoNewTask();
    }
    //检测任务类型 如果是 阶段奖励任务 则 立即显示
    function realDoNewTask()
    {
        trace("realDoNewTask", curCmd, commandList);
        //发送启动命令
        if(curCmd < len(commandList))
        {
            var tempCmd = curCmd;
            //先变化状态 以便其它模块取检测状态 来 响应 信号
            curCmd++;
            //先存储命令 以便其它模块来 确认 前趋 命令 执行结束
            doCmdYet.update(commandList[tempCmd]["msgId"], 1);
            global.msgCenter.sendMsg(commandList[tempCmd]["msgId"], null);
            //curCmd++;
        }
    }


    function doAllTaskByKey(k, num)
    {
        if(newTaskStage < getParam("showFinish"))
            doNewTaskByKey(k, num);
        else
        {
            doCycleTaskByKey(k, num);
        }
        trace("finishDoAllTask", k, num);
    }
    function doNewTaskByKey(k, num)
    {
        trace("doNewTaskByKey", k, num);

        var curNewTask = getCurNewTask();
        for(var i = 0; i < len(curNewTask); i++)
        {
            var taskData = getData(TASK, curNewTask[i]);
            if(taskData["key"] == k)
            {
                doNewTask(curNewTask[i], num);
                break;
            }
        }
    }
    function clearHintArrow()
    {
        if(hintArrow != null)
        {
            hintArrow.removefromparent();
            hintArrow = null;
        }
    }
    //完成一个新手任务 不会领取奖励 只有完成下一个才行
    function doNewTask(tid, num)
    {
        trace("doNewTask", tid, num);
        if(newUserTask.get(tid) != null)
        {
            var task = newUserTask[tid];
            task["number"] += num;
            //var ret = checkNewTaskFin(tid);
            var ret = checkNewTaskState(tid);

            var taskData = getData(TASK, tid);

            trace("newTask", task, ret, taskData["title"]);


            if(ret == TASK_CAN_FINISH && task.get("showYet") == null && taskData["showTaskFinish"])//显示任务结束
            {
                task["showYet"] = 1;
                trace("showFinish");
                global.director.curScene.addChildZ(new TaskFinish(taskData["title"]), MAX_BUILD_ZORD);
            }
            trace("taskData", taskData["stageTask"]);
           
            //完成阶段任务 更新任务阶段
            if(taskData["stageTask"])
            {
                newTaskStage++;
                global.httpController.addRequest("taskC/updateNewTaskStage", dict([["uid", global.user.uid], ["newTaskStage", newTaskStage]]), null, null);
                global.msgCenter.sendMsg(INIT_NEW_TASK_FIN, null);
            }
            global.httpController.addRequest("taskC/doCycleTask", dict([["uid", global.user.uid], ["tid", tid], ["num", num]]), null, null);
            //新手任务 自动 获取 奖励
            //新手任务 手动 获取 奖励 需要到 任务对话框中 点击获取
            trace("autoReward", taskData["autoReward"], ret);
            if(ret == TASK_CAN_FINISH && taskData["autoReward"] == 1)
            {
                trace("getReward", task["stage"]);
                getNewTaskReward(tid);
            }

            trace("clearHintArrow");
            clearHintArrow();  
            inCommand = 0;//完成一个 新手任务 显示下一个新手任务
            //发送更新任务状态消息
            trace("putNewUser", len(newUserTask), newUserTask[tid]);
            global.user.db.put("newUserTask", newUserTask);
            global.msgCenter.sendMsg(UPDATE_TASK, null);
        }
    }

    function finishNewTask(tid)
    {
        //var task = newUserTask[tid];
        //task["stage"]++;
        getNewTaskReward(tid);
        global.user.db.put("newUserTask", newUserTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }

    function getNewTaskReward(tid)
    {
        var reward = getGain(TASK, tid);
        var task = newUserTask[tid];
        task["stage"] += 1;//新手任务 stage用来标记 是否完成任务
        global.user.doAdd(reward);

        trace("getNewTaskReward", tid, newUserTask.get(tid), reward);
        global.httpController.addRequest("taskC/finishNewTask", dict([["uid", global.user.uid], ["tid", tid], ["gain", json_dumps(reward)]]), null, null);
        //global.user.db.put("newUserTask", newUserTask);
        //global.msgCenter.sendMsg(UPDATE_TASK, null);
    }


    function getNewTask(tid)
    {
        return newUserTask.get(tid);
    }
    function getCycleTask(tid)
    {
        return localCycleTask.get(tid);
    }
    //检测是否有没有完成的新手任务 状态 
    //新手任务 是线性的阶段性了 
    //检测当前新手任务阶段 
    //判定当前是否有新手任务
    /*
    检测是否需要 显示 新手任务提示对话框
    */
    function checkShowNewTask()
    {
        if(newTaskStage <= getParam("showNewTaskStage"))
        {
            var tasks = getCurNewTask();
            return len(tasks) > 0;
        }
        return 0;
    }
    //得到显示 用户需要完成的任务 不包括 第一次任务的提示 任务阶段结束的奖励
    function getDoNewTask()
    {
        var allTask = getAllDataList(TASK);
        var curNewTask = [];
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["kind"] == NEW_TASK && allTask[i]["newTaskPeriod"] == newTaskStage && allTask[i]["stageTask"] == 0 && allTask[i]["tipTask"] == 0)
            {
                curNewTask.append(allTask[i]["id"]);
            }
        }
        bubbleSort(curNewTask, cmpTaskId);//按照显示优先级 tid 排序
        return curNewTask;
    }
    function getCurNewTask()
    {
        var allTask = getAllDataList(TASK);
        var curNewTask = [];
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["kind"] == NEW_TASK && allTask[i]["newTaskPeriod"] == newTaskStage)
            {
                curNewTask.append(allTask[i]["id"]);
            }
        }
        bubbleSort(curNewTask, cmpTaskId);//按照显示优先级 tid 排序
        //trace("sort", curNewTask);
        return curNewTask;
    }
    //静态数据 num
    //动态数据 number
    function getNewTaskFinNum(tid)
    {
        return newUserTask.get(tid)["number"];
    }
    //任务三种状态 正在做 可以完成 已经完成
    function checkNewTaskState(tid)
    {
        var task = newUserTask[tid];
        var taskData = getData(TASK, tid);
        var needNum = taskData["num"];

        //新手任务 检测 查看stageNum 而不是stageArray
        trace("checkNewTaskState", tid);
        if(task["stage"] >= taskData["stageNum"])
            return TASK_REWARD_YET; 
        if(task["number"] >= needNum)
            return  TASK_CAN_FINISH;
        return TASK_DOING;
    }
    //静态数据 里面 采用 num描述
    //动态数据 采用 number 描述
    function checkNewTaskFin(tid)
    {
        var task = newUserTask[tid];
        var taskData = getData(TASK, tid);
        var needNum = taskData["num"];
        //trace("checkNewTaskFin", tid, needNum, task["number"]);
        //新手任务 只有1个阶段 因此 只能执行一次
        if(task["number"] >= needNum || task["stage"] < len(taskData["stageArray"]))
        {
            return 1;
        }
        return 0;
    }
    function checkAvailableSolTask()
    {
        var allTask = getAllDataList(TASK);
        var needSyn = [];
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["kind"] == SOL_TASK && localSolTask.get(allTask[i]["id"]) == null)
            {
                needSyn.append(allTask[i]["id"]);
            }
        }
        if(len(needSyn) > 0)
        {
            global.httpController.addRequest("taskC/synTask", dict([["uid", global.user.uid], ["needSyn", json_dumps(needSyn)]]), synSolTaskOver, null);
        }
        else
        {
            initSolTask = 1;
        }
    }
    /*
    士兵任务特点：
    外部依赖一个 列表 StoreSoldier 新增士兵？ 独立特征 需要不同---> key + 私有内容
    任务stage 描述任务进度 CycleTask
    购买完成任务 需要传入 购买士兵的id 
    */
    function getSolTask(tid)
    {
        return localSolTask[tid];        
    }
    function checkSolTaskFinish(tid)
    {
        var task = localSolTask[tid];
        var needNum = getData(TASK, tid)["num"];
        if(needNum != -1 && task["number"] >= needNum)
        {
            return 1;
        }
        return 0;
    }


    var initSolTask = 0;
    function synSolTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var ret = con["ret"];
            //tid, number, stage
            for(var i = 0; i < len(ret); i++)
            {
                localSolTask.update(ret[i][0], dict([["tid", ret[i][0]], ["number", ret[i][1]], ["stage", ret[i][2]]]));
            }
            global.user.db.put("localSolTask", localSolTask);
            initSolTask = 1;
        }
    }

    //检测可用的新手任务
    //新手任务阶段
    //当前用户的新手任务
    var initNewTask = 0;
    function checkAvailableNewUserTask()
    {
        var allTask = getAllDataList(TASK);
        var needSyn = [];
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["kind"] == NEW_TASK && newUserTask.get(allTask[i]["id"]) == null)
            {   
                needSyn.append(allTask[i]["id"]);
            }
        }
        trace("syn New Task", len(needSyn));
        if(len(needSyn) > 0)
        {
            global.httpController.addRequest("taskC/synTask", dict([["uid", global.user.uid], ["needSyn", json_dumps(needSyn)]]), synNewTaskOver, null);
        }
        //应该在初始化 新手任务完成的时候 命令 经营页面检测是否需要弹出对话框
        else
        {
            initNewTask = 1;
            global.msgCenter.sendMsg(INIT_NEW_TASK_FIN, null);
        }
    }
    function synNewTaskOver(rid, rcode, con, param)
    {
        trace("synNewTaskOver", len(con));
        if(rcode != 0)
        {
            con = json_loads(con);
            var ret = con["ret"];
            //tid, number, stage
            for(var i = 0; i < len(ret); i++)
            {
                newUserTask.update(ret[i][0], dict([["tid", ret[i][0]], ["number", ret[i][1]], ["stage", ret[i][2]]]));
            }
            global.user.db.put("newUserTask", newUserTask);
            initNewTask = 1;
            global.msgCenter.sendMsg(INIT_NEW_TASK_FIN, null);
        }
    }

    var initCycleTask = 0;
    //检测所有任务 中等级满足 且local中没有的 任务 则向服务器同步数据
    function checkAvailableCycleTask()
    {
        var allTask = getAllDataList(TASK);
        var needSyn = [];
        trace("synTask", len(allTask));
        for(var i = 0; i < len(allTask); i++)
        {
            if(allTask[i]["level"] <= global.user.getValue("level") && allTask[i]["kind"] == CYCLE_TASK && localCycleTask.get(allTask[i]["id"]) == null)
            {
                needSyn.append(allTask[i]["id"]);
            }
        }
        trace("synTask", len(needSyn));
        if(len(needSyn) > 0)
        {
            global.httpController.addRequest("taskC/synTask", dict([["uid", global.user.uid], ["needSyn", json_dumps(needSyn)] ]), synCycleTaskOver, null);
        }
        else
        {
            initCycleTask = 1; 
        }
    }
    function synCycleTaskOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var ret = con["ret"];
            //tid, number, stage
            for(var i = 0; i < len(ret); i++)
            {
                localCycleTask.update(ret[i][0], dict([["tid", ret[i][0]], ["number", ret[i][1]], ["stage", ret[i][2]]]));
            }
            global.user.db.put("localCycleTask", localCycleTask);
            initCycleTask = 1;
        }
    }
    //kind 0 一次 1 循环 2 每日
    //key 任务特征码
    //param 任务参数
    //buy kind ID
    //只要 key 就可以了
    //模仿循环任务
    function finishSolTask(tid)
    {
        var task = localSolTask[tid];
        task["number"] = 0;
        task["stage"] += 1;
        task.pop("showYet");
        global.user.db.put("localSolTask", localSolTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }
    function finishCycleTask(tid)
    {
        var task = localCycleTask.get(tid);
        task["number"] = 0;
        task["stage"] += 1;
        task.pop("showYet");
        global.user.db.put("localCycleTask", localCycleTask);
        global.msgCenter.sendMsg(UPDATE_TASK, null);
    }
    //通过任务key 来 完成任务
    //本地循环任务还没有初始化成功所以 不能处理 loginTask 的初始化
    function doCycleTaskByKey(k, num)
    {
        trace("doCycleTaskByKey", k, num, len(localCycleTask));

        var allPossible = localCycleTask.keys();
        for(var i = 0; i < len(allPossible); i++)
        {
            var taskData = getData(TASK, allPossible[i]);
            if(taskData["key"] == k)
            {
                doCycleTask(allPossible[i], num);
                break;
            }
        }
    }

    function doSolTaskByKey(key, sid, num)
    {
        var allPossible = localSolTask.keys();
        for(var i = 0; i < len(allPossible); i++)
        {
            var taskData = getData(TASK, allPossible[i]);
            if(taskData["key"] == key)
            {
                doSolTask(allPossible[i], sid, num);
                break;
            }
        }
    }
    function doSolTask(tid, sid, num)
    {   
        if(localSolTask.get(tid) != null)
        {
            var task = localSolTask[tid];
            var stage = task["stage"];
            if(stage < len(storeSoldier))
            {
                //当前需要购买的士兵 ID 和 完成的任务相同
                if(storeSoldier[stage] == sid)
                {
                    task["number"] += num;
                    var ret = checkSolTaskFinish(tid);
                    var taskData = getData(TASK, tid);
                    if(ret && task["showYet"] == null && taskData["showTaskFinish"])
                    {
                        task["showYet"] = 1;
                        global.director.curScene.addChild(new TaskFinish(replaceStr(taskData["title"], ["[NUM]", str(getCycleStageNum(tid, task["stage"])) ])), MAX_BUILD_ZORD);
                    }
                    global.user.db.put("localSolTask", localSolTask);
                    global.msgCenter.sendMsg(UPDATE_TASK, null);
                    //使用循环任务的接口
                    global.httpController.addRequest("taskC/doCycleTask", dict([["uid", global.user.uid], ["tid", tid], ["num", num]]), null, null);
                }
            }
        }
    }
    /*
    每天第一次登录 初始化完任务模块 在进行登录任务完成判定
    showYet 控制是否显示 任务完成的奖励 模块
    */
    function doCycleTask(tid, num)
    {
        trace("doCycleTask", tid, num);
        if(localCycleTask.get(tid) != null)
        {
            var task = localCycleTask[tid];
            var taskData = getData(TASK, tid);
            //升级任务 需要直接比较数值而不是累加数值
            if(taskData["compareData"])
                task["number"] = num;
            else
                task["number"] += num;
            var ret = checkCycleFinish(tid);
            trace("cycleTask", task, ret);

            if(ret && task.get("showYet") == null && taskData["showTaskFinish"])
            {
                task["showYet"] = 1;

                global.director.curScene.addChild(new TaskFinish(replaceStr(taskData["title"], ["[NUM]", str(getCycleStageNum(tid, task["stage"])) ])), MAX_BUILD_ZORD);
            }

            global.user.db.put("localCycleTask", localCycleTask);
            global.msgCenter.sendMsg(UPDATE_TASK, null);
            global.httpController.addRequest("taskC/doCycleTask", dict([["uid", global.user.uid], ["tid", tid], ["num", num]]), null, null);
        }
    }
    function checkCycleState(tid)
    {
        var task = localCycleTask[tid];
        var needNum = getCycleStageNum(tid, task["stage"]);
        if(needNum == -1)
            return TASK_REWARD_YET;
        if(task["number"] >= needNum)
            return TASK_CAN_FINISH;
        return TASK_DOING;
    }
    function checkCycleFinish(tid)
    {
        var task = localCycleTask[tid];
        var needNum = getCycleStageNum(tid, task["stage"]);
        if(needNum != -1 && task["number"] >= needNum)
        {
            return 1;
        }
        return 0;
    }
    //多个任务可能有 相同的key 这样可以一起做
    //暂时没有实现
    //显示新手任务3个图标 打分
    function checkShowThreeIcon()
    {
        if(newTaskStage >= getParam("showStart") && newTaskStage < getParam("showFinish"))
            return 1;
        return 0;
    }
    //显示新手礼包
    function checkShowNewTaskGift()
    {
        return newTaskStage < getParam("showStart");
    }
    //新手阶段任务完成
    function checkNewTaskFinish()
    {
        return newTaskStage >= getParam("showFinish");
    }
}
