class NewTaskDialog2 extends MyNode
{
    function NewTaskDialog2()
    {
        initView();
    }
    function onGo()
    {
        global.msgCenter.sendMsg(DO_NEW_TASK, null);
        closeDialog();
    }

    function initStageOneView()
    {
        var tasks = global.taskModel.getDoNewTask();
        var but0;
        var line;
        var temp;
        var sca;
        
        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(550, 169).size(121, 197).color(100, 100, 100, 100);
        var tData = getData(TASK, tasks[1]);
        var ret = global.taskModel.checkNewTaskState(tasks[1]);

        temp = bg.addsprite("dayTaskPanel.png").anchor(0, 0).pos(123, 298).size(350, 107).color(100, 100, 100, 100);
        bg.addlabel(getStr("dayTitle", ["[TITLE]", tData["title"], "[NUM0]", str(global.taskModel.getNewTaskFinNum(tData["id"])), "[NUM1]", str(tData["num"])]), "fonts/heiti.ttf", 22).anchor(0, 50).pos(231, 321).color(29, 16, 4);

        temp = bg.addlabel(tData["des"], "fonts/heiti.ttf", 15, FONT_NORMAL, 234, 0, ALIGN_LEFT).anchor(0, 0).pos(230, 341).color(0, 0, 0);

        temp = bg.addsprite("day"+tData["iconKey"]+"Task.png").anchor(0, 0).pos(131, 312).size(77, 67).color(100, 100, 100, 100);

        if(ret == TASK_CAN_FINISH || ret == TASK_REWARD_YET)
            temp = bg.addsprite("hook.png").anchor(50, 50).pos(200, 378).color(100, 100, 100, 100);
        else 
            temp = bg.addsprite("dayTask2.png").anchor(50, 50).pos(200, 378).size(26, 27).color(100, 100, 100, 100);

            

        tData = getData(TASK, tasks[0]); 
        ret = global.taskModel.checkNewTaskState(tasks[0]);
        temp = bg.addsprite("dayTaskPanel.png").anchor(0, 0).pos(122, 173).size(350, 107).color(100, 100, 100, 100);
        bg.addlabel(getStr("dayTitle", ["[TITLE]", tData["title"], "[NUM0]", str(global.taskModel.getNewTaskFinNum(tData["id"])), "[NUM1]", str(tData["num"])]), "fonts/heiti.ttf", 22).anchor(0, 50).pos(229, 196).color(29, 16, 4);
        temp = bg.addlabel(tData["des"], "fonts/heiti.ttf", 15, FONT_NORMAL, 195, 0, ALIGN_LEFT).anchor(0, 0).pos(229, 216).color(0, 0, 0);
        temp = bg.addsprite("day"+tData["iconKey"]+"Task.png").anchor(0, 0).pos(130, 173).size(73, 93).color(100, 100, 100, 100);

        if(ret == TASK_CAN_FINISH || ret == TASK_REWARD_YET)
            temp = bg.addsprite("hook.png").anchor(50, 50).pos(200, 252).color(100, 100, 100, 100);
        else
            temp = bg.addsprite("dayTask1.png").anchor(50, 50).pos(200, 252).size(26, 27).color(100, 100, 100, 100);

    }
    function initStageTwoView()
    {
        var tasks = global.taskModel.getDoNewTask();
        var but0;
        var line;
        var temp;
        var sca;
        var tData;
        var ret;
        var i;

        var NUM_POS = [[174, 236], [452, 329], [166, 401]];
        var ICON_POS = [[139, 202], [419, 297], [134, 370]];
        var DES_POS = [[200, 200], [482, 292], [196, 364]];
        var TIT_POS = [[200, 180], [482, 272], [196, 344]];
        var PAN_POS = [[94, 157], [375, 249], [89, 321]];
        //阶段1布局
        for(i = 0; i < 3; i++)
        {
            tData = getData(TASK, tasks[i]);
            ret = global.taskModel.checkNewTaskState(tasks[i]);

            temp = bg.addsprite("dayTaskPanel.png").anchor(0, 0).pos(PAN_POS[i]).size(350, 107).color(100, 100, 100, 100);
            bg.addlabel(getStr("dayTitle", ["[TITLE]", tData["title"], "[NUM0]", str(global.taskModel.getNewTaskFinNum(tData["id"])), "[NUM1]", str(tData["num"])]), "fonts/heiti.ttf", 22).anchor(0, 50).pos(TIT_POS[i]).color(29, 16, 4);
            temp = bg.addlabel(tData["des"], "fonts/heiti.ttf", 15, FONT_NORMAL, 195, 0, ALIGN_LEFT).anchor(0, 0).pos(DES_POS[i]).color(0, 0, 0);
            temp = bg.addsprite("day"+tData["iconKey"]+"Task.png").anchor(50, 50).pos(ICON_POS[i]).size(66, 66).color(100, 100, 100, 100);

            if(ret == TASK_CAN_FINISH || ret == TASK_REWARD_YET)
                temp = bg.addsprite("hook.png").anchor(50, 50).pos(NUM_POS[i]).color(100, 100, 100, 100);
            else
                temp = bg.addsprite("dayTask"+str(i+1)+".png").anchor(50, 50).pos(NUM_POS[i]).size(26, 27).color(100, 100, 100, 100);
        }
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        var tData;
        var ret;
        var i;

        temp = bg.addsprite("systemCompetitionBack.png").anchor(0, 0).pos(70, 14).size(674, 437).color(100, 100, 100, 100);
        but0 = new NewButton("goButton.png", [135, 47], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onGo, null);
        but0.bg.pos(615, 407);
        addChild(but0);
        but0 = new NewButton("closeBut.png", [53, 53], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onGo, null);
        but0.bg.pos(701, 125);
        addChild(but0);
        bg.addlabel(getStr("finishNewTask", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(401, 137).color(47, 26, 30);
        bg.addlabel(getStr("newTaskReward", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(404, 118).color(30, 17, 5);
        temp = bg.addsprite("newTask"+str(global.taskModel.newTaskStage)+".png", ARGB_8888).anchor(50, 50).pos(413, 54).color(100, 100, 100, 100);

        if(global.taskModel.newTaskStage == 0)
            initStageOneView();
        else if(global.taskModel.newTaskStage == 1)
            initStageTwoView();
    }
    function closeDialog()
    {
        global.director.popView();

        var tid = global.taskModel.getCurNewTid();
        var tData = getData(TASK, tid);
        global.taskModel.doAllTaskByKey(tData["key"], 1);
    }
}
