class User
{
    var resource;
    var updateList;
    function User()
    {
        resource = dict([["silver", 0], ["gold", 0], ["crystal", 0]]);
        updateList = [];
    }
    function setValue(key, value)
    {
        resource.update(key, value);
        for(var i = 0; i < len(updateList); i++)
        {
            updateList[i].updateValue(resource);
        }
    }
    function changeValue(key, add)
    {
        var v = resource.get(key);
        v += add;
        setValue(key, v);
    }
    function getValue(key)
    {
        return resource.get(key);
    }
    function addListener(obj)
    {
        updateList.append(obj); 
    }
    function removeListener(obj)
    {
        updateList.remove(obj);
    }
    function checkCost(cost)
    {
        var buyable = dict([["ok", 1]]);
        var its = cost.items();
        for(var i = 0; i < len(its); i++)
        {
            var key = its[i][0];
            var value = its[i][1];
            var cur = resource.get(key);
            if(cur < value)
            {
                buyable.update("ok", 0);
                buyable.update(key, value-cur);
            }
        }
        return buyable;
    }
    function doCost(cost)
    {
        var its = cost.items();
        for(var i = 0; i < len(its); i++)
        {
            var key = its[i][0];
            var value = its[i][1];
            changeValue(key, -value);
        }
    }
}
