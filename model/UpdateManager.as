class UpdateManager
{
    var dirty = 0;
    function UpdateManager()
    {
        global.timer.addTimer(this);
    }
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= 60000)
        {
            passTime = 0;
            if(dirty == 1)
            {
                dirty = 0;
                global.httpController.addRequest("goods/updateUserData", dict([["uid", global.user.uid], ["resource", global.user.resource]], null, null));
            }
        }
    }
    function setDirty()
    {
        dirty = 1;
    }
}

