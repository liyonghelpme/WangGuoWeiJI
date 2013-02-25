class FlyLayer extends MyNode
{
    var labelPos = [[302,237],[91,117],[350,413],[616,328],[667,115],[222,25]];
    var scene;
    var retBut;
    function FlyLayer(s){
        scene = s;
        bg = node();
        init();
        var lab;
        var lSize;
        var width;

        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
lab = jz.addlabel(getStr("mapAll", null), getFont(), 22).anchor(50, 50).pos(75, 22).color(0, 0, 0, 100);
        lSize = lab.prepare().size();
        width = max(150, lSize[0]+getParam("labelWidth"));
        jz.size(width, 45);
        lab.pos(width/2, 22);


        for(var i=0;i<=5;i++){
            jz = bg.addsprite("map_label_small.png").size(100,30).anchor(0,0).pos(labelPos[i]);
lab = jz.addlabel(getStr("mapIsland" + str(i), null), getFont(), 15).anchor(50, 50).pos(50, 15).color(0, 0, 0, 100);
            lSize = lab.prepare().size();
            width = max(100, lSize[0]+getParam("labelWidth"));
            jz.size(width, 30);
            lab.pos(width/2, 15);
        }

        var but0 = new NewButton("returnRoom.png", [72, 47], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], onBack, null);
        but0.bg.anchor(50, 50).pos(75, 431);
        bg.add(but0.bg);
        retBut = but0;
    }
    override function enterScene()
    {
        super.enterScene();
        //global.taskModel.showHintArrow(retBut.bg, retBut.bg.prepare().size(), BACK_BUSI);
    }
    function onBack()
    {
        global.director.popScene(); 
    }
}
