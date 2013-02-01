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

    可以实现类似于堆栈的环境变量压入---》argument context上下文
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
    //新手任务闯关的怪兽 和 士兵不同
    //color 怪兽增加一个属性color 1 为怪兽默认为 1
    var pictureManager;
    function checkSolPic()
    {
        var k;
        var downloadList = [];
        //新手任务 阶段 
        //闯关
        //挑战
        pictureManager = new PictureManager();
        if(global.taskModel.checkInNewTask())
        {
            if(kind == CHALLENGE_MON)
                enemies = getAllNew(0, 0);
            else if(kind == CHALLENGE_FRI)
                enemies = getAllNew(0, 1);

            for(k = 0; k < len(enemies); k++)
            {
                downloadList.append(enemies[k]["id"]);
            }

            pictureManager.downloadList = downloadList;
            pictureManager.startDownload(0, finishDownload);
            return 0;
        }


        var allSoldier = global.user.getAllSoldierKinds();
        var mySolKey = allSoldier.keys();
        downloadList = mySolKey;


        //敌方类型
        if(enemies != null)
        {
            for(k = 0; k < len(enemies); k++)
            {
                downloadList.append(enemies[k]["id"]);
            }
        }
        if(kind == CHALLENGE_MON)
        {
            for(k = 0; k < len(user["mon"]); k++)
            {
                downloadList.append(user["mon"][k]["id"]);
            }
        }

        trace("checkSolPic", downloadList);
        pictureManager.downloadList = downloadList;
        pictureManager.startDownload(0, finishDownload);
        return 0;
    }
    function finishDownload()
    {
        trace("finishDownload");
        finishLoadPic = 1;
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
    var finishLoadPic = 0;
    function update(diff)
    {
        if(finishLoadPic && finishLoadData)
        {
            initOver = 1;
            return;
        }
    }

    var finishLoadData = 0;
    function initData()
    {
        //新手任务阶段的闯关怪兽 和 我方布局是确定的由策划设计 
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
        else if(kind == CHALLENGE_MON)
        {
            finishDataAndStartPic();
        }
        else if(kind == CHALLENGE_OTHER)
        {
            //新手任务阶段 挑战其它人
            if(global.taskModel.checkInNewTask()) {
                newChallenge();
            } else if(getParam("debugChallenge")) {
                debugChallange();           
            } else
                global.httpController.addRequest("challengeC/getRandChallenge", dict([["uid", global.user.uid]]), getRandChallenge, null);
        }
        else if(kind == CHALLENGE_REVENGE)
        {
            global.httpController.addRequest("challengeC/getRevenge", dict([["uid", global.user.uid], ["oid", user["uid"]]]), getRevenge, null);
        }
    }

    function debugChallange()
    {
        trace("debugChallange");
        kind = CHALLENGE_MON;
        user = dict([["big", 0], ["small", 0], ["mon", getDebugSoldier()]]);//调试怪兽的数量
        finishDataAndStartPic();
    }
    function getRevenge(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con["id"] == 1)
            {
                kind = CHALLENGE_FRI;
                user = con["user"];
                oid = user["uid"];
                papayaId = user["id"];
                score = user["score"];
                rank = user["rank"];
                user["revenge"] = 1;

                global.httpController.addRequest("challengeC/challengeOther", dict([["uid", global.user.uid], ["oid", oid]]), getDataOver, null);
            }
            else
            {
                global.director.popScene();
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noTarget", null), [100, 100, 100], null));
            }
        }
    }
    function newChallenge()
    {
        kind = CHALLENGE_FRI;
        user = dict([["uid", -1], ["id", 0], ["score", 0], ["rank", 0], ["name", "Enemy"], ["level", 0], ["cityDefense", 10], ["silver", 0], ["crystal", 0]]);
        oid = user["uid"];
        papayaId = user["id"];
        score = user["score"];
        rank = user["rank"];
        cityDefense = 10;
        enemies = getAllNew(0, 1);
        equips = dict();
        skills = dict();

        finishDataAndStartPic();
    }
    //每天最多挑战120个？
    function getRandChallenge(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con["id"] == 1)
            {
                kind = CHALLENGE_FRI;
                user = con["user"];
                oid = user["uid"];
                papayaId = user["id"];
                score = user["score"];
                rank = user["rank"];

                global.httpController.addRequest("challengeC/challengeOther", dict([["uid", global.user.uid], ["oid", user["uid"]]]), getDataOver, null);
            }
            else
            {
                //获取挑战用户数据失败
                global.director.popScene();
                global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("noTarget", null), [100, 100, 100], null));
            }
        }
    }

    function finishDataAndStartPic()
    {
        finishLoadData = 1;
        checkSolPic();
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
            if(global.taskModel.checkInNewTask())
            {
                argument.udpate("soldier", getAllNew(0, 1));
            }
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
        }
        else if(kind == CHALLENGE_DEFENSE)
        {
            argument.update("big", 5);
            argument.update("small", 0);
            global.director.replaceScene(new BattleScene(argument));
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
            if(global.taskModel.checkInNewTask())
            {
                argument.update("soldier", getAllNew(0, 0));//新手任务闯关
            }
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
            finishDataAndStartPic();
        }
    }
}
