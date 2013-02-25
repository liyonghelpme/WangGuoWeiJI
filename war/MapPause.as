class MidMenu extends MyNode
{
    var pause;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("mapMenuContinue.png").anchor(0, 0).pos(312, 203).size(70, 93).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onContinue);
        temp = bg.addsprite("mapMenuQuit.png").anchor(0, 0).pos(420, 203).size(71, 92).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onQuit);
    }

    function MidMenu(p)
    {
        pause = p;
        initView();
    }
    function onContinue()
    {
        pause.continueGame();
        global.director.popView();
    }
    function clearQuitState()
    {
        quitYet = 0;
    }
    var quitYet = 0;
    function onQuit()
    {
        if(quitYet == 0)
        {
            quitYet = 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("quitWillFail", null), [100, 100, 100], clearQuitState));
        }
        else
        {
            global.director.popView();
            pause.scene.map.quitFail();
        }
    }
}
class MapPause extends MyNode
{
    var scene;
    var leftDef;
    var rightDef;
    var leftText;
    var rightText;
    
    var skillFlowBanner;

    var leftRed;
    var rightRed;

    var defBlood;
    var redBlood;
    var bloodText;

    var bloodTotalLen = 237;
    var bloodHeight = 24;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;

        if(scene.kind != CHALLENGE_TRAIN)
        {
            temp = bg.addsprite("mapNewCastleBanner.png").anchor(50, 50).pos(197, 42).size(247, 60).color(100, 100, 100, 100);
            temp.scale(-100, 100);
            leftRed = bg.addsprite("mapDefenseRed.png").anchor(0, 0).pos(80, 17).size(237, 24).color(100, 100, 100, 100);
            leftDef = bg.addsprite("mapDefenseBlue.png").anchor(0, 0).pos(80, 17).size(237, 24).color(100, 100, 100, 100);

            var mInfo = getData(MAP_INFO, scene.big);
            if(mInfo["blood"] == 0)
                leftDef.texture("mapDefenseBlue.png");
            else if(mInfo["blood"] == 1)
                leftDef.texture("mapDefenseGreen.png");

            //自己名字
bg.addlabel(global.user.name, getFont(), 20).anchor(0, 50).pos(94, 58).color(0, 0, 0);
            temp = bg.addsprite("mapMenuHead.png").anchor(50, 50).pos(51, 41).size(68, 63).color(100, 100, 100, 100);
            //自己头像
            temp = bg.addsprite("boss"+str(global.user.getValue("heroId"))+".png").anchor(50, 50).pos(52, 41).color(100, 100, 100, 100).scale(-100, 100);
            sca = getSca(temp, [63, 56]);
            temp.scale(-sca, sca);
leftText = bg.addlabel("", getFont(), 28).anchor(0, 50).pos(91, 29).color(0, 0, 0);

            //转向放置
            temp = bg.addsprite("mapNewCastleBanner.png").anchor(50, 50).pos(603, 42).size(247, 60).color(100, 100, 100, 100);
            rightRed = bg.addsprite("mapDefenseRed.png").anchor(0, 0).pos(485, 17).size(237, 24).color(100, 100, 100, 100);
            rightDef = bg.addsprite("mapDefenseYellow.png").anchor(0, 0).pos(485, 17).size(237, 24).color(100, 100, 100, 100);

            //怪兽没有名字 采用 怪兽
            if(scene.kind == CHALLENGE_MON)
bg.addlabel(getStr("monster", null), getFont(), 20).anchor(100, 50).pos(711, 58).color(0, 0, 0);
            //挑战其它用户名字
            else
bg.addlabel(scene.user["name"], getFont(), 20).anchor(100, 50).pos(711, 58).color(0, 0, 0);
                
            temp = bg.addsprite("mapMenuHead.png").anchor(50, 50).pos(750, 41).size(68, 63).color(100, 100, 100, 100);
            //闯关使用关卡怪兽头像
            //挑战使用 对方英雄头像需要修改多处返回对方英雄信息 
            //或者构建一个底层的库用于快速获取服务器返回的用户信息----->uid---->information
            //User Information Manager
            if(scene.kind == CHALLENGE_MON)//怪兽暂时用bossId
                temp = bg.addsprite("boss"+str(mInfo["bossId"])+".png").anchor(50, 50).pos(750, 39).color(100, 100, 100, 100);
            else
                temp = bg.addsprite("boss"+str(scene.user["heroId"])+".png").anchor(50, 50).pos(750, 39).color(100, 100, 100, 100);

            sca = getSca(temp, [60, 59]);
            temp.scale(sca);
rightText = bg.addlabel("", getFont(), 26).anchor(100, 50).pos(711, 29).color(0, 0, 0);


            defBlood = [leftDef, rightDef];
            redBlood = [leftRed, rightRed];
            bloodText = [leftText, rightText];
        }

        temp = bg.addsprite("mapMenuPause.png").anchor(0, 0).pos(715, 409).size(58, 58).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onPause);
    }
    function MapPause(s)
    {
        scene = s;
        initView();

        
        skillFlowBanner = new SkillFlowBanner(this);
        addChild(skillFlowBanner);
    }
    /*
    需要保证生命值 > 0
    传入防御装置的引用
    MapDefense
    */

    function initHealth(defense)
    {
        var sx = max(bloodTotalLen*defense.health/defense.healthBoundary, 0);
        var oldSize;
        var difX;
        var spe;
        var t;

        var defB = defBlood[defense.color];
        var redB = redBlood[defense.color];
        var bText = bloodText[defense.color];

        oldSize = defB.prepare().size();
        redB.stop();

        if(sx < oldSize[0])
        {
            difX = oldSize[0]-sx;
            spe = bloodTotalLen/2;//speed /s
            t = max(difX*1000/spe, 400);//ms
            redB.addaction(sizeto(t, sx, bloodHeight));
        }
        else 
            redB.size(sx, bloodHeight);
        defB.size(sx, bloodHeight);
        bText.text(str(defense.health)+"/"+str(defense.healthBoundary));

    }
    override function enterScene()
    {
        super.enterScene();
        if(scene.kind != CHALLENGE_TRAIN)
        {
            initHealth(scene.getDefense(0));
            initHealth(scene.getDefense(1));
            global.msgCenter.registerCallback(CASTLE_DEF, this);
        }

    }
    override function exitScene()
    {
        if(scene.kind != CHALLENGE_TRAIN)
            global.msgCenter.removeCallback(CASTLE_DEF, this);
        super.exitScene();
    }

    function receiveMsg(param)
    {
        if(param[0] == CASTLE_DEF)
        {
            initHealth(param[1]);
        }
    }

    function continueGame()
    {
        inPause = 0;
        scene.continueGame();
    }
    var inPause = 0;
    function onPause()
    {
        //不再新手任务过程中可以点击停止按钮
        if(inPause == 0 && !global.taskModel.checkInNewTask())
        {
            inPause = 1; 
            scene.stopGame();
            global.director.pushView(new MidMenu(this), 1, 0);            
        }
    }
}
