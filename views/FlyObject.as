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
                //var rx = rand(40);
                //var ry = rand(40); 
                //trace("fly", j, cut);
                //隐藏 等待 出现
                flyObj.addaction(sequence(itintto(0, 0, 0, 0), delaytime(waitTime), itintto(100, 100, 100, 100), sinein(bezierby(
                            1500+dis*25,
                            coor2[0], coor2[1], 
                            coor2[0]+150, coor2[1]-300, 
                            coor2[0]+100, coor2[1]+100, 
                            tar[0], tar[1])), callfunc(pickMe)));
                if(j == (cut-1))
                    showVal = v-showVal*j;
                var words = flyObj.addlabel(str(showVal), null, 22).pos(FLY_WIDTH, FLY_HEIGHT/2).anchor(0, 50).color(78, 39, 4);
                //offY += 50;
                waitTime += 200;
            }
        }
    }
    function pickMe(n)
    {
        n.removefromparent();
        trace("flyOver", num);
        num--;
        if(num == 0)
        {
            removeSelf();
            global.user.doAdd(cost);
            if(callback != null)
                callback();       
        }
    }
}
