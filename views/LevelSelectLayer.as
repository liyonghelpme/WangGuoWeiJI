/*
class Flag extends MyNode
{
    var layer;
    function Flag(l, p, pic, param)
    {
        layer = l;
        bg = node().size(100, 100).pos(p).anchor(50, 50);       
        bg.addsprite(pic).anchor(50, 50).size(20, 30).pos(50, 50);
        new Button(bg, onClicked, param);
    }
    function onClicked(param)
    {
        
    }
}
*/
class LevelSelectLayer extends MyNode
{
    var index;
    //var maxLevel = 132;
    //不同等级的地图位置不同
    var flagPos = [
    [],//Level 0 is village
    [[303, 81], [179, 87], [139, 155],[239, 155], [220, 199], [147, 252]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]]
    ];
    
    var darkNode;
    var levelNode;
    var scene;
    var islandLayer;
    
    /*
    显示岛屿上的小关卡node
    点击选择难度的时候显示 新的浮动node 这个可以交给MapLayer 来控制
    */
    function LevelSelectLayer(param, s){
        scene = s;
        //maxLevel = global.user.getValue("maxLevel");
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

        //maxLevel 当前  5 大关 * 6 小关* 10 难度 = 300 个关卡
        //maxLevel/10 解锁的关卡 - island (1-5) 
        var curDif = getCurEnableDif();

        var island = scene.getIsland(param);
        islandLayer = island.addnode();
        //var isPos = island.pos();
        trace("select Level", param, curDif);
        //var newPos;
        for(i=0;i < 6 && i <= curDif[1] && param <= curDif[0]; i++){
            //newPos = [isPos[0]+flagPos[index][i][0], isPos[1]+flagPos[index][i][1]]; 
            trace("flagPos", flagPos[index][i]);
            var b=islandLayer.addsprite("map_flag_complete.png").pos(flagPos[index][i]).size(20, 29);
            new Button(b, onSmall, i);
        }
        for(;i<6;i++){
            //newPos = [isPos[0]+flagPos[index][i][0], isPos[1]+flagPos[index][i][1]]; 
            islandLayer.addsprite("map_flag_notcomplete.png").pos(flagPos[index][i]).size(20, 29);
        }
    }
    
    function onSmall(param)
    {
        scene.onSmall(param);   
    }
    function onDiff(param)
    {
        scene.onDif(param);
    }
    override function exitScene()
    {
        islandLayer.removefromparent();
        super.exitScene();
    }
    /*
    function onClicked(param){
        trace("level select", param);
        scene.selectLevel(param);
    }
    */
    
    //状态:
    //全部岛屿 -> 某个岛屿小关 ->选择难度 -> 查看难度->进入游戏
    function goBack(){
        var sl = len(scene.contextStack);
        trace("goBack", sl);
        if(sl == 1){//返回主页面
            scene.gotoIsland(0);
        }
        else if(sl == 2){//返回小关页面
            darkNode.removefromparent();
            darkNode = null;
            levelNode.removefromparent();
            levelNode = null;
            scene.contextStack.pop();
        }
        else if(sl==3){//返回选择难度页面
            levelNode.addaction(sineout(moveto(1000,0,0)));
            scene.contextStack.pop();
        }
    }
    
    function selectSmall(param)
    {
        darkNode = sprite("dark.png").size(801,481);
        bg.add(darkNode,-1);
        levelNode = node();
        
        var first = 0;
        for(var i=0; i < 10 ; i++){
            var b=levelNode.addsprite("map_level_normal.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
            //临时数据

            var starNum = getStar(index, param);

            //var level = getMaxLevel(index, param, i)
            //starNum = starNum[level];

            //if(maxLevel-index*60+60-param*10==i)
            //    starNum=0;
                
            var j;
            for(j=0;j < starNum;j++){
                b.addsprite("map_level_star1.png").anchor(50,0).pos(13+j*31,64);
            }
            for(;j<3;j++){
                b.addsprite("map_level_star0.png").anchor(50,0).pos(13+j*31,64);
            }
            new Button(b, onDiff, i);
            if(starNum == 0)
                break;
        }
        for(;i<10;i++){
            levelNode.addsprite("map_level_lock.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
        }
        levelNode.addsprite("map_level_info.png").anchor(50,50).pos(1200,240);
        levelNode.addsprite("map_level_attack.png").anchor(100,0).pos(1550,360);
        bg.add(levelNode,0);
    }
    function selectDiff(param)
    {
        levelNode.addaction(sineout(moveto(1000,-800,0)));
    }
    /*
    function selectLevel(param){
        //index big
        //param small
        //difficult
        if(param <6){
            darkNode = sprite("dark.png").size(801,481);
            bg.add(darkNode,-1);
            levelNode = node();
            
            var first = 0;
            for(var i=0; i < 10 ; i++){
                var b=levelNode.addsprite("map_level_normal.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
                //临时数据

                var starNum = getStar(index, param);

                //var level = getMaxLevel(index, param, i)
                //starNum = starNum[level];

                //if(maxLevel-index*60+60-param*10==i)
                //    starNum=0;
                    
                var j;
                for(j=0;j < starNum;j++){
                    b.addsprite("map_level_star1.png").anchor(50,0).pos(13+j*31,64);
                }
                for(;j<3;j++){
                    b.addsprite("map_level_star0.png").anchor(50,0).pos(13+j*31,64);
                }
                new Button(b, onDiff, i);
                if(starNum == 0)
                    break;
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
    */
}
