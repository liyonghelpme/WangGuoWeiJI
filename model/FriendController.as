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
    var sendRequestYet = dict();
    //只在当前有效
    function sendRequest(uid)
    {
        sendRequestYet.update(uid, 1);   
        //global.user.db.put("sendRequestYet", sendRequestYet);
    }
    function checkRequest(uid)
    {
        return sendRequestYet.get(uid);
    }

    /*
    每次登录出现水晶的位置不同
    */
    function setPapayaCrystal()
    {
        var addCrystal = global.user.getValue("addPapayaCryNum");
        var leftCrystal = PAPAYA_CRY - addCrystal;
        var i;
        if(len(showFriend) == 0)
            return;
        for(i = 0; i < len(showFriend); i++)
            showFriend[i].pop("crystal");
        for(i = 0; i < leftCrystal; i++)
        {
            var p = rand(len(showFriend));
            showFriend[p].update("crystal", 1);
        }
    }

    function setRecommandCrystal()
    {
        var addCrystal = global.user.getValue("addFriendCryNum");
        var leftCrystal = FRIEND_CRY - addCrystal;
        var i;
        if(len(recommandFriends) == 0)
            return;
        for(i = 0; i < len(recommandFriends); i++)
        {
            recommandFriends[i].pop("crystal");
        }
        for(i = 0; i < leftCrystal; i++)
        {
            var p = rand(len(recommandFriends));
            recommandFriends[p].update("crystal", 1);
        }
    }

    function getNeiborNum()
    {
        return len(neibors);
    }
    function setNeiborCrystal()
    {
        var addCrystal = global.user.getValue("addNeiborCryNum");
        var neiborMax = global.user.getValue("neiborMax");
        var leftCrystal = neiborMax*NEIBOR_CRY - addCrystal;
        var i;
        var p;
        if(len(neibors) == 0)
            return;
        for(i = 0; i < len(neibors); i++)
        {
            neibors[i].pop("crystal");
        }
        for(i = 0; i < leftCrystal; i += NEIBOR_CRY)
        {
            p = rand(len(neibors));
            neibors[p].update("crystal", NEIBOR_CRY);
        }
        var rem = leftCrystal%3;
        if(rem > 0)
        {
            p = rand(len(neibors));
            neibors[p].update("crystal", rem);
        }
    }


    function helpFriend(uid, k, cry)
    {
        global.user.changeValue("crystal", cry);
        //点击下一个 将会得到下一个好友的数据 需要同步好友的水晶
        //在士兵页面显示水晶的时候加上数量限制
        var i;
        if(k == VISIT_PAPAYA)
        {
            for(i = 0; i < len(showFriend); i++)
            {
                if(showFriend[i]["uid"] == uid)
                {
                    showFriend[i]["crystal"] -= 1;
                    break;
                }
            }
            global.user.changeValue("addPapayaCryNum", 1);
        }
        else if(k == VISIT_NEIBOR)
        {
            for(i = 0; i < len(neibors); i++)
            {
                if(neibors[i]["uid"] == uid)
                {
                    neibors[i]["crystal"] -= 1;
                    break;
                }
            }
            global.user.changeValue("addNeiborCryNum", 1);
        }
        else if(k == VISIT_RECOMMAND)
        {
            for(i = 0; i < len(recommandFriends); i++)
            {
                if(recommandFriends[i]["uid"] == uid)
                {
                    recommandFriends[i]["crystal"] -= 1;
                    break;
                }
            }
            global.user.changeValue("addFriendCryNum", 1);
        }
    }

    function FriendController()
    {
        //getNeibors();
        getPapayaFriend();
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(INITDATA_OVER, this);
    }

    var initNeiborYet = null;
    //uid-->data
    var neibors = null;//邻居uid papayaId name level 等信息 
    function checkNeibor(nid)
    {
        for(var i = 0; i < len(neibors); i++)
        {
            if(neibors[i]["uid"] == nid)
                return neibors[i];
        }
        return null;
    }
    //增加邻居 只有再neibors 数据初始化之后才可以增加邻居
    //需要邻居的mineLevel 以及是否挑战过的信息
    function addNeibor(nei)
    {
        if(neibors != null)
        {
            nei = copy(nei);
            nei["challengeYet"] = 0;
            nei["mineLevel"] = 0;
            neibors.append(nei);
            setNeiborCrystal();
            global.user.db.put("neibors", neibors);
        }
    }
    //删除邻居
    function removeNeibor(nid)
    {
        if(neibors != null)
        {
            for(var i = 0; i < len(neibors); i++)
            {
                if(neibors[i].get("uid") == nid)
                {
                    neibors.pop(i);
                    break;
                }
            }
            global.user.db.put("neibors", neibors);
        }
    }
    //每天第一次登录清空邻居信息
    function firstLogin()
    {
        if(neibors != null)
            for(var i = 0; i < len(neibors); i++)
            {
                neibors[i]["challengeYet"] = 0;
            }
    }

    function getNeiborData(nid)
    {
        for(var i = 0; i < len(neibors); i++)
        {
            if(neibors[i].get("uid") == nid)
            {
                return neibors[i];
            }
        }
        return null;
    }
    //增级邻居空位

    //初始化邻居 
    //邻居关系不能从本地数据库 获取 因为可能对方加我为邻居 但是我不知道
    function getNeibors()
    {
        if(neibors == null)
        {
            //neibors = global.user.db.get("neibors");
            if(neibors == null && initNeiborYet == null)
            {
                initNeiborYet = 0;
                global.httpController.addRequest("friendC/getNeibors", dict([["uid", global.user.uid]]), getNeiborOver, null);
                return null;
            }
            else
                initNeiborYet = 1;
        }
        return neibors;
    }
    function getNeiborOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var temp = con.get("neibors");
            neibors = [];
            for(var i = 0; i < len(temp); i++)
            {
                neibors.append(dict([["uid", temp[i][0]], ["id", temp[i][1]], ["name", temp[i][2]], ["level", temp[i][3]], ["mineLevel", temp[i][4]], ["challengeYet", temp[i][5]] ]));
            }
            setNeiborCrystal();
            global.user.db.put("neibors", neibors);
            initNeiborYet = 1;
        }
    }
    function challengeNeibor(nid)
    {
        for(var i = 0; i < len(neibors); i++)
        {
            if(neibors[i]["uid"] == nid)
            {
                neibors[i]["challengeYet"] = 1;
                break;
            }
        }
        global.user.db.put("neibors", neibors);
    }

    function receiveMsg(param)
    {
        var msid = param[0];
        if(msid == INITDATA_OVER)
        {
            getLocalFriend();
            getNeibors();
        }
    }

    var recommandFriends = null;
    //没有进行数据获取 等级数据不再更新
    var initYet = null;
    function getRecommand()
    {
        if(recommandFriends == null)
        {
            recommandFriends = global.user.db.get("recommand");
            //本地没有数据 且没有进行数据获取
            if(recommandFriends == null && initYet == null)//需要网络获取好友数据 获取结束之后需要设置数据库和内存数据
            {
                //进行数据获取
                initYet = 0;
                global.httpController.addRequest("friendC/getRecommand", dict([["uid", global.user.uid]]), getRecommandOver, null);
                return null;
            }
            else
            {
                setRecommandCrystal();//登录之后好友的水晶分布变化
            }
        }
        return recommandFriends;
    }
    //数据获取结束
    //冒泡排序士兵等级
    function getRecommandOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            var temp = con.get("retUser");
            //id --->papayaId -1 表示该好友 不属于木瓜系列 采用英雄的头像
            //name 好友的名字
            //level 好友的等级
            //uid 我方服务器uid
            recommandFriends = [];
            for(var i = 0; i < len(temp); i++)
            {
                //推荐好友避免出现自己
                if(temp[i][0] == global.user.uid)
                    continue;
                recommandFriends.append(dict([["id", temp[i][3]], ["name", temp[i][2]], ["level", temp[i][1]], ["uid", temp[i][0]]]));
            }
            setRecommandCrystal();

            var flag = 1;
            for(i = len(recommandFriends); i> 0 && flag == 1; i--)
            {
                flag = 0;
                for(var j = 0; j < (i-1); j++)
                {
                    if(recommandFriends[j]["level"] > recommandFriends[j+1]["level"])
                    {
                        var sw = recommandFriends[j];
                        recommandFriends[j] = recommandFriends[j+1];
                        recommandFriends[j+1] = sw;
                        flag = 1;
                    }
                }
            }

            global.user.db.put("recommand", recommandFriends);
            initYet = 1;
        }
    }


    var initFriend = 0;
    var newFriendList = null;
    function update(diff)
    {
        //已经获取木瓜好友 和 我方服务器好友 但是没有进行数据拼装
        if(getPapa == 1 && getInGame == 1 && initFriend == 0)
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
        if(rcode != 0)
        {
            con = json_loads(con);
            //uid name level
            var friUidName = con.get("friends");
            //新加的好友的等级和是否访问过 放置到本地数据库中
            for(var i = 0; i < len(newFriendList); i++)//papayaId
            {
                inGameFriend.update(newFriendList[i], dict([["uid", friUidName[i][0]], ["level", friUidName[i][2]], ["name", friUidName[i][1]], ["id", newFriendList[i]]]));//Fid level
            }
            global.user.db.put("friends", inGameFriend);
            newFriendList = null;
            initFriendList();            
        }
    }
    /*
    function getFid(papayaId, curNum)
    {
        if(inGameFriend.get(papayaId) != null)
            return inGameFriend.get(papayaId).get("uid");
        return recommandFriends[curNum].get("uid");

    }
    function getLevel(papayaId, curNum)
    {
        //木瓜好友页面
        //if(inGameFriend.get(papayaId) != null)
        //    return inGameFriend.get(papayaId).get("level");
        //推荐好友页面
        //return recommandFriends[curNum].get("level");
    }
    */
    /*
    根据木瓜好友和我方服务器数据 获得好友的列表数据 等级 是否访问过
    只显示玩过我们游戏的对方好友
    id name avatar
    */
    function initFriendList()
    {
        var key = papayaFriend.keys();
        for(var i = 0; i < len(key); i++)
        {
            var data = papayaFriend[key[i]];
            if(data.get("isplayer") == 1)//玩家在我方游戏中
            {
                showFriend.append(inGameFriend.get(key[i]));            
            }
        }
        setPapayaCrystal();

        initFriend = 1;
    }
    function getPapayaList()
    {
        if(initFriend == 0)
        {
            return null;
        }
        return showFriend;
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
    //papayaId ---> id name 
    var getPapa = 0;
    function getPapayaOver(rid, rcode, con, param)
    {
//        trace("getPapayaOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            //con = json_loads(con);
//            trace("type con", type(con));
            var flist = con.get("data");
//            trace("flist", len(flist));
            //con.get("data");
            for(var i = 0; i < len(flist); i++)
            {
                papayaFriend.update(flist[i].get("id"), flist[i]);
            }
            getPapa = 1;
        }
    }
    function getFriends(k)
    {
        if(k == VISIT_PAPAYA)
            return showFriend;
        if(k == VISIT_NEIBOR)
            return neibors;
        if(k == VISIT_RECOMMAND)
            return recommandFriends;
        return [];
    }
    //fid level
    //根新ingame 推荐和 邻居好友等级数据
    //
    function updateValue(pid, param)
    {
        var fri = inGameFriend.get(pid);
        fri["uid"] = param[0];
        fri["level"] = param[1];
        fri["name"] = param[2];
        global.user.db.put("friends", inGameFriend);
        if(recommandFriends != null)
        {
            for(var i = 0; i < len(recommandFriends); i++)
            {
                if(recommandFriends[i]["id"] == pid)
                {
                    recommandFriends[i]["level"] = param[1];
                    recommandFriends[i]["name"] = param[2];
                    break;
                }
            }
            global.user.db.put("recommand", recommandFriends);
        }
        
        if(neibors != null)
        {
            for(i = 0; i < len(neibors); i++)
            {
                if(neibors[i]["id"] == pid)
                {
                    neibors[i]["level"] = param[1];
                    neibors[i]["name"] = param[2];
                    break;
                }
            }
            global.user.db.put("neibors", neibors);
        }
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
//        trace("getInGameOver", rid, rcode, con, param);
        if(rcode != 0)
        {
            con = json_loads(con);
            var res = con.get("res");
            for(var i = 0; i < len(res); i++)//inGameFriend 好友数据
            {
                inGameFriend.update(res[0], dict([["uid", res[i][1]], ["level", res[i][2]], ["name", res[i][3]], ["id", res[i][0]]]));//papayaId -->fid lev
            }
            global.user.db.put("friends", inGameFriend);
            getInGame = 1;
        }
    }
}
