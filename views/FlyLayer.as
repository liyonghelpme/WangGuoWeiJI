class FlyLayer extends MyNode
{
    var labelPos = [[302,237],[91,117],[123,410],[616,328],[667,109],[222,25]];
    var scene;
    function FlyLayer(s){
        scene = s;
        bg = node();
        init();
        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        jz.addlabel(getStr("mapAll", null),null,33).anchor(50,50).pos(75,22).color(0,0,0,100);
        for(var i=0;i<=5;i++){
            jz = bg.addsprite("map_label_small.png").size(100,30).anchor(0,0).pos(labelPos[i]);
            jz.addlabel(getStr("mapIsland"+str(i), null),null,22).anchor(50,50).pos(50,15).color(0,0,0,100);
        }
    }
}
