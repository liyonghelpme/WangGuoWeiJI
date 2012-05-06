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
    function CastleScene()
    {
        bg = node();
        init();

        var mc = new CastlePage();
        var ml = new MenuLayer();
        addChild(mc);
        addChild(ml);
    }
}
