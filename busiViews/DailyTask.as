class DailyTask extends MyNode
{
    function DailyTask()
    {
        initView();
    }

    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("systemCompetitionBack.png").anchor(0, 0).pos(70, 14).size(674, 437).color(100, 100, 100, 100);



        but0 = new NewButton("closeBut.png", [53, 53], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(701, 125);
        addChild(but0);

        bg.addlabel(getStr("dailyReward", null), "fonts/heiti.ttf", 18).anchor(50, 50).pos(410, 137).color(47, 26, 30);
        bg.addlabel(getStr("updateDaily", null), "fonts/heiti.ttf", 18).anchor(0, 50).pos(186, 118).color(30, 17, 5);
        temp = bg.addsprite("dayTaskTitle.png", ARGB_8888).anchor(0, 0).pos(314, 19).size(196, 74).color(100, 100, 100, 100);

        temp = bg.addsprite("dayTaskBack.png").anchor(0, 0).pos(92, 149).size(583, 288).color(100, 100, 100, 100);


        var iconPos = [
            [139, 193], [389, 292], [144, 379],
        ];
        var numPos = [
            [172, 228], [421, 326], [177, 414],
        ];
        var titlePos = [
            [198, 172], [448, 269], [208, 358],
        ];
        var conPos = [
            [199, 192], [449, 289], [209, 378],
        ];

        var dayTasks = global.taskModel.localDayTask.items();

        var finishCount = 0;
        for(var i = 0; i < len(dayTasks); i++)
        {
            var tid = dayTasks[i][0];
            var tData = getData(TASK, tid);
            var iconKey = tData["iconKey"];
            temp = bg.addsprite("day"+iconKey+"Task.png").anchor(50, 50).pos(iconPos[i]).color(100, 100, 100, 100);
            var ret = global.taskModel.checkDayFinish(tid);
            if(ret)
            {
                finishCount++;
                temp = bg.addsprite("hook.png").anchor(50, 50).pos(numPos[i]).color(100, 100, 100, 100);
                bg.addlabel(getStr("dayTitle", ["[TITLE]", tData["title"], "[NUM0]", str(tData["num"]), "[NUM1]", str(tData["num"])]), "fonts/heiti.ttf", 22).anchor(0, 50).pos(titlePos[i]).color(29, 16, 4);
            }
            else
            {
                temp = bg.addsprite("dayTask"+str(i+1)+".png").anchor(50, 50).pos(numPos[i]).size(26, 27).color(100, 100, 100, 100);
                bg.addlabel(getStr("dayTitle", ["[TITLE]", tData["title"], "[NUM0]", str(dayTasks[i][1]["number"]), "[NUM1]", str(tData["num"])]), "fonts/heiti.ttf", 22).anchor(0, 50).pos(titlePos[i]).color(29, 16, 4);
            }


            temp = bg.addlabel(tData["des"], "fonts/heiti.ttf", 15, FONT_NORMAL, 194, 0, ALIGN_LEFT).anchor(0, 0).pos(conPos[i]).color(0, 0, 0);
        }
        if(finishCount == 3)
        {
            but0 = new NewButton("blueButton.png", [139, 47], getStr("getReward", null), null, 17, FONT_NORMAL, [100, 100, 100], onGetReward, null);
            but0.bg.pos(604, 390);
            addChild(but0);
        }
    }
    var totalGain;
    var inConnect = 0;
    function onGetReward()
    {
        if(inConnect)
            return;
        inConnect = 1;
        var dayTasks = global.taskModel.localDayTask.keys();

        totalGain = dict();
        for(var i = 0; i < len(dayTasks); i++)
        {
            var gain = getGain(TASK, dayTasks[i]);
            totalGain = addDictValue(totalGain, gain);
        }
        global.httpController.addRequest("taskC/finishDayTask", dict([["uid", global.user.uid], ["gain", json_dumps(totalGain)]]), getRewardOver, null);
    }
    function getRewardOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            global.user.doAdd(totalGain);
            global.taskModel.finishDayTask();
            global.director.popView();

            var tg = totalGain.items();//key number
            //KIND ID NUMBER
            var rew = [];
            for(var i = 0; i < len(tg); i++)
            {
                rew.append([STR2KIND[tg[i][0]], 0, tg[i][1]]);
            }
            global.director.pushView(new DailyReward(rew), 1, 0);
        }
        inConnect = 0;
    }
    function closeDialog()
    {
        if(inConnect)
            return;
        global.director.popView();
    }
}
