class FlyObject extends MyNode
{
    var callback;
    var num;
    var cost;
    //const FLY_REWARD = ["silver", "gold", "crystal", "exp"];
    //getscene.add(bg)
    /*
        obj 飞行物体出现位置的原来物体
        cost 增加的用户数值
        cb 当飞行结束时的回调函数

        需要场景加上该node
    */
    const FLY_WIDTH = 30;
    const FLY_HEIGHT = 30;
    //回调函数避免在callfunction 中调用
    function update(diff)
    {   
        if(num == 0)
        {
            removeSelf();
            global.user.doAdd(cost);
            if(callback != null)
                callback();       
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }

    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }

    function FlyObject(obj, c, cb)
    {
        trace("FlyObject", obj, c, cb);
        callback = cb;
        num = 0;
        cost = c;
        bg = node();

        var TarPos = dict([["silver", [297, 460]], ["crystal", [253, 460]], ["gold", [550, 460]], ["exp", [196, 427]]]);
        var defaultPos = [297, 460];

        var bsize = obj.size();
        var coor2 = obj.node2world(bsize[0]/2, -10);

        var item = cost.items();
//        trace("flyObject", cost);
        //var offY = 0;
        var waitTime = 0;
        for(var i = 0; i < len(item); i++)
        {
            var k = item[i][0];

            var v = item[i][1];

            if(v == 0)
                continue;
            
            var cut = 1;
            //根据奖励的数量 切割奖励的份数
            if(v < 10)
                cut = 1;
            else if(v < 100)
                cut = 3;
            else 
                cut = 5;
            num += cut;//显示的fly对象的数量

            var showVal = v/cut;
            //飞起来 等待 一会 接着一起落下
            for(var j = 0; j < cut; j++)
            {
                var flyObj = bg.addsprite(str(k)+".png").size(FLY_WIDTH, FLY_HEIGHT).anchor(50, 100);
                var tar = TarPos.get(k, defaultPos);
                var dis = sqrt(distance(coor2, tar));
                //trace("fly", j, cut);
                //隐藏 等待 出现
                var dir = rand(2);

                var difx1 = rand(getParam("fallX"))+getParam("baseX");
                var dify1 = rand(getParam("fallY"))+getParam("baseY");
                var difx2 = rand(getParam("fallX1"))+getParam("baseX1");
                var dify2 = rand(getParam("fallY1"))+getParam("baseY1");
                
                //150 -300
                //100 100
                if(dir == 1)
                {
                    difx1 = -difx1;
                    difx2 = -difx2;
                }

                flyObj.addaction(sequence(itintto(0, 0, 0, 0), delaytime(waitTime), callfunc(playSound),  itintto(100, 100, 100, 100), sinein(bezierby(
                            getParam("FlyTime")+dis*getParam("disTime"),
                            coor2[0], coor2[1], 
                            coor2[0]+difx1, coor2[1]+dify1, 
                            coor2[0]+difx2, coor2[1]+dify2, 
                            tar[0], tar[1])), callfunc(pickMe)));
                if(j == (cut-1))
                    showVal = v-showVal*j;
var words = flyObj.addlabel(str(showVal), getFont(), 23).pos(FLY_WIDTH, FLY_HEIGHT / 2).anchor(0, 50).color(getParam("FlyObjRed"), getParam("FlyObjGreen"), getParam("FlyObjBlue"));
                //offY += 50;
                waitTime += 200;
            }
        }
    }
    function playSound()
    {
        global.controller.playSound("pick.mp3");
    }
    function pickMe(n)
    {
        n.removefromparent();
        trace("flyOver", num);
        num--;
    }
}
