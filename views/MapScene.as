class MapScene extends MyNode
{
    var maxLevel;
    function MapScene(){
        bg = sprite("map_background.png").size(801,481);
        init();
        addChildZ(new MapLayer(),1);
    }
}
class CastleScene extends MyNode
{
    var hideTime = 0;
    var inHide = 0;
    var mc;
    var ml;
    function CastleScene()
    {
        bg = node();
        init();

        mc = new CastlePage(this);
        ml = new MenuLayer(this);
        addChild(mc);
        addChild(ml);
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
    function finishBuild()
    {
        var id = building.get("id");
        var cost = getBuildCost(id);
        global.user.doCost(cost);
        ml.finishBuild();
        mc.finishBuild();
        global.director.popView();
        building = null;
    }
    function cancelBuild()
    {
        ml.finishBuild();
        mc.cancelBuild();
        global.director.popView(); 
        building = null;
    }
    function clearHideTime()
    {
        hideTime = 0;
        if(inHide == 1)
        {
            inHide = 0;
            ml.showMenu();
        }
    }
    function update(diff)
    {
        hideTime += diff;
        if(hideTime >= 10000)
        {
            hideTime = 0;
            if(inHide == 0)
            {
                inHide = 1;
                ml.hideMenu();
            }
        }
    }
    var building = null;
    function build(id)
    {
        building = getBuild(id);
        building.update("state", 0);
        ml.beginBuild();   
        mc.beginBuild(building);
        global.director.pushView(new BuildMenu(this, building));
    }
}
