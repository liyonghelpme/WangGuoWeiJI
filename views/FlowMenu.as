class FlowMenu extends MyNode
{
    var scene;
    function FlowMenu(s)
    {
        scene = s;
        bg = node();
        init();
        bg.addsprite("map_back0.png").pos(13, 399).setevent(EVENT_TOUCH, goBack).scale(50);
    }
    function goBack()
    {
        global.director.popScene();
    }
}

