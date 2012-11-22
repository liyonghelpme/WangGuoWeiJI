//由加载页面控制 LoadChallenge 何时初始化数据 当view 显示的时候开始初始化数据
class ChallengeScene extends MyNode
{
    var initOver = 0;  
    var oid = null;
    var papayaId = null;
    var score = null;
    var rank = null;
    var enemies = null;
    var equips = null;
    var kind = null;
    var cityDefense = null;
    var skills = null;
    /*
    挑战对方的uid
    挑战对方的papayaId
    挑战对方的得分
    挑战对方的排名

    如果挑战对方是邻居


    检测战场上所有的怪兽 是否已经下载过 如果没有 则在 loading的时候下载 
    downloadList
    */
    var user = null;
    var dialogController;
    function ChallengeScene(o, p, s, r, k, par)
    {
        kind = k;
        user = par;
        oid = o;
        papayaId = p;
        score = s;
        rank = r;
        bg = node();
        init();
        dialogController = new DialogController(this);
        addChild(dialogController);
        dialogController.addCmd(dict([["cmd", "challengeLoading"], ["kind", kind]]));
    }
    var needDownload = [];
    //我方士兵 地方士兵
    function checkSolPic()
    {
        //全局已经在下载图片了 阻止这里下载图片
        if(global.pictureManager.download)
        {
            finishLoadPic = 1;
            return 1;
        }
        //我方士兵
        var mySolIds = global.user.getAllSoldierKinds();
        var allKind = ["m", "fm", "a", "fa"];
        var k;
        //敌方类型
        if(enemies != null)
        {
            for(k = 0; k < len(enemies); k++)
            {
                mySolIds.update(enemies[k]["id"], 1);
            }
        }
        if(kind == CHALLENGE_MON)
        {
            for(k = 0; k < len(user["mon"]); k++)
            {
                mySolIds.update(user["mon"][k]["id"], 1);
            }
        }
        //需要预测怪兽类型 
        if(kind == CHALLENGE_TRAIN)
        {
        }

        mySolIds = mySolIds.keys();
        for(k = 0; k < len(mySolIds); k++)
        {
            for(var i = 0; i < len(allKind); i++)
            {
                var name = "soldier"+allKind[i]+str(mySolIds[k])+".plist";
                var ret0 = c_res_exist(name);
                if(!ret0)
                {
                    needDownload.append(name);
                }
                name = "soldier"+allKind[i]+str(mySolIds[k])+".png";
                var ret1 = c_res_exist(name);
                if(!ret1)
                {
                    needDownload.append(name);
                }
            }

            var solAttackEffect = magicAnimate.get(mySolIds[k]);
            //没有攻击特效的地方士兵 不用下载图片
            if(solAttackEffect != null)
            {
                for(i = 0; i < len(solAttackEffect); i++)
                {
                    var ani = solAttackEffect[i];
                    if(ani != -1)
                    {
                        var pics = pureMagicData.get(ani)[0];
                        if(len(pics) > 0)
                        {
                            name = "s"+str(ani)+"e.plist";
                            ret0 = c_res_exist(name);
                            if(!ret0)
                            {
                                needDownload.append(name);
                            }
                            name = "s"+str(ani)+"e.png";
                            ret1 = c_res_exist(name);
                            if(!ret1)
                                needDownload.append(name);
                        }
                    }
                }
            }
        }

        if(len(needDownload) > 0)
        {
            return 0;
        }

        finishLoadPic = 1;
        return 1;
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
        dialogController.update(0);//立即显示等待页面
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
    var download = 0;
    function startDownload()
    {
        if(download)
            return;
        download = 1;
    }
    var waitTime = 0;
    var inConnect = 0;
    var finishLoadPic = 0;
    function update(diff)
    {
        if(finishLoadPic && finishLoadData)
        {
            initOver = 1;
            return;
        }

        waitTime += diff;
        if(waitTime >= getParam("downloadTime") && !inConnect)
        {
            waitTime = 0;
            if(len(needDownload) > 0)
            {
                var pic = needDownload.pop(0);
                inConnect = 1;
                request(pic, 0, onGet, null);
            }
            else
            {
                //global.myAction.removeAct(this);
                finishLoadPic = 1;
            }
        }
    }
    function onGet()
    {
        inConnect = 0;
    }

    var finishLoadData = 0;
    function initData()
    {
        //if(oid == global.user.uid)
        //    global.httpController.addRequest("challengeC/challengeSelf", dict([["uid", global.user.uid], ["oid", oid]]), getDataOver, null);
        if(kind == CHALLENGE_FRI)
            global.httpController.addRequest("challengeC/challengeOther", dict([["uid", global.user.uid], ["oid", oid]]), getDataOver, null);
        else if(kind == CHALLENGE_NEIBOR)
            global.httpController.addRequest("friendC/challengeNeibor", dict([["uid", global.user.uid], ["fid", oid]]), getDataOver, null); 
        else if(kind == CHALLENGE_FIGHT)
        {
            var arenaKind = user.get("kind");
            var fData = getData(FIGHT_COST, arenaKind);
            var cost = getCost(FIGHT_COST, arenaKind);
            trace("challengeFight", arenaKind, fData, cost);
            cost = multiScalar(cost, fData.get("attackCost"));//攻击花费

            global.httpController.addRequest("fightC/attackArena", dict([["uid", global.user.uid], ["oid", oid], ["crystal", cost.get("crystal", 0)], ["gold", cost.get("gold", 0)]]), getDataOver, null); 
        }
        else if(kind == CHALLENGE_DEFENSE)
        {
            global.httpController.addRequest("fightC/defenseOther", dict([["uid", global.user.uid], ["oid", oid]]), getDataOver, null); 
        }
        else if(kind == CHALLENGE_TRAIN)
        {
            //initOver = 1;
            finishLoadData = 1;
        }
        else if(kind == CHALLENGE_MON)
        {
            //initOver = 1;
            finishLoadData = 1;
        }
        //需要下载

    }
    //敌方士兵 enemies  monsters
    function loadingCallback()
    {
        var argument;
        argument = dict([["soldier", enemies], ["kind", kind], ["oid", oid], ["papayaId", papayaId], ["score", score], ["rank", rank], ["cityDefense", cityDefense], ["skills", skills], ["equips", equips], ["user", user]]);
        if(kind == CHALLENGE_FRI)
        {
            argument.update("big", 5);
            argument.update("small", 0);
            global.director.replaceScene(new BattleScene(argument));
            //5, 0, enemies, CHALLENGE_FRI, [oid, papayaId, score, rank, cityDefense, skills, null], equips));
        }
        else if(kind == CHALLENGE_NEIBOR)
        {
            argument.update("big", 5);
            argument.update("small", 0);
            global.director.replaceScene(new BattleScene(argument));
            //5, 0, enemies, CHALLENGE_NEIBOR, [oid, papayaId, score, rank, cityDefense, skills, null], equips));
        }
        else if(kind == CHALLENGE_FIGHT)//挑战敌方士兵 类似于 挑战邻居 但是奖励不同
        {
            argument.update("big", 5);
            argument.update("small", 0);
            global.director.replaceScene(new BattleScene(argument));
            //5, 0, enemies, CHALLENGE_FIGHT, [oid, papayaId, score, rank, cityDefense, skills, user], equips));
        }
        else if(kind == CHALLENGE_DEFENSE)
        {
            argument.update("big", 5);
            argument.update("small", 0);
            global.director.replaceScene(new BattleScene(argument));
            //5, 0, enemies, CHALLENGE_DEFENSE, [oid, papayaId, score, rank, cityDefense, skills, user], equips));
        }
        else if(kind == CHALLENGE_TRAIN)
        {
            argument.update("big", user["bigLevel"]);
            argument.update("small", 0);
            argument.update("double", user["doubleExp"]);
            argument.update("singleSid", user["soldier"]);
            argument.update("difficult", user["curChoose"]);
            
            global.director.replaceScene(new BattleScene(argument));
        }
        else if(kind == CHALLENGE_MON)
        {
            argument.update("big", user["big"]);
            argument.update("small", user["small"]);
            argument.update("soldier", user["mon"]);
            global.director.replaceScene(new BattleScene(argument));
        }
    }
    /*
    生成随机的布局
    按顺序 按个数 挨个放置 类似于放置怪兽

    sid == -1 表示是敌方的士兵
    士兵的基本属性 满血满魔
    sid=-1 kind level addAttack addDefense addAttackTime addDefenseTime

    怪兽 addAttack全部为0


    问题-----> 通知loadingView 初始化结束---->
    loadingView ---->等待足够长时间----> 切换场景
    */
    function getDataOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            cityDefense = con.get("cityDefense");
            enemies = con.get("soldiers");
            equips = con.get("equips");
            skills = con.get("skills");

            if(con.get("id") == 0)
                global.director.popScene();
            //挑战好友 挑战邻居获得技能
            else if(kind == CHALLENGE_FRI){
                global.user.addChallengeRecord(oid);
            }
            else if(kind == CHALLENGE_NEIBOR)
            //根据邻居的uid 得到邻居的数据 getNeiborData
            {
                global.friendController.challengeNeibor(oid);
            }
            //需要修改 挑战数据 数据 存储在 场景中
            else if(kind == CHALLENGE_FIGHT)//挑战敌方士兵 类似于 挑战邻居 但是奖励不同
            {
            }
            else if(kind == CHALLENGE_DEFENSE)
            {
            }
            //initOver = 1;
            finishLoadData = 1;
        }
        
        //我方士兵 地方士兵
        if(!checkSolPic())
        {
            startDownload();
        }
    }
}
