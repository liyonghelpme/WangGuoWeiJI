class NewTaskReward extends MyNode
{
    function NewTaskReward()
    {
        initView();
    }
    function initView()
    {
        var stageId = global.taskModel.getCurNewTid();
        var tData = getData(TASK, stageId);

        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;

        trace("newTaskFinStage", tData["newTaskPeriod"], tData, stageId);   
        bg.add(showFullBack());
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252).color(100, 100, 100, 100);
        temp = bg.addsprite("nonFullWhiteBack.png").anchor(0, 0).pos(184, 175).size(314, 182).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57).color(100, 100, 100, 100);
        bg.addlabel(getStr("newTaskRewardTit", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(423, 93).color(32, 33, 40);
        bg.addlabel(getStr("getGift", null), "fonts/heiti.ttf", 18).anchor(0, 50).pos(212, 208).color(28, 15, 4);
        bg.addlabel(getStr("newTaskFinStage"+str(tData["newTaskPeriod"]), null), "fonts/heiti.ttf", 20).anchor(50, 50).pos(414, 147).color(43, 25, 9);

        var curX = 214;
        var curY = 231;
        var offY = 25;
        var reward = getGain(TASK, stageId);
        reward = reward.items();
        for(var i = 0; i < len(reward); i++)
        {
            bg.addlabel(getStr("boxReward0", ["[NUM]", str(reward[i][1]), "[KIND]", getStr(reward[i][0], null)]), "fonts/heiti.ttf", 20).anchor(0, 0).pos(curX, curY).color(20, 52, 27);
            curY += offY;
        }


        bg.addlabel(getStr("shareWithFriend", null), "fonts/heiti.ttf", 18).anchor(0, 50).pos(211, 330).color(64, 15, 29);
        temp = bg.addsprite("dialogPrincess.png").anchor(0, 0).pos(527, 180).size(102, 165).color(100, 100, 100, 100);

        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("share", null), null, 27, FONT_NORMAL, [100, 100, 100], onShare, null);
        but0.bg.pos(299, 402);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 27, FONT_NORMAL, [100, 100, 100], onOk, null);
        but0.bg.pos(519, 402);
        addChild(but0);
        temp = bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302).color(100, 100, 100, 100);
        temp = bg.addsprite("rightBalloon.png").anchor(0, 0).pos(664, 43).size(120, 343).color(100, 100, 100, 100);
    }
    function onShare()
    {
        doShare(getStr("shareNewTask", ["[NAME]", global.user.name]), null, null, null, null);
        onOk();
    }
    function onOk()
    {
        global.director.popView();

        var tid = global.taskModel.getCurNewTid();
        var tData = getData(TASK, tid);
        global.taskModel.doNewTaskByKey(tData["key"], 1);
    }
}
