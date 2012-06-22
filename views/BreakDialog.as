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
    function BreakDialog(win, star, reward)
    {
        bg = sprite("dialogBreak.png").anchor(50, 0).pos(global.director.disSize[0]/2, 0);
        init();
        var but0;
        if(win == 1)
        {
            bg.addsprite("dialogVic.png").anchor(50, 50).pos(271, 46);
            //noraml gray
            for(var i = 0; i < star; i++)
            {
                bg.addsprite("dialogStar.png").pos(ps[i]).scale(sca[i]).anchor(50, 50);
            }
            for(; i < 3; i++)
            {
                bg.addsprite("dialogStar.png", GRAY).pos(ps[i]).scale(sca[i]).anchor(50, 50);
            }
            but0 = bg.addsprite("roleNameBut1.png").pos(80, 379).size(165, 39).setevent(EVENT_TOUCH, onRestart);
            but0.addlabel(getStr("restart", null), null, 18).pos(82, 20).anchor(50, 50).color(100, 100, 100);

            but0 = bg.addsprite("roleNameBut0.png").pos(305, 379).size(165, 39).setevent(EVENT_TOUCH, onContinue);
            but0.addlabel(getStr("continue", null), null, 18).pos(82, 20).anchor(50, 50).color(100, 100, 100);

            var goods = reward.get("goods");
            var offY = 32;
            bg.addlabel("奖励:砖头, 石头", null, 18).pos(83, 180).color(0, 0, 0);
            bg.addlabel("经验增加:liyong, xiaoxu", null, 18).pos(83, 212).color(0, 0, 0);
            bg.addlabel("升级:liyong, xiaoxu", null, 18).pos(83, 244).color(0, 0, 0);
            bg.addlabel("可以转职:liyong, xiaoxu", null, 18).pos(83, 276).color(0, 0, 0);
        
        }
        else
        {
            bg.addsprite("dialogFail.png").anchor(50, 50).pos(271, 46);
            bg.addsprite("dialogBreakTip.png").pos(56, 111);
            bg.addlabel("Tip: It is better to fight with enough soldiers than fight with nothing!", null, 18, FONT_NORMAL, 300, 76, ALIGN_LEFT).pos(115, 170).color(0, 0, 0);

            but0 = bg.addsprite("roleNameBut0.png").pos(80, 379).size(165, 39).setevent(EVENT_TOUCH, onTryAgain);
            but0.addlabel(getStr("tryAgain", null), null, 18).pos(82, 20).anchor(50, 50).color(100, 100, 100);

            but0 = bg.addsprite("roleNameBut0.png").pos(305, 379).size(165, 39).setevent(EVENT_TOUCH, onQuit);
            but0.addlabel(getStr("quit", null), null, 18).pos(82, 20).anchor(50, 50).color(100, 100, 100);
        }

    }
    function onTryAgain()
    {
        global.director.popView();
    }
    function onQuit()
    {
        global.director.popView();
    }
    function onRestart()
    {
        global.director.popView();
    }
    function onContinue()
    {
        global.director.popView();
    }
}
