class MCloud extends MyNode
{
    var map;
    function MCloud(m)
    {
        map = m;
        var ty = 10+rand(400);
        bg = sprite("bc"+str(rand(8))+".png").pos(-100, ty);
        bg.addaction(sequence(moveto(50000, 810, ty+rand(10)), callfunc(remove)));
    }
    function remove()
    {
        removeSelf();
        map.removeCloud(this);
    }
}

class MapCloud extends MyNode
{
    var clouds;
    var lastTime;
    function MapCloud()
    {
        bg = node();
        init();
        clouds = [];
        lastTime = 0;
    }
    function removeCloud(c)
    {
        clouds.remove(c); 
    }
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= 10000)
        {
            lastTime = 0;
            if(len(clouds) < 5)
            {
                var c = new MCloud(this);
                addChild(c);
                clouds.append(c);
            }
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
/*
5个大关 1-5
6个小关 0-6
10个难度 0-9
300个难度 每个难度 有一个星得分
每个小关 必须完成前一个难度 才能进入下一个难度 后面的难度 加锁 可以根据小关的难度最后一个得分的情况判断哪些加锁， 哪些可以进行
一个大关开启要求 前一个大关 最后的小关 达到某个难度

暂定都是 难度 5
所以 maxLevel 没有意义

*/
class MapScene extends MyNode
{
    //var maxLevel;
    var islandLayer;
    var flyLayer;
    
    var contextStack;
    function MapScene(){
        //maxLevel = global.user.getValue("maxLevel");
        bg = sprite("map_background.png", ARGB_8888).size(801,481);
        init();
        islandLayer = new MapLayer(this);
        addChildZ(islandLayer, ISLAND_LAYER);

        addChildZ(new MapCloud(), CLOUD_LAYER);
        
        flyLayer = new FlyLayer(this);
        addChildZ(flyLayer, 3);
        
        bg.add(sprite("map_toplayer.png").size(801,481),4);
        
        contextStack=[];
    }
    
    function getIsland(big)
    {
        return islandLayer.getIsland(big);
    }
    
    /*
    contextStack 深度:
    0: 主页面
    1: 小关页面 进入临近小关页面 返回主页面
    2: 选择难度页面  删除难度页面
    3: 选择是否进入游戏页面 左右移动 levellayer
    */
    function gotoIsland(param){
        trace("scene goto island", param, contextStack);
        var sl = len(contextStack);
        //|| (sl==1 && contextStack[0]!=param)
        if( (sl==0 && param!=0) || (sl==1 && contextStack[0]!=param) ){
            removeChild(flyLayer);
            //从难度选择页面返回
            if(param == 0){
                flyLayer = new FlyLayer(this);
                contextStack.pop();
            }
            //选择其它岛屿
            else{
                //显示新的 等级选择页面
                flyLayer = new LevelSelectLayer(param, this);
                //未进入选择页面
                if(sl==0){
                    contextStack.append(param);
                }
                //选择其它岛屿
                else{
                    contextStack[0] = param;
                }
            }
            //进入岛屿
            islandLayer.gotoIsland(param);
            //显示新的等级选择页面
            bg.addaction(sequence(delaytime(1000),callfunc(refreshFly)));
        }
    }
    
    function onSmall(param)
    {
        var sl = len(contextStack);
        if(sl==1 && param<6){
            //flyLayer.selectLevel(param);
            flyLayer.selectSmall(param);
            contextStack.append(param);
        }
    }
    function onDiff(param)
    {
        trace("scene onDiff", param, contextStack);
        var sl = len(contextStack);
        if(sl==2){
            //flyLayer.selectLevel(param);
            flyLayer.selectDiff(param);
            contextStack.append(param);
        }
    }
    /*
    function selectLevel(param){
        trace("scene selectLevel", param);
        var sl = len(contextStack);
        //已经进入
        if(sl==1 && param<6){
            flyLayer.selectLevel(param);
            contextStack.append(param);
        }
        else if(sl==2 && param>=10){
            flyLayer.selectLevel(param);
            contextStack.append(param-10);
        }
    }
    */
    
    function refreshFly(){
        addChildZ(flyLayer, FLY_LAYER);
    }
}

