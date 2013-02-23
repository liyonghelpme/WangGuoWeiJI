class LoadChallenge extends MyNode
{
    var kind;
    var scene;
    function LoadChallenge(k, s)
    {
        kind = k;
        scene = s;
        initView();
    }
    var tipStr;
    var backMap = dict([
        [CHALLENGE_MON, "loadRound.jpg"],
        [CHALLENGE_FRI, "loadChallenge.jpg"],
        [CHALLENGE_NEIBOR, "loadChallenge.jpg"],
        [CHALLENGE_TRAIN, "loadTrain.png"],
        [CHALLENGE_FIGHT, "loadChallenge.jpg"],
        [CHALLENGE_DEFENSE, "loadChallenge.jpg"],
        [CHALLENGE_OTHER, "loadChallenge.jpg"],
        [CHALLENGE_REVENGE, "loadChallenge.jpg"],
    ]);
    var tipBack;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite(backMap[kind]).anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("loadTip.png").anchor(50, 50).pos(534, 439).size(481, 55).color(100, 100, 100, 100);
        tipBack = temp;

        var tid = global.user.getLoadTip();
        tipStr = bg.addlabel(getStr("tip"+str(tid), null), "fonts/heiti.ttf", 21, FONT_NORMAL, 440, 0,  ALIGN_CENTER).anchor(50, 50).pos(534, 439).color(100, 100, 100);
        temp = bg.addsprite("loadingCircle.png").anchor(50, 50).pos(763, 37).size(50, 57).color(100, 100, 100, 100).addaction(repeat(rotateby(2000, 360)));
        temp = bg.addsprite("loadingWord.png").anchor(0, 0).pos(607, 23).size(129, 29).color(100, 100, 100, 100);
        
        adjustWord();
    }
    function adjustWord()
    {
        var tipSize = tipStr.prepare().size();
        var backHeight = max(getParam("tipPadY")*2+tipSize[1], getParam("tipMinY"));
        var oldSize = tipBack.size();
        tipBack.size(oldSize[0], backHeight);
    }
    var showYet = 0;
    var passTime = 0;
    var initDataYet = 0;
    function update(diff)
    {
        if(initDataYet == 0)
        {
            initDataYet = 1;
            scene.initData();
        }
        passTime += diff;
        if(passTime >= 3000)
        {
            passTime = 0;
            var tid = global.user.getLoadTip();
            tipStr.text(getStr("tip"+str(tid), null));
            showYet = 1;
            adjustWord();
        }
        if(showYet && scene.initOver)
        {
            global.director.popView();
            scene.loadingCallback(); 
        }
    }
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
    function closeDialog()
    {
        global.director.popView();
    }
}
