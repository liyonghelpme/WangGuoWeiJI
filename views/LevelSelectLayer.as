class LevelSelectLayer extends MyNode
{
    var index;
    var maxLevel = 132;
    var flagPos = [
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]]
    ];
    
    var darkNode;
    var levelNode;
    
    function LevelSelectLayer(param){
        bg = node();
        index = param;
        darkNode = null;
        levelNode = null;
        init();
        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        jz.addlabel(getStr("mapIsland"+str(index)),null,33).anchor(50,50).pos(75,22).color(0,0,0,100);
        var back=bg.addsprite("map_back.png").pos(50,360);
        new Button(back, goBack, 0);
        var i;
        for(i=0;i<=5 && i<=maxLevel/10-index*6+6;i++){
            var b=bg.addsprite("map_flag_complete.png").pos(flagPos[index][i]);
            new Button(b, onclicked, i);
        }
        for(;i<6;i++){
            bg.addsprite("map_flag_notcomplete.png").pos(flagPos[index][i]);
        }
    }
    
    function onclicked(param){
        bg.parent().get().selectLevel(param);
    }
    
    function goBack(){
        var sl = len(bg.parent().get().contextStack);
        if(sl == 1){
            bg.parent().get().gotoIsland(0);
        }
        else if(sl == 2){
            darkNode.removefromparent();
            darkNode = null;
            levelNode.removefromparent();
            levelNode = null;
            bg.parent().get().contextStack.pop();
        }
        else if(sl==3){
            levelNode.addaction(sineout(moveto(1000,0,0)));
            bg.parent().get().contextStack.pop();
        }
    }
    
    function selectLevel(param){
        if(param <6){
            darkNode = sprite("dark.png").size(801,481);
            bg.add(darkNode,-1);
            levelNode = node();
            for(var i=0;i<10 && i<=maxLevel-index*60+60-param*10;i++){
                var b=levelNode.addsprite("map_level_normal.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
                //临时数据
                var starNum = 3;
                if(maxLevel-index*60+60-param*10==i)
                    starNum=0;
                    
                var j;
                for(j=0;j<starNum;j++){
                    b.addsprite("map_level_star1.png").anchor(50,0).pos(13+j*31,64);
                }
                for(;j<3;j++){
                    b.addsprite("map_level_star0.png").anchor(50,0).pos(13+j*31,64);
                }
                new Button(b, onclicked, 10+i);
            }
            for(;i<10;i++){
                levelNode.addsprite("map_level_lock.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
            }
            levelNode.addsprite("map_level_info.png").anchor(50,50).pos(1200,240);
            levelNode.addsprite("map_level_attack.png").anchor(100,0).pos(1550,360);
            bg.add(levelNode,0);
        }
        else if(param>=10){
            levelNode.addaction(sineout(moveto(1000,-800,0)));
        }
    }
}