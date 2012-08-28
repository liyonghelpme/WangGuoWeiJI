class MidMenu extends MyNode
{
    var pause;
    function MidMenu(p)
    {
        pause = p;
        bg = node();
        init();
        bg.addsprite("mapMenuContinue.png").anchor(50, 50).pos(317, 169+64).setevent(EVENT_TOUCH, onContinue);
        bg.addsprite("mapMenuQuit.png").anchor(50, 50).pos(474, 169+64).setevent(EVENT_TOUCH, onQuit);
    }
    function onContinue()
    {
        pause.continueGame();
        global.director.popView();
    }
    function onQuit()
    {
        global.director.popScene();
    }
}
class MapPause extends MyNode
{
    var scene;
    var leftDef;
    var rightDef;
    var leftText;
    var rightText;
    
    //var skillPos = [[76, 384], [198, 384], [324, 384]];
    var skillFlowBanner;
    var blood = 0;
    var bloodBut;
    function onBlood()
    {
        if(blood == 0)
        {
            scene.map.hideBlood();
            bloodBut.texture("showBlood.png", GRAY);
        }
        else
        {
            scene.map.showBlood();
            bloodBut.texture("showBlood.png");
        }
        blood = 1-blood;
    }
    function MapPause(s)
    {
        scene = s;
        bg = node();
        init();
        bg.addsprite("mapMenuPause.png").pos(703, 385).setevent(EVENT_TOUCH, onPause);
        bloodBut = bg.addsprite("showBlood.png").pos(600, 385).setevent(EVENT_TOUCH, onBlood);

        
        skillFlowBanner = new SkillFlowBanner(this);
        addChild(skillFlowBanner);
        //城堡防御力条 在练级页面没有
        if(scene.kind != CHALLENGE_TRAIN)
        {
            var banner = bg.addsprite("mapCastleBanner.png").pos(45, 20).anchor(0, 0);
            leftDef = banner.addsprite().pos(3, 5).anchor(0, 0);
            leftText = banner.addlabel("", null, 25).anchor(0, 50).pos(129, 20).color(0, 0, 0);
            var head = bg.addsprite("mapMenuHead.png").pos(50, 51).anchor(50, 50).size(81, 76);
            var solH = head.addsprite("soldier0.png").pos(40, 38).anchor(50, 50).scale(100, 100);
            var sca = getSca(solH, [70, 60]);
            solH.scale(-sca, sca);

            var nameBlock = bg.addsprite("mapNameBlock.png").pos(88, 50).anchor(0, 0);
            nameBlock.addlabel("name1", null, 20, FONT_BOLD).pos(32, 17).color(0, 0, 0).anchor(0, 50);


            banner = bg.addsprite("mapCastleBanner.png").pos(755, 20).anchor(100, 0);
            rightDef = banner.addsprite().pos(300, 5).anchor(100, 0);
            rightText = banner.addlabel("", null, 25).anchor(100, 50).pos(175, 20).color(0, 0, 0);
            head = bg.addsprite("mapMenuHead.png").pos(750, 51).anchor(50, 50).size(81, 76);
            solH = head.addsprite("soldier0.png").pos(40, 38).anchor(50, 50).scale(100, 100);
            sca = getSca(solH, [70, 60]);
            solH.scale(sca);

            nameBlock = bg.addsprite("mapNameBlock.png").pos(712, 50).anchor(100, 0);
            nameBlock.addlabel("name1", null, 20, FONT_BOLD).pos(213, 17).color(0, 0, 0).anchor(100, 50);
        }


        //bg.addsprite("mapMenuBlock.png").pos(skillPos[0]);
        //bg.addsprite("mapMenuBlock.png").pos(skillPos[1]);
        //bg.addsprite("mapMenuBlock.png").pos(skillPos[2]);
    }
    /*
    需要保证生命值 > 0
    传入防御装置的引用
    MapDefense
    */
    function initHealth(defense)
    {
        if(defense.color == 0)
        {
            leftDef.texture("mapCastleBlue.png");
            leftDef.size(297*defense.health/defense.healthBoundary, 29);
            leftText.text(str(defense.health)+"/"+str(defense.healthBoundary));
        }
        else if(defense.color == 1)
        {
            rightDef.texture("mapCastleRed.png");
            rightDef.size(297*defense.health/defense.healthBoundary, 29);
            rightText.text(str(defense.health)+"/"+str(defense.healthBoundary));
        }
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
            //var msg = param[1];
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
        inPause = 1; 
        scene.stopGame();
        global.director.pushView(new MidMenu(this), 1, 0);            
    }
}
