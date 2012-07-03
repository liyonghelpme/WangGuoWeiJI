class BreakDialog extends MyNode
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

    function BreakDialog(win, star, reward,  m)//reward,
    {
        map = m;
        bg = sprite("dialogBreak.png").anchor(50, 0).pos(global.director.disSize[0]/2, 0);
        init();
        var bSize = bg.prepare().size();
        bg.pos(global.director.disSize[0]/2, -bSize[1]);
        bg.addaction(moveby(500, 0, bSize[1]));
        var i;

        var levelUpSol = map.getAllLevelUp();

        //生成随机的矿物奖励
        if(win == 1)
        {

            for(i = 0; i < len(reward); i++)
                global.user.changeHerb(reward[i], 1);

            bg.addsprite("dialogVic.png").anchor(50, 50).pos(271, 46);
            //noraml gray
            for(i = 0; i < star; i++)
            {
                bg.addsprite("dialogStar.png").pos(ps[i]).scale(sca[i]).anchor(50, 50);
            }
            for(; i < 3; i++)
            {
                bg.addsprite("dialogStar.png", GRAY).pos(ps[i]).scale(sca[i]).anchor(50, 50);
            }
            but0 = bg.addsprite("roleNameBut1.png").anchor(50, 50).pos(162, 399).size(209, 61).setevent(EVENT_TOUCH, onRestart);
            but0.addlabel(getStr("restart", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

            but1 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(387, 399).size(209, 61).setevent(EVENT_TOUCH, onContinue);
            but1.addlabel(getStr("continue", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

            //var goods = reward.get("goods");
            var offY = 32;

            var g1 = getData(HERB, reward[0]);
            var g2 = getData(HERB, reward[1]);

            bg.addlabel(getStr("breakReward", ["[GOOD1]", g1.get("name"), "[GOOD2]", g2.get("name")]), null, 18).pos(83, 180).color(0, 0, 0);

            var levelupStr = getStr("noLevelUp", null);
            if(len(levelUpSol) > 0)
            {
                levelupStr = getStr("levelupSol", null);
                for(i = 0; i < len(levelUpSol)-1; i++)
                {
                    levelupStr += levelUpSol[i].myName+",";
                }
                levelupStr += levelUpSol[i].myName;
            }

            bg.addlabel(levelupStr, null, 18).pos(83, 212).color(0, 0, 0);
            //bg.addlabel("升级:liyong, xiaoxu", null, 18).pos(83, 244).color(0, 0, 0);
            //bg.addlabel("可以转职:liyong, xiaoxu", null, 18).pos(83, 276).color(0, 0, 0);
        
        }
        else
        {
            bg.addsprite("dialogFail.png").anchor(50, 50).pos(271, 46);
            bg.addsprite("dialogBreakTip.png").pos(56, 111);
            bg.addlabel("Tip: It is better to fight with enough soldiers than fight with nothing!", null, 18, FONT_NORMAL, 300, 76, ALIGN_LEFT).pos(115, 170).color(0, 0, 0);

            but0 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(162, 399).size(209, 61).setevent(EVENT_TOUCH, onTryAgain);
            but0.addlabel(getStr("tryAgain", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

            but1 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(387, 399).size(209, 61).setevent(EVENT_TOUCH, onQuit);
            but1.addlabel(getStr("quit", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);
        }

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
    /*
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    */
    //不再尝试本关卡
    function closeDialog()
    {
        global.director.popScene();
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
    function tryAgain()
    {
        global.director.popScene();
        global.director.pushScene(
            new BattleScene( map.kind,  map.small,
            [[1, 0], [1, 10], [1, 20], [1, 30], [1, 40], [1, 50], [1, 60], [1, 70], [1, 80], [1, 90], [1, 100], [1, 110], [1, 120], [1, 130], [1, 140], [1, 150], [1, 160], [1, 170], [1, 180], [1, 190]]
            )
        );
    }
    //弹出关卡 压入新的关卡
    function onTryAgain()
    {
        rollUp(tryAgain);
    }
    function onQuit()
    {
        rollUp(closeDialog);
    }
    function onRestart()
    {
        rollUp(tryAgain);
    }
    /*
    最后一关没有continue
    */
    function onContinue()
    {
        rollUp(closeDialog);
    }
}
