class BuildLand extends MyNode
{
    var map;
    function BuildLand(m)
    {
        map = m;
        bg = sprite("land1.png").pos(1000, 920).anchor(0, 100);
        init();

    }
}
class FarmLand extends MyNode
{   
    var map;
    function FarmLand(m)
    {
        map = m;
        bg = sprite("land2.png").pos(2000, 920).anchor(0, 100);
        init();

        
    }
}
class TrainLand extends MyNode
{
    var map;
    function TrainLand(m)
    {
        map = m;
        bg = sprite("land0.png").pos(0, 920).anchor(0, 100);
        init();

    }
}
