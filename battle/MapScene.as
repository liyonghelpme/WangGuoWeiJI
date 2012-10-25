class MCloud extends MyNode
{
    var map;
    var ty;
    function MCloud(m)
    {
        map = m;
        ty = getParam("IslandCloudYBase")+rand(getParam("IslandCloudYDiff"));
        bg = sprite("bc"+str(rand(8))+".png").pos(-100, ty);
        init();
        //bg.addaction(sequence(moveto(50000, 810, ty+rand(10)), callfunc(remove)));
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
        lastTime = 1000000;

        initCloud();
    }


    function initCloud()
    {
        for(var i = 0; i < getParam("IslandCloudInitNum"); i++)
        {
            var c = new MCloud(this);
            //随机屏幕位置
            var ty = rand(400)+10;
            var tx = rand(600)+20;
            c.setPos([tx, ty]);
            
            var t = (800-tx)*getParam("cloudMoveTime")/800;

            addChild(c);
            clouds.append(c);
            c.bg.addaction(sequence(moveto(t, 810, ty+rand(10)), callfunc(c.remove)));
        }
    }


    function removeCloud(c)
    {
        clouds.remove(c); 
    }
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= getParam("IslandCloudGenTime"))
        {
            lastTime = 0;
            if(len(clouds) < getParam("CloudTotalNum"))
            {
                var c = new MCloud(this);
                addChild(c);
                clouds.append(c);
                c.bg.addaction(sequence(moveto(getParam("cloudMoveTime"), 810, c.ty+rand(10)), callfunc(c.remove)));
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
/*
back 键退出场景 进入场景之后应该主动接受back事件否则就不处理
*/
class MapScene extends MyNode
{
    var islandLayer;
    var flyLayer;
    
    function MapScene(){
        bg = sprite("map_background0.jpg", ARGB_8888).size(801,481);
        init();
        islandLayer = new MapLayer(this);
        addChildZ(islandLayer, ISLAND_LAYER);
        addChildZ(new MapCloud(), CLOUD_LAYER);
        
        flyLayer = new FlyLayer(this);
        addChildZ(flyLayer, 3);
        
        //bg.add(sprite("map_toplayer.png").size(801,481),4);
        
    }

    //var noOpTime = 0;
    //const SHOW_ARROW_TIME = 5000;
    function update(diff)
    {
        /*
        if(len(contextStack) == 0)//在主界面 没有选择地图
            noOpTime += diff;

        if(noOpTime >= SHOW_ARROW_TIME)
        {
            noOpTime = 0;
            islandLayer.showArrow();
        }
        */
        showTime += diff;
        if(needShow == 1 && showTime >= 800)
        {
            refreshFly();    
        }
    }
    override function enterScene()
    {
        super.enterScene(); 
        global.timer.addTimer(this);
        bg.setevent(EVENT_KEYDOWN, quitMapSel);
        bg.focus(1);
    }
    function quitMapSel(n, e, p, kc)
    {
        if(kc == KEYCODE_BACK)
            global.director.popScene();
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
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
    var showTime = 0;
    //var showYet = 0;
    var needShow = 0;
    //变更菜单 更新 岛屿
    //变更岛屿
    function gotoIsland(param){
        //islandLayer.removeArrow();
        //noOpTime = 0;
        //回到主页面
        flyLayer.removeSelf();
        if(param == 0)
        {
            flyLayer = new FlyLayer(this);
        }
        else
        {
            flyLayer = new LevelChoose(this, param-1); 
        }
        islandLayer.gotoIsland(param);
        showTime = 0;
        needShow = 1;
        /*
        var sl = len(contextStack);
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
                //flyLayer = new LevelSelectLayer(param, this);
                //未进入选择页面
                
                //实际的战斗页面编号
                flyLayer = new LevelChoose(this, param-1); 
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
            //显示新的等级选择页面 全局控制显示新页面

            showTime = 0;
            needShow = 1;
        }
        */
    }
    
    /*
    function onSmall(param)
    {
        //var sl = len(contextStack);//第一阶段 
        //if(sl == 1 && param<6){

        flyLayer.selectSmall(param);
        //contextStack.append(param);

        //}
    }
    */

    /*
    function onDiff(param)
    {
//        trace("scene onDiff", param, contextStack);
        var sl = len(contextStack);
        if(sl==2){
            //flyLayer.selectLevel(param);
            flyLayer.selectDiff(param);
            contextStack.append(param);
        }
    }
    */

    function refreshFly(){
        needShow = 0;
        showTime = 0;
        addChildZ(flyLayer, FLY_LAYER);
    }
}

