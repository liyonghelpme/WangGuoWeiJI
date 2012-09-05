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
    var leftRed;
    var rightRed;
    const HEAD_WID = 75;
    const HEAD_HEI = 70;
    const BLOOD_X = 73;
    const BLOOD_Y = 15;
    const BL_OFFX = 2;
    const BL_OFFY = 4;

    const LW_X = 129;
    const HX = 6;
    const HY = 15;
    const HW = 70;
    const HH = 60;

    const NX = 72;
    const NY = 48;

    var defBlood;
    var redBlood;
    var bloodText;
    const banSize = [262, 35];
    const nameSize = [214, 29];

    const DEF_T_X = 26;
    const DEF_T_Y = 18; 
    const DEF_NAME_X = 26;
    const DEF_NAME_Y = 15;

    function MapPause(s)
    {
        scene = s;
        bg = node();
        init();
        bg.addsprite("mapMenuPause.png").pos(703, 385).setevent(EVENT_TOUCH, onPause);
        //bloodBut = bg.addsprite("showBlood.png").pos(600, 385).setevent(EVENT_TOUCH, onBlood);

        
        skillFlowBanner = new SkillFlowBanner(this);
        addChild(skillFlowBanner);
        //城堡防御力条 在练级页面没有
        if(scene.kind != CHALLENGE_TRAIN)
        {
            var disSize = global.director.disSize;
            //位置
            var banner = bg.addsprite("mapNewCastleBanner.png").pos(BLOOD_X, BLOOD_Y).anchor(0, 0);
            //var banSize = banner.prepare().size();

            leftRed = banner.addsprite("mapDefenseRed.png").pos(BL_OFFX, BL_OFFY).anchor(0, 0);
            leftDef = banner.addsprite("mapDefenseBlue.png").pos(BL_OFFX, BL_OFFY).anchor(0, 0);
            leftText = banner.addlabel("", null, 28, FONT_BOLD).anchor(0, 50).pos(DEF_T_X, DEF_T_Y).color(0, 0, 0);

            //214 29
            var nameBlock = bg.addsprite("mapNameBlock.png").pos(NX, NY).anchor(0, 0);
            //var nameSize = nameBlock.prepare().size();
            nameBlock.addlabel("name1", null, 20, FONT_BOLD).pos(DEF_NAME_X, DEF_NAME_Y).color(0, 0, 0).anchor(0, 50);

            var head = bg.addsprite("mapMenuHead.png").pos(HX, HY).anchor(0, 0).size(HEAD_WID, HEAD_HEI);
            var solH = head.addsprite("soldier0.png").pos(HEAD_WID/2, HEAD_HEI/2).anchor(50, 50).scale(100, 100);
            var sca = getSca(solH, [HW, HH]);
            solH.scale(-sca, sca);


            //右侧位置
            banner = bg.addsprite("mapNewCastleBanner.png").pos(disSize[0]-BLOOD_X, BLOOD_Y).anchor(100, 0);
            rightRed = banner.addsprite("mapDefenseRed.png").pos(banSize[0]-BL_OFFX, BL_OFFY).anchor(100, 0);
            rightDef = banner.addsprite("mapDefenseGreen.png").pos(banSize[0]-BL_OFFX, BL_OFFY).anchor(100, 0);
            rightText = banner.addlabel("", null, 28, FONT_BOLD).anchor(100, 50).pos(banSize[0]-DEF_T_X, DEF_T_Y).color(0, 0, 0);


            nameBlock = bg.addsprite("mapNameBlock.png").pos(disSize[0]-NX, NY).anchor(100, 0);
            nameBlock.addlabel("name1", null, 20, FONT_BOLD).pos(nameSize[0]-DEF_NAME_X, DEF_NAME_Y).color(0, 0, 0).anchor(100, 50);

            head = bg.addsprite("mapMenuHead.png").pos(disSize[0]-HX, HY).anchor(100, 0).size(HEAD_WID, HEAD_HEI);
            solH = head.addsprite("soldier0.png").pos(HEAD_WID/2, HEAD_HEI/2).anchor(50, 50).scale(100, 100);
            sca = getSca(solH, [HW, HH]);
            solH.scale(sca);

            defBlood = [leftDef, rightDef];
            redBlood = [leftRed, rightRed];
            bloodText = [leftText, rightText];
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
    var bloodTotalLen = 257;
    var bloodHeight = 27;
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

        /*
        if(defense.color == 0)
        {
            oldSize = leftDef.prepare().size();
            leftRed.stop();

            leftDef.size(sx, bloodHeight);
            leftText.text(str(defense.health)+"/"+str(defense.healthBoundary));
        }
        else if(defense.color == 1)
        {
            oldSize = rightDef.prepare().size();
            rightRed.stop();
            if(sx < oldSize[0])
            {
                difX = oldSize[0]-sx;
                spe = bloodTotalLen/2;//speed /s
                t = max(difX*1000/spe, 400);//ms
                rightRed.addaction(sizeto(t, sx, bloodHeight));
            }
            else 
                rightRed.size(sx, bloodHeight);

            rightDef.size(sx, bloodHeight);
            rightText.text(str(defense.health)+"/"+str(defense.healthBoundary));
        }
        */
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
        if(inPause == 0)
        {
            inPause = 1; 
            scene.stopGame();
            global.director.pushView(new MidMenu(this), 1, 0);            
        }
    }
}
