class BuildMenu extends MyNode
{
    var scene;
    var building;
    //util getBuild
    //kind = 0 farm
    function BuildMenu(s, b)
    {
        scene = s;
        building = b;
        trace("building data", building);
        bg = sprite("buildMenu.png").pos(0, global.director.disSize[1]).anchor(0, 100);
        if(building.get("kind") == 0)
        {
            bg.addsprite("buildOk.png").pos(687, 37).anchor(50, 50).setevent(EVENT_TOUCH, onOk);
            bg.addsprite("buildCancel.png").pos(744, 37).anchor(50, 50).setevent(EVENT_TOUCH, onCancel);
            bg.addlabel(building.get("name"), null, 30).anchor(0, 50).pos(112, 453).color(0, 0, 0);
        }
        else
        {
        }

    }
    function onOk(n, e, p, x, y, points)
    {   
        scene.finishBuild();
    }
    function onCancel(n, e, p, x, y, points)
    {
        scene.cancelBuild();
    }
}
