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
        [CHALLENGE_MON, "loadRound.png"],
        [CHALLENGE_FRI, "loadChallenge.png"],
        [CHALLENGE_NEIBOR, "loadChallenge.png"],
        [CHALLENGE_TRAIN, "loadTrain.png"],
        [CHALLENGE_FIGHT, "loadChallenge.png"],
        [CHALLENGE_DEFENSE, "loadChallenge.png"],
        [CHALLENGE_OTHER, "loadChallenge.png"],
        [CHALLENGE_REVENGE, "loadChallenge.png"],
    ]);
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite(backMap[kind]).anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("loadTip.png").anchor(0, 0).pos(288, 412).size(481, 55).color(100, 100, 100, 100);
        var tid = global.user.getLoadTip();
        tipStr = bg.addlabel(getStr("tip"+str(tid), null), "fonts/heiti.ttf", 21).anchor(50, 50).pos(534, 439).color(100, 100, 100);
        temp = bg.addsprite("loadingCircle.png").anchor(50, 50).pos(763, 37).size(50, 57).color(100, 100, 100, 100).addaction(repeat(rotateby(2000, 360)));
        temp = bg.addsprite("loadingWord.png").anchor(0, 0).pos(607, 23).size(129, 29).color(100, 100, 100, 100);
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
