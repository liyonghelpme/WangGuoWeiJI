class BuildLand extends MyNode
{
    var map;
    function BuildLand(m)
    {
        map = m;
        bg = sprite("land1.png", ARGB_4444).pos(1000, 1120).anchor(0, 100);
        init();
        bg.addsprite("land4.png", ARGB_4444).pos(0, -208).anchor(0, 0);

    }
}
class FarmLand extends MyNode
{   
    var map;
    function FarmLand(m)
    {
        map = m;
        bg = sprite("land2.png", ARGB_4444).pos(2000, 1120).anchor(0, 100);
        init();
        bg.addsprite("land5.png", ARGB_4444).pos(0, -208).anchor(0, 0);
        
    }
}
class TrainLand extends MyNode
{
    var map;
    function TrainLand(m)
    {
        map = m;
        bg = sprite("land0.png", ARGB_4444).pos(0, 1120).anchor(0, 100);
        init();
        bg.addsprite("land3.png", ARGB_4444).pos(0, -208).anchor(0, 0);
    }
}
