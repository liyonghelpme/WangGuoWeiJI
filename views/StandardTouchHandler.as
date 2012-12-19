//Only a interface 
class StandardTouchHandler
{
    var showBoundary;
    var bg;
    var lastPos;

    var scaMax = 150;
    var scaMin = 50;
    //var keepDistance;
    var keepMid;
    //var view;
    var touchEvents = [];
    function StandardTouchHandler()
    {
        //view = v;
    }
    function setBg(b, boundary)
    {
        bg = bg;
        if(boundary == null)
            showBoundary = [0, 0, bg.size()[0], bg.size()[1]];
        else
            showBoundary = boundary;
    }

    function enterScene()
    {
        //super.enterScene();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, tBegan);
        bg.setevent(EVENT_MOVE, tMoved);
        bg.setevent(EVENT_UNTOUCH, tEnded);
        //global.touchManager.addStandard(this);
    }
    function tBegan(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchBegan(newPos);
    }
    function tMoved(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchMoved(newPos); 
    }
    function tEnded(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchEnded(newPos);
    }
    function touchBegan(points)
    {
        lastPos = points;
        touchEvents = [[points, time()]];
        if(len(points) >= 2)//-1 0 1
        {
            //keepDistance = distance(points[0], points[1]);
            var difx = points[1][0]-points[0][0];
            var dify = points[1][1]-points[0][1];
            keepMid = [points[0][0]+difx/2, points[0][1]+dify/2];
        }
        //else
            //keepDistance = 0;
        return 1;
    }
    function checkMove(difx, dify)
    {
        var oldPos = bg.pos();

        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);
        if(leftTop[0] < 0 && difx > 0)
            difx = 0;
        if(leftTop[1] < 0 && dify > 0)
            dify = 0;
        if(rightBottom[0] > bg.size()[0] && difx < 0)
            difx = 0;
        if(rightBottom[1] > bg.size()[1] && dify < 0)
            dify = 0;
        bg.pos(oldPos);
        return [difx, dify];
    }
    function MoveBack(difx, dify)
    {
        var oldPos = bg.pos();

        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);
        if(leftTop[0] < 0 && difx > 0)
            difx = 0;
        if(leftTop[1] < 0 && dify > 0)
            dify = 0;
        if(rightBottom[0] > bg.size()[0] && difx < 0)
            difx = 0;
        if(rightBottom[1] > bg.size()[1] && dify < 0)
            dify = 0;
        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
    }
    /*
    需要移动来调整位置 再进行缩放
    */
    function fastScale(sca)
    {
        var oldScale = bg.scale();
        if(oldScale[0]+sca >= scaMax || oldScale[0]+sca <= scaMin)
            return 0;
        bg.scale(oldScale[0]+sca, oldScale[1]+sca);
        return sca;
    }
    function scaleToMax(sm)
    {   
        bg.scale(sm); 
    }
    function scaleToOld(oldSca, oldPos)
    {
        bg.pos(oldPos);
        bg.scale(oldSca);
    }
    function ScaleBack(sca)
    {
        var oldScale = bg.scale();

        if(oldScale[0] >= scaMax && sca > 0)
            return 0;
        if(oldScale[0] <= scaMin && sca < 0)
            return 0;

        bg.scale(oldScale[0]+sca, oldScale[1]+sca);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);

        if(leftTop[0] < 0 && sca < 0)  
            sca = 0;
        if(leftTop[1] < 0 && sca < 0)
            sca = 0;
        if(rightBottom[0] > bg.size()[0] && sca < 0)
            sca = 0;
        if(rightBottom[1] > bg.size()[1] && sca < 0)
            sca = 0;
        bg.scale(oldScale[0]+sca, oldScale[1]+sca);
        return sca;
    }
    //时间过滤在40ms以上才算稳定
    //保持中点不变只是缩放而已
    //除非越界
    //多加一次运算 效果稳定多了
    function touchMoved(points)
    {
        var now = time();
        if(now - touchEvents[len(touchEvents)-1][1] > 40)
        {
            touchEvents.append([points, now]);
            if(len(touchEvents) > 2)
                touchEvents.pop(0);
        }

        var oldPos = lastPos;
        lastPos = points;
        var difx;
        var dify;
        if(len(points) >= 2)//-1 0 1
        {
            if(len(oldPos) < 2)
            {
                //keepDistance = distance(points[0], points[1]);
                difx = lastPos[1][0]-lastPos[0][0];
                dify = lastPos[1][1]-lastPos[0][1];
                keepMid = [lastPos[0][0]+difx/2, lastPos[0][1]+dify/2]; //旧世界的位置
                return;
            }
            //var oldDis = keepDistance;
            //keepDistance = (keepDistance*80+distance(points[0], points[1])*20)/100;
            //var newDis = keepDistance;
            
            var oldDis = distance(oldPos[0], oldPos[1]); 
            var newDis = distance(points[0], points[1]);
            var sca = newDis-oldDis;
            //if(abs(sca) < 10)//小于一定距离不缩放
            //    return;

            //var move = midMove(oldPos, points);

            difx = oldPos[1][0]-oldPos[0][0];
            dify = oldPos[1][1]-oldPos[0][1];
            var midOld = [oldPos[0][0]+difx/2, oldPos[0][1]+dify/2]; //旧世界的位置

            var oldInBg = bg.world2node(midOld[0], midOld[1]);
            
            /*
            var midOld = keepMid;
            var oldInBg = bg.world2node(keepMid[0], keepMid[1]);
            difx = lastPos[1][0]-lastPos[0][0];
            dify = lastPos[1][1]-lastPos[0][1];
            var newMid = [lastPos[0][0]+difx/2, lastPos[0][1]+dify/2]; //新世界的位置
            keepMid[0] = (keepMid[0]*80+newMid[0]*20)/100;
            keepMid[1] = (keepMid[1]*80+newMid[1]*20)/100;
            */

            var oldScale = bg.scale();
            /*
            计算缩放之后需要移动的量
            可能会有无意义的移动
            */
            sca = fastScale(sca);
            var newInBg = bg.node2world(oldInBg[0], oldInBg[1]);
            var move = [midOld[0]-newInBg[0], midOld[1]-newInBg[1]];
            MoveBack(move[0], move[1]);

            bg.scale(oldScale[0], oldScale[1]);
            sca = ScaleBack(sca);

            //计算的缩放结果 新缩放下的move 结果修正
            newInBg = bg.node2world(oldInBg[0], oldInBg[1]);
            move = [midOld[0]-newInBg[0], midOld[1]-newInBg[1]];
            MoveBack(move[0], move[1]);
        }
        else if(len(points) >= 1)
        {
            var leftFinger = 0;
            if(points[0] == null)
                leftFinger = 1;
            difx = points[leftFinger][0]-oldPos[leftFinger][0];
            dify = points[leftFinger][1]-oldPos[leftFinger][1];
            MoveBack(difx, dify);
        }
    }
    function touchEnded(points)
    {
        if(len(touchEvents) >= 2)
        {
            var t0 = touchEvents[0];
            var t1 = touchEvents[1];

            var passTime = t1[1]-t0[1];
            //没有两根手指 放下又抬起
            if(t1[0][0] != null && t0[0][0] != null)
            {
                var diffX = t1[0][0][0]-t0[0][0][0];//第一个touch组的第一个点的x坐标
                var diffY = t1[0][0][1]-t0[0][0][1];
                if(diffX*diffX+diffY*diffY >= getParam("minMoveDis"))
                {
                    var finishMX = diffX*getParam("touchInertiaTime")/passTime;
                    var finishMY = diffY*getParam("touchInertiaTime")/passTime;
                    var expMX = finishMX/6.931;
                    var expMY = finishMY/6.931;//expout initSpeed
                    var mv = checkMove(expMX, expMY);
                    bg.addaction(expout(moveby(getParam("touchInertiaTime"), mv[0], mv[1])));
                }
            }
        }
    }
    
}
