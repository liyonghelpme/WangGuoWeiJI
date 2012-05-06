class BuildLand extends MyNode
{
    var map;
    function BuildLand(m)
    {
        map = m;
        bg = sprite("buildLand.png").pos(964, 880).anchor(0, 100);
        init();
        /*
        bg.addsprite("forest3.png").pos(442, -48);
        bg.addsprite("forest4.png").pos(969, -69);
        bg.addsprite("wall.png").pos(237, 88).anchor(0, 100);
        bg.addsprite("tree0.png").pos(534, 37);
        bg.addsprite("tree4.png").pos(453, 456);
        bg.addsprite("forest2.png").pos(43, -64);
        */

    }
}
class FarmLand extends MyNode
{   
    var map;
    function FarmLand(m)
    {
        map = m;
        bg = sprite("farmLand.png").pos(3000, 880).anchor(100, 100);
        init();

        /*
        var mount = sprite("mountain3.png").pos(694, 182).anchor(0, 100);
        bg.add(mount, -1);
        mount = sprite("mountain2.png").pos(-32, 210).anchor(0, 100);
        bg.add(mount, -2);

        bg.addsprite("tree1.png").pos(198, -21);
        bg.addsprite("tree2.png").pos(897, 320);
        bg.addsprite("forest5.png").pos(465, -93);
        */
        
    }
}
class TrainLand extends MyNode
{
    var map;
    function TrainLand(m)
    {
        map = m;
        bg = sprite("trainLand.png").pos(0, 880).anchor(0, 100);
        init();
        /*
        var mount = sprite("mountain0.png").pos(0, -3);
        bg.add(mount, -1);
        mount = sprite("mountain1.png").pos(446, 11);
        bg.add(mount, -2);

        bg.addsprite("trainHigh.png").pos(0, 188).anchor(0, 100);
        bg.addsprite("tree3.png").pos(841, -38);
        bg.addsprite("forest0.png").pos(29, -19);
        bg.addsprite("forest1.png").pos(373, -3);
        */

    }
}
