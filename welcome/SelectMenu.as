//播放相同的变身动画
//hero = sprite("hero590.png").pos(371, 350).setevent(EVENT_TOUCH, onHero, 590);
//restore OldTexture
class Hero extends MyNode
{
    var scene;
    var hid;
    var ani;
    var full;
    var heroSize;
    //var sca;
    function Hero(s, i)//英雄ID---》人物ID
    {
        scene = s;
        hid = i;
        
        var mapPos = HeroPos.get(hid);
        /*
        var worldPos = scene.scene.map.node2world(mapPos[0], mapPos[1]);
        var menuPos = scene.bg.world2node(worldPos[0], worldPos[1]);
        */

        //map 缩放大小
        //sca = scene.scene.getMapNormalScale();
        ////trace("heroPos", menuPos);
        //load_sprite_sheet("soldiera"+str(hid)+".plist");
        //heroSize = sprite("soldiera"+str(hid)+".plist/ss"+str(hid)+"a0.png").prepare().size();
        heroSize = HERO_SIZE[hid];

        bg = sprite().pos(mapPos).setevent(EVENT_TOUCH, onHero).scale(HeroDir.get(hid)*SHOW_SCALE/100, SHOW_SCALE).anchor(50, 100).size(heroSize);
        init();
        var lp = HERO_LIGHT_POS[hid];
        full = bg.addsprite("hero"+str(hid)+"Full.png", ARGB_8888).pos(lp);

        ani = copy(getSkillAnimate(heroSkill.get(hid)));
        //ani = copy(skillAnimate.get());//英雄变身动画的 hid--->id
        ani[0] = copy(ani[0]);
        cus = new LightAnimate(ani[1], ani[0], bg, "", 0, onNormal);//不恢复旧的纹理
    }
    //显示 全光图片
    //设定空的纹理
    function onNormal()
    {
        bg.texture();//无纹理
        bg.size(heroSize);
        full.visible(1);
    }
    function onHero(n, e, p, x, y, points)
    {
        scene.selectHero(hid); 
    }
    function showMakeUp()
    {
        if(cus != null)
        {
            full.visible(0);
            cus.callback = null;
            cus.exitScene();
            cus.setAni(ani, 0);
            cus.enterScene();
        }
    }
    var cus = null;
    //如何检测动画结束?
    function showNormal()
    {
        if(cus != null)
        {
            cus.callback = onNormal;
            cus.exitScene();
            var a = copy(ani);
            a[0] = copy(a[0]);//copy a0 reverse
            a[0].reverse();

            cus.setAni(a, 0);//恢复旧的纹理 设定的大小
            cus.enterScene();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        //global.myAct.addAct(this); 
    }
    override function exitScene()
    {
        if(cus != null)
        {
            cus.exitScene();
            cus = null;
        }
        //global.myAct.removeAct(this);
        super.exitScene();
    }

}

class SelectMenu extends MyNode
{
    var menuNode;
    var stepTip = null;//左上提示文字
    var curStep = 0; 
    var heroDes = null;//右上英雄简介

    var scene;

    var curSelHero = -1;//默认选择 0 号英雄

    var word;
    var heros = dict();
    const H0 = 1;
    const H1 = 2;
    const H2 = 3;
    const H3 = 4;

    const BLACK2 = 5;
    const MENU = 6;
    const ENTER = 10;
    function SelectMenu(s, cur)
    {
        scene = s;
        curStep = cur;
        word = getStr("selectHero", null).split("\n");

        bg = node();
        init();

        //黑色不需要
        bg.addsprite("black.png", ARGB_8888).color(0, 0, 0, 50).size(global.director.disSize);

        var hero = new Hero(this, 480);
        addChildZ(hero, H0);
        heros.update(480, hero);

        hero = new Hero(this, 590);
        addChildZ(hero, H1);
        heros.update(590, hero);

        hero = new Hero(this, 550);
        addChildZ(hero, H2);
        heros.update(550, hero);

        hero = new Hero(this, 440);
        addChildZ(hero, H3);
        heros.update(440, hero);


        menuNode = node();
        bg.add(menuNode, MENU);
        
        stepTip = new GrayWord(this, getStr("selectHero", null), 22, 5, [100, 100, 100], 800, 0, 6, printOver, curStep);//passLine 70 70 70
        stepTip.setPos([37, 50])
        addChildZ(stepTip, ENTER);

        selectHero(-1);
        //updateMenu();
    }
    var printFinish = 0;
    function printOver()
    {
        if(curStep == 2)
            printFinish = 1;
    }

    function selectHero(p)
    {
        if(curStep == 0)
        {
            if(curSelHero != p)
            {
                var hero;
                //旧的选择英雄 取消
                if(curSelHero != -1)
                {
                    hero = heros.get(curSelHero);
                    hero.showNormal();
                }
                curSelHero = p;
                if(curSelHero != -1)//没有选择英雄则不更新
                {
                    hero = heros.get(curSelHero);
                    hero.showMakeUp();
                }
                //新的选择英雄显示变身动画
                updateMenu();
            }
        }
    }
    //选择英雄分成3步
    //选择 未点击英雄 ---》点击英雄 显示简单介绍 每点击一个英雄就会变换一次
    //
    //function GrayWord(sc, w, sz, h, c, wid, hei, n, cb)
    var sureBut;
    var backBut;
    function onSure(n, e, p, x, y, points)
    {
        if(inConnect)
            return;
        curStep++;
        updateMenu();
    }
    function onBack(n, e, p, x, y, points)
    {
        if(inConnect)
            return;
        curStep--;
        updateMenu();
    }
    var colNames = dict();//冲突名字
    var name = null;
    var inConnect = 0;
    var newHeroId = null;
    function onInput()
    {
        if(inConnect)
            return;
        name = inputView.text();
        if(len(name) > 12)
        {
            tooLong = 1;
            col = 0;
            updateMenu();
        }
        //第一个英雄sid = 0
        else if(colNames.get(name) == null)
        {
            tooLong = 0;
            col = 0;
            colNames.update(name, 1);
            inConnect = 1;
            if(newHeroId == null)
                newHeroId = global.user.getNewSid();

            global.httpController.addRequest("chooseFirstHero", dict([["uid", global.user.uid], ["hid", curSelHero], ["name", name], ["sid", newHeroId]]), finishName, null);
            //确认了名字没有重复 则 进入下一步
            //curStep++;
            //updateMenu();
        }
        else
        {
            tooLong = 0;
            col = 1;
            updateMenu();
        }


    }
    function enterGame()
    {
        //替换场景 进入游戏不要loading页面了
        //重新进入经营页面 不用初始化数据 不显示loading页面
        global.director.replaceScene(new CastleScene(0));
        //global.director.pushView(new Loading(), 1, 0);//DarkNod
        //初始化场景数据 数据初始化结束之后 取出loading页面 经营页面初始化数据胡
        //只是 经营页面 初始数据 其它模块不参与
        global.msgCenter.sendMsg(INITDATA_OVER, null);
    }
    const BLOCK_W = 273;
    const BLOCK_H = 172;
    const BLOCK_X = 504;
    const BLOCK_Y = 14;

    var checkName = 0;
    function finishName(rid, rcode, con, param)
    {
        inConnect = 0;
        if(rcode != 0)
        {
            con = json_loads(con);
            //命名正确初始化英雄
            if(con.get("id") != 0)
            {
                checkName = 1;
                curStep++;
                var b2 = sprite("black.png", ARGB_8888).color(0, 0, 0, 30).size(global.director.disSize);
                bg.add(b2, BLACK2);

                //var solId = global.user.getNewSid();
                //构造新的士兵数据初始化士兵
                //学习英雄技能
                //id sid name
                var newSol = new BusiSoldier(null, getData(SOLDIER, curSelHero), null, newHeroId);
                newSol.setName(name);
                global.user.updateSoldiers(newSol);
                global.user.addNewSkill(newSol.sid, heroSkill.get(newSol.id));
                updateMenu();
            }
            else//名字重复 退回到上一步 显示名字冲突
            {
                tooLong = 0; 
                col = 1;
                updateMenu();
            }
        }
        //保持当前页面显示 

    }

    var inputView = null;
    var warnLabel = null;
    var tooLong = 0;
    var col = 0;
    var inGame = null;

    const INPUT_X = 21;
    const INPUT_Y = 51;

    function cancelHero()
    {
        selectHero(-1);
    }
    function updateMenu()
    {
        menuNode.removefromparent();
        menuNode = node();
        bg.add(menuNode, 5);
        if(inputView != null)
        {
            inputView.removefromparent();
            inputView = null;
        }

        if(curStep == 0)//第一步不能back
        {
            if(curSelHero != -1)
            {
                //heroDes = menuNode.addsprite("heroDes"+str(curSelHero)+".png").pos(517, 12); 
                heroDes = menuNode.addsprite("heroDesBack.png").pos(BLOCK_X, BLOCK_Y).size(BLOCK_W, BLOCK_H);
                //var heroData = getData(SOLDIER, curSelHero);
                //var heroName = heroDes.addlabel(str(heroData.get("name")), null, 28, FONT_BOLD).pos(22, 15);
                var heroName = heroDes.addsprite("nHeroDes"+str(curSelHero)+".png").pos(22, 15);
                var desc = stringLines(getStr("heroDes"+str(curSelHero), null), 20, 26, [100, 100, 100], FONT_BOLD);
                desc.pos(26, 65);
                heroDes.add(desc);

                //-40
                sureBut = heroDes.addsprite("heroSure0.png").anchor(0, 0).pos(24, 135).setevent(EVENT_TOUCH, onSure);
                backBut = heroDes.addsprite("heroBack0.png").anchor(0, 0).pos(98, 135).setevent(EVENT_TOUCH, cancelHero);
            }
        }
        else if(curStep == 1)
        {
            heroDes = menuNode.addsprite("heroDesBack.png").pos(BLOCK_X, BLOCK_Y).size(BLOCK_W, BLOCK_H); 
            heroDes.addsprite("heroName0.png").pos(22, 19);
            sureBut = heroDes.addsprite("heroSure0.png").anchor(0, 0).pos(24, 135).setevent(EVENT_TOUCH, onInput);
            backBut = heroDes.addsprite("heroBack0.png").anchor(0, 0).pos(98, 135).setevent(EVENT_TOUCH, onBack);
            //723 165 - 200 120 = 523 45
            inputView = v_create(V_INPUT_VIEW, BLOCK_X+INPUT_X, BLOCK_Y+INPUT_Y, 233, 50);
            v_root().addview(inputView);
            warnLabel = heroDes.addlabel(getStr("nameLen", null), null, 18).color(100, 100, 100).pos(22, 100);//.visible(0);
            if(name != null)
                inputView.text(name);
            else
                inputView.text(global.user.papayaName);
            if(tooLong)
            {
                warnLabel.text(getStr("nameLen", null)).color(97, 3, 3);
                warnLabel.visible(1);
            }
            else if(col)
            {
                warnLabel.text(getStr("nameRepeat", null)).color(97, 3, 3);
                warnLabel.visible(1);
            }
        }
        //打完字才出现 是否进入游戏对话框 首先确认名字是否重复
        else if(curStep == 2)
        {
            stepTip.setWord(getStr("selectHero", ["[NAME]", name]));
            //设定英雄类型
            //设定英雄名字
            
        }
        //只有在验证了名字可用 才显示第三步
        //if(curStep != 2)
        stepTip.setCurLine(curStep);
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    function update(diff)
    {
        if(printFinish && checkName && inGame == null)//打字结束 且 检测名字无误 进入游戏
        {
            inGame = menuNode.addsprite("in0.png", ARGB_8888).pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50).addaction(repeat(animate(getParam("enterTime"), "in0.png", "in1.png","in2.png","in3.png","in2.png", "in1.png", UPDATE_SIZE, ARGB_8888))).setevent(EVENT_TOUCH, enterGame);
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        if(inputView != null)
        {
            inputView.removefromparent()
            inputView = null;
        }
        super.exitScene();
    }
}
