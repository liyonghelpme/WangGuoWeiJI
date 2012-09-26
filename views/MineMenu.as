class MineMenu extends MyNode
{
    var scene;
    function MineMenu(s)
    {
        scene = s;
        bg = node();
        init();
        bg.addsprite("map_back0.png").pos(20, 460).size(62, 40).anchor(0, 100).setevent(EVENT_TOUCH, returnHome);

        var title = bg.addsprite("pageFriendTitle.png").pos(17, 13);
title.addlabel("name", "fonts/heiti.ttf", 20).pos(100, 22).anchor(0, 50);
        title.addsprite("soldier0.png").pos(39, 41).anchor(50, 50).size(57, 55);
        var level = global.user.getValue("level");
        if(level < MINE_BEGIN_LEVEL )
title.addlabel(getStr("mineNotBegin", ["[LEVEL]", str(MINE_BEGIN_LEVEL)]), "fonts/heiti.ttf", 22).pos(91, 44).color(0, 0, 0);

        /*
        var but = bg.addsprite("challengeCry.png", ARGB_8888).anchor(50, 50).pos(735, 426).setevent(EVENT_TOUCH, onChallenge);
        var sca = getSca(but, [70, 70]);
        but.scale(sca);
        */

        var but = bg.addsprite("mail.png", ARGB_8888).anchor(50, 50).pos(658, 426).setevent(EVENT_TOUCH, onMail);
        var sca = getSca(but, [70, 70]);
        but.scale(sca);
    }
    function onChallenge()
    {
    }
    function onMail()
    {
    }
    function returnHome()
    {
        global.director.popScene();
    }
    function hideMenu()
    {
        removeSelf();    
    }
    function showMenu()
    {
        scene.addChild(this);
    }
}
