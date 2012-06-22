class MidMenu extends MyNode
{
    function MidMenu()
    {
        bg = node();
        init();
        bg.addsprite("mapMenuContinue.png").pos(255, 169).setevent(onContinue);
        bg.addsprite("mapMenuQuit.png").pos(432, 169).setevent(onQuit)
    }
    function onContinue()
    {
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

    var skillPos = [[76, 384], [198, 384], [324, 384]];

    function MapPause(s)
    {
        scene = s;
        bg = node();
        init();
        bg.addsprite("mapMenuPause.png").pos(703, 385).setevent(EVENT_TOUCH, onPause);

        bg.addsprite("mapMenuBlock.png").pos(50, 51).anchor(50, 50);
        var banner = bg.addsprite("mapCastleBanner.png").pos(45, 20).anchor(0, 0);
        leftDef = banner.addsprite().pos(3, 5).anchor(0, 0);
        
        bg.addsprite("mapMenuBlock.png").pos(750, 51).anchor(50, 50);
        banner = bg.addsprite("mapCastleBanner.png").pos(755, 20).anchor(100, 0);
        rightDef = banner.addsprite().pos(300, 5).anchor(100, 0);


        bg.addsprite("mapMenuBlock.png").pos(skillPos[0]);
        bg.addsprite("mapMenuBlock.png").pos(skillPos[1]);
        bg.addsprite("mapMenuBlock.png").pos(skillPos[2]);
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
            if(defense.health*100/defense.healthBound < 30)
                leftDef.texture("mapCastleRed.png");
            else
                leftDef.texture("mapCastleBlue.png");
            leftDef.size(297*defense.health/defense.healthBound, 29);
        }
        else if(defense.color == 1)
        {
            if(defense.health*100/defense.healthBound < 30)
                rightDef.texture("mapCastleRed.png");
            else
                rightDef.texture("mapCastleBlue.png");
            rightDef.size(297*defense.health/defense.healthBound, 29);
        }
    }
    override function enterScene()
    {
        super.enterScene();
        initHealth(scene.getDefense(0));
        initHealth(scene.getDefense(1));
        global.msgCenter.registerCallback(CASTLE_DEF, this);
    }
    override function exitScene()
    {
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

    function onPause()
    {
        global.director.pushView(new MidMenu(), 1, 0);            
    }
}
