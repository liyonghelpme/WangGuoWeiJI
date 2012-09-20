class FlyLayer extends MyNode
{
    var labelPos = [[302,237],[91,117],[350,413],[616,328],[667,109],[222,25]];
    var scene;
    function FlyLayer(s){
        scene = s;
        bg = node();
        init();
        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
jz.addlabel(getStr("mapAll", null), "fonts/heiti.ttf", 22).anchor(50, 50).pos(75, 22).color(0, 0, 0, 100);
        for(var i=0;i<=5;i++){
            jz = bg.addsprite("map_label_small.png").size(100,30).anchor(0,0).pos(labelPos[i]);
jz.addlabel(getStr("mapIsland" + str(i), null), "fonts/heiti.ttf", 15).anchor(50, 50).pos(50, 15).color(0, 0, 0, 100);
        }
        //bg.addsprite("returnRoom.png").pos(39, 408).setevent(EVENT_TOUCH, onBack);


        var but0 = new NewButton("returnRoom.png", [72, 47], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onBack, null);
        but0.bg.anchor(50, 50).pos(75, 431);
        bg.add(but0.bg);
    }
    function onBack()
    {
        global.director.popScene(); 
    }
}
