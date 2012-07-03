class FlyObject extends MyNode
{
    var callback;
    var num;
    var cost;
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
        callback = cb;
        num = 0;
        cost = c;
        bg = node();

        var TarPos = dict([["silver", [297, 460]], ["crystal", [253, 460]], ["gold", [550, 460]], ["exp", [196, 427]]]);
        var bsize = obj.size();
        var coor2 = obj.node2world(bsize[0]/2, bsize[1]/2);

        var item = cost.items();
        trace("flyObject", cost);
        var offY = 0;
        for(var i = 0; i < len(item); i++)
        {
            var k = item[i][0];
            var v = item[i][1];
            if(v == 0)
                continue;
            num++;

            var flyObj = bg.addsprite(str(k)+".png").size(FLY_WIDTH, FLY_HEIGHT);
            var tar = TarPos.get(k);
            var dis = sqrt(distance(coor2, tar));
            flyObj.addaction(sequence(sinein(bezierby(
                        500+dis*25,
                        coor2[0], coor2[1]+offY, 
                        coor2[0]+100, coor2[1]-100, 
                        coor2[0]+100, coor2[1]+100, 
                        tar[0], tar[1])),callfunc(pickMe)));
            var words = flyObj.addlabel(str(v), null, 22).pos(FLY_WIDTH, FLY_HEIGHT/2).anchor(0, 50).color(78, 39, 4);
            offY += 50;
        }
    }
    function pickMe()
    {
        trace("flyOver", num);
        num--;
        if(num == 0)
        {
            removeSelf();
            global.user.doAdd(cost);
            callback();       
        }
    }
}
