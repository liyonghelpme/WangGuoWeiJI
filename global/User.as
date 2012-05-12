class User
{
    var resource;
    function User()
    {
        resource = dict([["silver", 0], ["gold", 0], ["crystal", 0]]);
    }
    function changeValue(key, add)
    {
        var v = resource.get(key);
        v += add;
        resource.update(key, v);
    }
}
