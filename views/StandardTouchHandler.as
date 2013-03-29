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
    function StandardTouchHandler()
    {
        //view = v;
    }
    //根据地图尺寸限定最小的缩放比例 
    //设定bg的时候 需要首先prepare 确保可以得到有效的size
    function setBg(b, boundary)
    {
        bg = b;
        bg.prepare();
        trace("setBg", bg, boundary, global, global.director, global.director.disSize);
        var disSize = global.director.disSize;

        scaMin = max(scaMin, max(disSize[0]*100/bg.size()[0], disSize[1]*100/bg.size()[1]));

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
        return 1;
    }
    function checkMove(difx, dify)
    {
        var oldPos = bg.pos();

        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);
        if(leftTop[0] < showBoundary[0] && difx > 0)
            difx = 0;
        if(leftTop[1] < showBoundary[1] && dify > 0)
            dify = 0;
        if(rightBottom[0] > showBoundary[2] && difx < 0)
            difx = 0;
        if(rightBottom[1] > showBoundary[3] && dify < 0)
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
        if(leftTop[0] < showBoundary[0] && difx > 0)
            difx = 0;
        if(leftTop[1] < showBoundary[1] && dify > 0)
            dify = 0;
        if(rightBottom[0] > showBoundary[2] && difx < 0)
            difx = 0;
        if(rightBottom[1] > showBoundary[3] && dify < 0)
            dify = 0;
        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
    }
    function setScaleLimit(minS, maxS)
    {
        scaMin = minS;
        scaMax = maxS;
        trace("setScaleLimit", minS, maxS);
    }
    /*
    需要移动来调整位置 再进行缩放
    */
    function fastScale(sca)
    {
        //trace("scale Min Max", scaMin, scaMax);
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
    //屏幕坐标 到地图坐标的范围转化问题
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

        if(leftTop[0] < showBoundary[0] && sca < 0)  
            sca = 0;
        if(leftTop[1] < showBoundary[1] && sca < 0)
            sca = 0;
        if(rightBottom[0] > showBoundary[2] && sca < 0)
            sca = 0;
        if(rightBottom[1] > showBoundary[3] && sca < 0)
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
        var oldPos = lastPos;
        lastPos = points;
        var difx;
        var dify;
        if(len(points) >= 2)//-1 0 1
        {
            if(len(oldPos) < 2)
            {
                difx = lastPos[1][0]-lastPos[0][0];
                dify = lastPos[1][1]-lastPos[0][1];
                keepMid = [lastPos[0][0]+difx/2, lastPos[0][1]+dify/2]; //旧世界的位置
                return;
            }
            
            //得到缩放比例 scaleFactor
            var oldDis = distance(oldPos[0], oldPos[1]); 
            var newDis = distance(points[0], points[1]);
            var sca = newDis-oldDis;
            if(abs(sca) <= getParam("minScaOff"))
                return;

            //焦点位置 上次手指中心 对应的图片的位置 
            difx = oldPos[1][0]-oldPos[0][0];
            dify = oldPos[1][1]-oldPos[0][1];
            var midOld = [oldPos[0][0]+difx/2, oldPos[0][1]+dify/2]; //旧世界的位置
            
            //如果当前图片的缩放尺寸比世界 小则 缩放中点在世界中心
            var oldScale = bg.scale();

            //执行缩放 只缩放不考虑边界问题 
            //旧的中点在 新的缩放比例下面的 地图中的位置做平移
            var oldInBg = bg.world2node(midOld[0], midOld[1]);
            //新的缩放
            sca = fastScale(sca);
            //焦点在地图中的位置
            var newInBg = bg.node2world(oldInBg[0], oldInBg[1]);
            var move = [midOld[0]-newInBg[0], midOld[1]-newInBg[1]];
            trace("need Move", move, midOld, newInBg, oldScale, sca);
            if(abs(move[0]) > getParam("minMoveOff") || abs(move[1]) > getParam("minMoveOff")) {
                MoveBack(move[0], move[1]);
            }
            adjustMove();
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
    //调整缩放之后的 Move 使Map 在view 中
    function adjustMove()
    {
        var leftTop = bg.node2world(showBoundary[0], showBoundary[1]);
        var rightBottom = bg.node2world(showBoundary[2], showBoundary[3]);
        var difX = 0;
        var difY = 0;
        if(leftTop[0] > 0) {
            difX = -leftTop[0];
        }
        if(leftTop[1] > 0)
            difY = -leftTop[1];
        var disSize = global.director.disSize;
        if(rightBottom[0] < disSize[0])
            difX = disSize[0]-rightBottom[0];
        if(rightBottom[1] < disSize[1])
            difY = disSize[1]-rightBottom[1];
        var oldPos = bg.pos();
        bg.pos(oldPos[0]+difX, oldPos[1]+difY);
    }

    function touchEnded(points)
    {
    }
    
}
