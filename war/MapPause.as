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
        /*
        bg = node();
        init();
        bg.addsprite("mapMenuContinue.png").anchor(50, 50).pos(317, 169+64).setevent(EVENT_TOUCH, onContinue);
        bg.addsprite("mapMenuQuit.png").anchor(50, 50).pos(474, 169+64).setevent(EVENT_TOUCH, onQuit);
        */

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
    /*
    const HEAD_WID = 75;
    const HEAD_HEI = 70;
    const BLOOD_X = 73;
    const BLOOD_Y = 20;
    const BL_OFFX = 2;
    const BL_OFFY = 4;

    const LW_X = 129;
    const HX = 6;
    const HY = 15;
    const HW = 70;
    const HH = 60;

    const NX = 72;
    const NY = 53;
    */

    var defBlood;
    var redBlood;
    var bloodText;
    /*
    const banSize = [262, 35];
    const nameSize = [214, 29];

    const DEF_T_X = 26;
    const DEF_T_Y = 18; 
    const DEF_NAME_X = 26;
    const DEF_NAME_Y = 15;
    */

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
            bg.addlabel(global.user.name, "fonts/heiti.ttf", 20).anchor(0, 50).pos(94, 58).color(0, 0, 0);
            temp = bg.addsprite("mapMenuHead.png").anchor(50, 50).pos(51, 41).size(68, 63).color(100, 100, 100, 100);
            //自己头像
            var sid = global.user.getFirstHero();
            var spriData = global.user.getSoldierData(sid);

            temp = bg.addsprite("soldier"+str(spriData["id"])+".png").anchor(50, 50).pos(52, 41).color(100, 100, 100, 100);
            sca = getSca(temp, [63, 56]);
            temp.scale(sca);
            leftText = bg.addlabel("", "fonts/heiti.ttf", 28).anchor(0, 50).pos(91, 29).color(0, 0, 0);

            //转向放置
            temp = bg.addsprite("mapNewCastleBanner.png").anchor(50, 50).pos(603, 42).size(247, 60).color(100, 100, 100, 100);
            rightRed = bg.addsprite("mapDefenseRed.png").anchor(0, 0).pos(485, 17).size(237, 24).color(100, 100, 100, 100);
            rightDef = bg.addsprite("mapDefenseYellow.png").anchor(0, 0).pos(485, 17).size(237, 24).color(100, 100, 100, 100);

            //怪兽没有名字 采用 怪兽
            /*
            bg.addlabel(getStr("liyong", null), "fonts/heiti.ttf", 20).anchor(100, 50).pos(711, 58).color(0, 0, 0);
temp = bg.addsprite("mapMenuHead.png").anchor(50, 50).pos(750, 41).size(68, 63).color(100, 100, 100, 100);
temp = bg.addsprite("黑暗魔君头像.png").anchor(50, 50).pos(750, 39).color(100, 100, 100, 100);
sca = getSca(temp, [60, 59]);
temp.scale(sca);
bg.addlabel(getStr("3000", null), "fonts/heiti.ttf", 26).anchor(100, 50).pos(710, 29).color(0, 0, 0);p
            */
            if(scene.kind == CHALLENGE_MON)
                bg.addlabel(getStr("monster", null), "fonts/heiti.ttf", 20).anchor(100, 50).pos(711, 58).color(0, 0, 0);
            else
                bg.addlabel(scene.user["name"], "fonts/heiti.ttf", 20).anchor(100, 50).pos(711, 58).color(0, 0, 0);
                
            temp = bg.addsprite("mapMenuHead.png").anchor(50, 50).pos(750, 41).size(68, 63).color(100, 100, 100, 100);
            //闯关使用关卡怪兽头像
            //挑战使用 对方英雄头像需要修改多处返回对方英雄信息 
            //或者构建一个底层的库用于快速获取服务器返回的用户信息----->uid---->information
            //User Information Manager
            if(scene.kind == CHALLENGE_MON)//怪兽暂时用bossId
                temp = bg.addsprite("soldier"+str(1380)+".png").anchor(50, 50).pos(750, 39).color(100, 100, 100, 100);
            else
                temp = bg.addsprite("soldier"+str(scene.user["heroId"])+".png").anchor(50, 50).pos(750, 39).color(100, 100, 100, 100);

            sca = getSca(temp, [60, 59]);
            temp.scale(sca);
            rightText = bg.addlabel("", "fonts/heiti.ttf", 26).anchor(100, 50).pos(711, 29).color(0, 0, 0);


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
        //bg = node();
        //init();

        //bg.addsprite("mapMenuPause.png").pos(703, 385).setevent(EVENT_TOUCH, onPause);
        //bloodBut = bg.addsprite("showBlood.png").pos(600, 385).setevent(EVENT_TOUCH, onBlood);

        
        skillFlowBanner = new SkillFlowBanner(this);
        addChild(skillFlowBanner);
        /*
        //城堡防御力条 在练级页面没有
        if(scene.kind != CHALLENGE_TRAIN)
        {
            var disSize = global.director.disSize;
            //位置
            var banner = bg.addsprite("mapNewCastleBanner.png").pos(BLOOD_X, BLOOD_Y).anchor(0, 0);
            //var banSize = banner.prepare().size();

            leftRed = banner.addsprite("mapDefenseRed.png").pos(BL_OFFX, BL_OFFY).anchor(0, 0);
            var mInfo = getData(MAP_INFO, scene.big);
            if(mInfo["blood"] == 0)
                leftDef = banner.addsprite("mapDefenseBlue.png").pos(BL_OFFX, BL_OFFY).anchor(0, 0);
            else if(mInfo["blood"] == 1)
                leftDef = banner.addsprite("mapDefenseGreen.png").pos(BL_OFFX, BL_OFFY).anchor(0, 0);
leftText = banner.addlabel("", "fonts/heiti.ttf", 28, FONT_BOLD).anchor(0, 50).pos(DEF_T_X, DEF_T_Y).color(0, 0, 0);

            //214 29
            var nameBlock = bg.addsprite("mapNameBlock.png").pos(NX, NY).anchor(0, 0);
            //var nameSize = nameBlock.prepare().size();
nameBlock.addlabel("name1", "fonts/heiti.ttf", 20, FONT_BOLD).pos(DEF_NAME_X, DEF_NAME_Y).color(0, 0, 0).anchor(0, 50);

            var head = bg.addsprite("mapMenuHead.png").pos(HX, HY).anchor(0, 0).size(HEAD_WID, HEAD_HEI);
            var solH = head.addsprite("soldier0.png").pos(HEAD_WID/2, HEAD_HEI/2).anchor(50, 50).scale(100, 100);
            var sca = getSca(solH, [HW, HH]);
            solH.scale(-sca, sca);


            //右侧位置
            banner = bg.addsprite("mapNewCastleBanner.png").pos(disSize[0]-BLOOD_X, BLOOD_Y).anchor(100, 0);
            rightRed = banner.addsprite("mapDefenseRed.png").pos(banSize[0]-BL_OFFX, BL_OFFY).anchor(100, 0);
            rightDef = banner.addsprite("mapDefenseYellow.png").pos(banSize[0]-BL_OFFX, BL_OFFY).anchor(100, 0);
rightText = banner.addlabel("", "fonts/heiti.ttf", 28, FONT_BOLD).anchor(100, 50).pos(banSize[0] - DEF_T_X, DEF_T_Y).color(0, 0, 0);


            nameBlock = bg.addsprite("mapNameBlock.png").pos(disSize[0]-NX, NY).anchor(100, 0);
nameBlock.addlabel("name1", "fonts/heiti.ttf", 20, FONT_BOLD).pos(nameSize[0] - DEF_NAME_X, DEF_NAME_Y).color(0, 0, 0).anchor(100, 50);

            head = bg.addsprite("mapMenuHead.png").pos(disSize[0]-HX, HY).anchor(100, 0).size(HEAD_WID, HEAD_HEI);
            solH = head.addsprite("soldier0.png").pos(HEAD_WID/2, HEAD_HEI/2).anchor(50, 50).scale(100, 100);
            sca = getSca(solH, [HW, HH]);
            solH.scale(sca);

            defBlood = [leftDef, rightDef];
            redBlood = [leftRed, rightRed];
            bloodText = [leftText, rightText];
        }
        */


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
