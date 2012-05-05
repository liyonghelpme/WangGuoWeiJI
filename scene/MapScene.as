class MapScene extends MyNode
{
    var maxLevel;
    function MapScene(){
        bg = sprite("map_background.png").size(801,481);
        init();
        addChildZ(new MapLayer(),1);
    }
}