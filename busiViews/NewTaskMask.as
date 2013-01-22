/*
用于新手任务中 控制屏幕 防止其他点击
*/
class NewTaskMask extends MyNode
{
    //一个永久Mask 用于 整体屏蔽 touch事件
    //新的mask用于接受touch事件
    var inDelegate;
    var delegate;//node
    var callback;
    function NewTaskMask(d, cb)
    {
        delegate = d;
        callback = cb;
        trace("NewTaskMask", d, cb);
        bg = node().size(global.director.disSize);
        init();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function setDelegate(d, c)
    {
        trace("setDelegate", d, c);
        delegate = d;
        callback = c;
        inDelegate = 0;
    }
    function update(diff)
    {
    }
    function touchBegan(n, e, p, x, y, points)
    {
        trace("touchBegan", delegate, callback);
        if(delegate == null)
            return;
        inDelegate = 0;
        var cp = delegate.world2node(x, y);
        if(cp[0] > 0 && cp[0] < delegate.size()[0] && cp[1] > 0 && cp[1] < delegate.size()[1])
        {
            var tempDelegate = delegate;
            var tempCallback = callback;
            //在回调之前 设置 因为可能回调调整代理
            setDelegate(null, null);
            tempCallback();
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n ,e, p, x, y, points)
    {
    }
    //新手任务完成的时候删除mask
    function receiveMsg(param)
    {
        trace("NewTaskMask receiveMsg");
        var msgId = param[0];
        if(msgId == FINISH_NEW_TASK)
        {
            trace("remove NewTaskMask", delegate, callback, this);
            removeSelf();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(FINISH_NEW_TASK, this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(FINISH_NEW_TASK, this);
        super.exitScene();
    }
}
