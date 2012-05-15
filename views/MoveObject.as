class MoveObject
{
    var speed;
    var degree;
    function MoveObject()
    {
        degree = 100;
    }
    function MoveToPos(s, t, diff)
    {
        var difx = t[0]-s[0];
        var dify = t[1]-s[1];

        var dist = distance(s, t);
        if(dist <= 30)
        {
            return [0, 0, 0, 0, 100];
        }
        /*
        if(abs(difx) > abs(dify))
        {
            difx = Sign(difx)*dist;
            dify = 0;
        }
        else
        {
            difx = 0;
            dify = Sign(dify)*dist;
        }
        */
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
