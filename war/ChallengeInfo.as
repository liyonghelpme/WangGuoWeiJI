class ChallengeInfo extends MyNode
{
    var scene;
    function ChallengeInfo(sc)
    {
        scene = sc;
        initView();
    }
    var challengeBut;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("challengeInfoBack.png").anchor(0, 0).pos(16, 8).size(319, 172).color(100, 100, 100, 100);
        temp = bg.addsprite("levelUpStar.png").anchor(50, 50).pos(46, 30).size(34, 33).color(100, 100, 100, 100);

bg.addlabel(getStr("Max", null), getFont(), 18).anchor(0, 50).pos(33, 63).color(100, 100, 100);

bg.addlabel(scene.user["name"], getFont(), 24).anchor(0, 50).pos(69, 32).color(100, 100, 100);
bg.addlabel(getStr("challengeDefense", ["[NUM]", str(scene.user["cityDefense"])]), getFont(), 15).anchor(0, 50).pos(220, 34).color(100, 100, 100);

bg.addlabel(str(scene.user["level"]), getFont(), 13).anchor(50, 50).pos(46, 32).color(0, 0, 0);

bg.addlabel(str(-scene.user["failScore"]), getFont(), 20).anchor(0, 50).pos(112, 112).color(94, 7, 5);

        temp = bg.addsprite("dialogRankCup.png").anchor(0, 0).pos(79, 102).size(25, 22).color(100, 100, 100, 100);
bg.addlabel(getStr("failCost", null), getFont(), 15).anchor(0, 50).pos(33, 113).color(100, 100, 100);


bg.addlabel(str(scene.user["silver"]), getFont(), 20).anchor(0, 50).pos(105, 81).color(100, 100, 100);
        temp = bg.addsprite("silver.png").anchor(0, 0).pos(78, 68).size(25, 25).color(100, 100, 100, 100);
bg.addlabel(str(scene.user["crystal"]), getFont(), 20).anchor(0, 50).pos(207, 80).color(100, 100, 100);
        temp = bg.addsprite("crystal.png").anchor(0, 0).pos(179, 69).size(25, 24).color(100, 100, 100, 100);


bg.addlabel(str(scene.user["winScore"]), getFont(), 20).anchor(0, 50).pos(304, 79).color(100, 100, 100);
        temp = bg.addsprite("dialogRankCup.png").anchor(0, 0).pos(278, 69).size(25, 22).color(100, 100, 100, 100);

bg.addlabel(getStr("challengeReward", null), getFont(), 15).anchor(0, 50).pos(33, 80).color(100, 100, 100);

        but0 = new NewButton("greenButton0.png", [67, 30], getStr("back", null), null, 15, FONT_NORMAL, [100, 100, 100], onBack, null);
        but0.bg.pos(103, 157);
        addChild(but0);
        but0 = new NewButton("greenButton0.png", [68, 30], getStr("challenge", null), null, 15, FONT_NORMAL, [100, 100, 100], onChallenge, null);
        but0.bg.pos(194, 157);
        addChild(but0);
        challengeBut = but0;


        but0 = new NewButton("greenButton0.png", [67, 30], getStr("nextTarget", null), null, 15, FONT_NORMAL, [100, 100, 100], onNextTarget, null);
        but0.bg.pos(282, 157);
        addChild(but0);
    }
    function onChallenge()
    {
        scene.startChallenge();  
    }
    function onNextTarget()
    {
        scene.startFindNext();    
    }
    function onBack()
    {
        global.director.popScene();
    }
    function closeDialog()
    {
        global.director.popView();
    }
    override function enterScene()
    {
        super.enterScene();
        trace("ChallengeInfo challengeBut");
        global.taskModel.showHintArrow(challengeBut.bg, challengeBut.bg.prepare().size(), CHALLENGE_INFO_BUT, onNewChallenge);
    }
    function onNewChallenge()
    {
        onChallenge();
    }
}
