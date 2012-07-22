/*
在登录的时候获取一定的好友数据， 拖动刷新之后显示后续的好友


根据isplayer 判定好友的显示顺序
需要从我方服务器上获取某些好友的等级


本地获取好友列表----> 失败 从我方服务器获取好友
木瓜服务器获得好友---->

比较我方好友和木瓜服务器好友---->木瓜有新的好友加入到我方服务器中--->更新好友等级0 访问过本地数据为0


访问好友更新好友的本地等级数据

判断好友是否访问过，判断好友的等级，每天第一次登录自动清空本地数据库的好友状态数据


每天第一次登录:更新状态 访问状态
访问用户时更新状态: 访问状态 等级

*/
class FriendController 
{
    var papayaFriend = dict();//木瓜好友
    var inGameFriend = dict();//游戏内好友
    //初始化用户数据之后 接着初始化好友数据
    var curPapOffset = 0;
    var showFriend = [];
    function FriendController()
    {
        getPapayaFriend();
        //getPapayaFriend();
        //getInGameFriend();
        //getLocalFriend();
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }
    function receiveMsg(param)
    {
        trace("initOver initFriend");
        var msid = param[0];
        if(msid == INITDATA_OVER)
        {
            //getInGameFriend();
            getLocalFriend();
        }
    }

    var initFriend = 0;
    var newFriendList = null;
    function update(diff)
    {
        if(getPapa == 1 && getInGame == 1)
        {
            //papayaId
            var papaSet = set(papayaFriend.keys());
            var inGameSet = set(inGameFriend.keys());
            var newFriend = papaSet.difference(inGameSet);
            if(len(newFriend) > 0)
            {
                var nf = [];
                nf.extend(newFriend);
                newFriendList = nf;
                global.httpController.addRequest("friendC/addFriend", dict([["uid", global.user.uid], ["flist", nf]]), addFriendOver, null);
            }
            else
            {
                initFriendList();
            }
            //trace("initFriendOver", len(showFriend), len(papayaFriend), len(inGameFriend));
            global.timer.removeTimer(this);
        }
    }
    function addFriendOver(rid, rcode, con, param)
    {
        trace("addFriend", rid, rcode, con, param);
        if(rcode != 0)
        {
            //新加的好友的等级和是否访问过 放置到本地数据库中
            for(var i = 0; i < len(newFriendList); i++)//papayaId
            {
                inGameFriend.update(newFriendList[i], [-1, 0]);//Fid level
            }
            global.user.db.put("friends", inGameFriend);
            newFriendList = null;
            initFriendList();            
        }
        trace("initFriendOver", len(showFriend), len(papayaFriend), len(inGameFriend));
    }
    function cmpLev(a, b)
    {
    }
    function getLevel(papayaId)
    {
        return inGameFriend.get(papayaId)[1];
    }
    /*
    根据木瓜好友和我方服务器数据 获得好友的列表数据 等级 是否访问过
    */
    function initFriendList()
    {
        var key = papayaFriend.keys();
        //var inviteFriend = [];
        for(var i = 0; i < len(key); i++)
        {
            var data = papayaFriend[key[i]];
            if(data.get("isplayer") == 1)
                showFriend.append(data);            
        }
        trace("initFriend finish", initFriend);
        initFriend = 1;
    }
    //本地数据存储记录在远程服务器上的好友
    //如何从我们服务器 推送一个好友是否玩了游戏
    function getLocalFriend()
    {
        var localFriends = global.user.db.get("friends");
        if(localFriends == null)
        {
            getInGameFriend();
        }
        else 
        {
            inGameFriend = localFriends;
            getInGame = 1;
        }
    }
    function getPapayaFriend()
    {
        ppy_query("list_friends", null, getPapayaOver);
    }
    var getPapa = 0;
    function getPapayaOver(rid, rcode, con, param)
    {
        trace("getPapayaOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            //con = json_loads(con);
            trace("type con", type(con));
            var flist = con.get("data");
            trace("flist", len(flist));
            //con.get("data");
            for(var i = 0; i < len(flist); i++)
            {
                papayaFriend.update(flist[i].get("id"), flist[i]);
            }
            getPapa = 1;
        }
    }
    //fid level
    function updateValue(pid, param)
    {
        var fri = inGameFriend.get(pid);
        fri[0] = param[0];
        fri[1] = param[1];
        global.user.db.put("friends", inGameFriend);
    }
    function getInGameFriend()
    {
        global.httpController.addRequest("friendC/getMyFriend", dict([["uid", global.user.uid]]), getInGameOver, null);
    }
    /*
    需要知道 哪些好友没有在我们的服务器中
    需要随机的给用户提供一些好友
    */
    var getInGame = 0;
    function getInGameOver(rid, rcode, con, param)
    {
        trace("getInGameOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            con = json_loads(con);
            var res = con.get("res");
            for(var i = 0; i < len(res); i++)
            {
                inGameFriend.update(res[0], [res[1], res[2]]);//papayaId -->fid lev
            }
            global.user.db.put("friends", inGameFriend);
            getInGame = 1;
        }
    }
}
