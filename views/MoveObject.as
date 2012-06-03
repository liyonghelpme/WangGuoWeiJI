class MoveObject
{
    var speed;
    var degree;
    function MoveObject()
    {
        degree = 100;
    }
    /*
    必须行走到目的位置
    按照横向 纵向的移动方式行走
    */
    function moveToTar(s, t, diff)
    {
        var difx = t[0]-s[0];
        var dify = t[1]-s[1];
        var movx = 0;
        var movy = 0;
        if(abs(difx) > abs(dify))
            movx = speed*diff*Sign(difx)/100;
        else
            movy = speed*diff*Sign(dify)/100;
        if(abs(movx) > abs(difx))
            movx = difx;
        if(abs(movy) > abs(dify))
            movy = dify;
        return [movx, movy, difx, dify];

    }
    /*
    当源和目的的距离小于一定的值则停止移动
    按照分量的方式进行行走
    */
    function MoveToPos(s, t, diff)
    {
        var difx = t[0]-s[0];
        var dify = t[1]-s[1];

        var dist = distance(s, t);
        if(dist <= 64)
        {
            return [0, 0, 0, 0, 100];
        }
        var speX = speed*difx/dist;
        var speY = speed*dify/dist;
        var movx = speX*diff/100;
        var movy = speY*diff/100;
        if(abs(movx) > abs(difx))
            movx = difx;
        if(abs(movy) > abs(dify))
            movy = dify;
        if(difx > 0)
            degree = 100;
        else
            degree = -100;

        return [movx, movy, difx, dify, degree];
    }
        
}
