class ChallengeScene extends MyNode
{
    var initOver = 0;  
    var oid;
    var papayaId;
    var score;
    var rank;
    var enemies;
    var equips;
    var kind;
    /*
    挑战对方的uid
    挑战对方的papayaId
    挑战对方的得分
    挑战对方的排名

    如果挑战对方是邻居
    */
    var user;
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
    }
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
    }
    /*
    生成随机的布局
    按顺序 按个数 挨个放置 类似于放置怪兽

    sid == -1 表示是敌方的士兵
    士兵的基本属性 满血满魔
    sid=-1 kind level addAttack addDefense addAttackTime addDefenseTime

    怪兽 addAttack全部为0
    */
    function getDataOver(rid, rcode, con, param)
    {
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") == 0)
                global.director.popScene();
            /*
            else if(oid == global.user.uid)
            {
                enemies = con.get("soldiers");
                equips = con.get("equips");
                global.director.replaceScene(new BattleScene(5, 0, enemies, CHALLENGE_SELF, [oid, papayaId, score, rank, con.get("cityDefense")], equips));
            }
            */
            //挑战好友 挑战邻居获得技能
            else if(kind == CHALLENGE_FRI){
                global.user.addChallengeRecord(oid);
                enemies = con.get("soldiers");
                equips = con.get("equips");
                //initOver = 1;
                //战胜 失败于对方 需要知道对方
                global.director.replaceScene(new BattleScene(5, 0, enemies, CHALLENGE_FRI, [oid, papayaId, score, rank, con.get("cityDefense"), con.get("skills"), null], equips));
            }
            else if(kind == CHALLENGE_NEIBOR)
            //根据邻居的uid 得到邻居的数据 getNeiborData
            {
                global.friendController.challengeNeibor(oid);
                enemies = con.get("soldiers");
                equips = con.get("equips");
                //initOver = 1;
                //战胜 失败于对方 需要知道对方
                global.director.replaceScene(new BattleScene(5, 0, enemies, CHALLENGE_NEIBOR, [oid, papayaId, score, rank, con.get("cityDefense"), con.get("skills"), null], equips));
            }
            //需要修改 挑战数据 数据 存储在 场景中
            else if(kind == CHALLENGE_FIGHT)//挑战敌方士兵 类似于 挑战邻居 但是奖励不同
            {
                enemies = con.get("soldiers");
                equips = con.get("equips");
                global.director.replaceScene(new BattleScene(5, 0, enemies, CHALLENGE_FIGHT, [oid, papayaId, score, rank, con.get("cityDefense"), con.get("skills"), user], equips));
            }
            else if(kind == CHALLENGE_DEFENSE)
            {
                enemies = con.get("soldiers");
                equips = con.get("equips");
                global.director.replaceScene(new BattleScene(5, 0, enemies, CHALLENGE_DEFENSE, [oid, papayaId, score, rank, con.get("cityDefense"), con.get("skills"), user], equips));
            }
        }
    }
}
