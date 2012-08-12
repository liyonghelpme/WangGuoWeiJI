class ChallengeNeibor extends MyNode
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
    //var but0;
    var but1;
    var map;
    //胜利还是失败 得分 奖励
    //失败只有确认按钮
    //胜利确认奖励
    //得到的星星是一致的

    /*
    与挑战RANK 不同 不显示 得分
    */

    function ChallengeNeibor(win, star, crystal, score,  m, levelUpSol)//reward,
    {
        map = m;
        bg = sprite("dialogBreak.png").anchor(50, 0).pos(global.director.disSize[0]/2, 0);
        init();
        var bSize = bg.prepare().size();
        bg.pos(global.director.disSize[0]/2, -bSize[1]);
        bg.addaction(moveby(500, 0, bSize[1]));
        var i;

        if(win == 1)
        {
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

            but1 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(275, 399).size(209, 61).setevent(EVENT_TOUCH, onOk);
            but1.addlabel(getStr("ok", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);

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
            if(crystal > 0)
                bg.addlabel(getStr("rewardCry", ["[NUM]", str(crystal)]), null, 18).pos(83, 256).color(0, 0, 0);
        
        }
        //失败显示 丢失的得分
        else
        {
            bg.addsprite("dialogFail.png").anchor(50, 50).pos(271, 46);
            bg.addsprite("dialogBreakTip.png").pos(56, 111);
            bg.addlabel("Tip: It is better to fight with enough soldiers than fight with nothing!", null, 18, FONT_NORMAL, 300, 76, ALIGN_LEFT).pos(115, 170).color(0, 0, 0);
            if(score != 0)
            {
                bg.addlabel(getStr("lostScore", ["[NUM]", str(-score)]), null, 18).pos(115, 300).color(0, 0, 0);
            }

            but1 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(275, 399).size(209, 61).setevent(EVENT_TOUCH, onOk);
            but1.addlabel(getStr("ok", null), null, 25).pos(104, 30).anchor(50, 50).color(100, 100, 100);
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
        //but0.setevent(EVENT_TOUCH, null);
        but1.setevent(EVENT_TOUCH, null);

        rollTime = 0;
        callback = cb;
        global.timer.addTimer(this);
    }
    //存储关卡信息 当前关卡等级信息从map中获取
    /*
    最后一关没有continue
    */
    function onOk()
    {
        rollUp(closeDialog);
    }
}
