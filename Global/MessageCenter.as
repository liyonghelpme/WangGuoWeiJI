/*
callback 需要实现 receiveMsg 接口
callback 在接受消息的时候不能删除自身否则会出现下一个对象没有接受到消息的可能 因为数组长度变了
而删除操作直接发生


可以存在持久型消息：
    消息一直存在， 要么发现接受者 立即处理， 要么等待， 直到接受者 注册的时候 获取消息
*/
class MessageCenter
{
    var callbacks;
    function MessageCenter()
    {
        callbacks = dict();//MSG_ID callBacks[]
    }
    //应该避免在相应消息的时候删除消息代理
    //而应该在退出场景的时候删除消息代理, 但是可能存在某个对象处理消息----> 导致另一个对象退出场景---->
    //消息应该包含自身的类型
    function sendMsg(msgId, param)
    {
        var recs = callbacks.get(msgId, []);
        for(var i = 0; i < len(recs); i++)
        {
            recs[i].receiveMsg([msgId, param]);
        }
    }

    //消息只能被第一个对象接受后面的对象不处理
    function sendOneMsg(msgId, param)
    {
        var recs = callbacks.get(msgId, []);
        for(var i = 0; i < len(recs); i++)
        {
            recs[i].receiveMsg([msgId, param]);
            break;
        }
    }

    function checkCallback(msgId)
    {
        var res = callbacks.get(msgId, null);
        if(res == null || len(res) == 0)
            return 0;
        return 1;
    }
    function registerCallback(msgId, obj)
    {
        var recs = callbacks.get(msgId, []);
        recs.append(obj);
        callbacks.update(msgId, recs);
    }
    function removeCallback(msgId, obj)
    {
        var recs = callbacks.get(msgId, []);
        for(var i = 0; i < len(recs); i++)
        {
            if(recs[i] == obj)
            {
                recs.remove(obj);
                break;
            }
        }
    }
}
