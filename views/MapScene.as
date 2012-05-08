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
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.exitScene();
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
    function build(id)
    {
        ml.beginBuild();   
        mc.beginBuild(id);
    }
}
