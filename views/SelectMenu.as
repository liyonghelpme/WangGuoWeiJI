//播放相同的变身动画
//hero = sprite("hero590.png").pos(371, 350).setevent(EVENT_TOUCH, onHero, 590);
/*
        hero = sprite("hero550.png").pos(739, 282).setevent(EVENT_TOUCH, onHero, 550);
        bg.add(hero, 3);
        heros.update(550, hero);

        hero = sprite("hero440.png").pos(441, 405).setevent(EVENT_TOUCH, onHero, 440);
*/
//restore OldTexture
class Hero extends MyNode
{
    var scene;
    var hid;
    var ani;
    var sca;
    function Hero(s, i, dirX)//英雄ID---》人物ID
    {
        scene = s;
        hid = i;
        var mapPos = HeroPos.get(hid);
        var worldPos = scene.scene.map.node2world(mapPos[0], mapPos[1]);
        var menuPos = scene.bg.world2node(worldPos[0], worldPos[1]);

        //map 缩放大小
        sca = scene.scene.getMapNormalScale();
        trace("heroPos", menuPos, sca);

        bg = sprite("hero"+str(hid)+"l.png", ARGB_8888).pos(menuPos).setevent(EVENT_TOUCH, onHero).scale(HeroDir.get(hid)*sca/100, sca).anchor(50, 100);
        init();
        ani = copy(getSkillAnimate(heroSkill.get(hid)));
        //ani = copy(skillAnimate.get());//英雄变身动画的 hid--->id
        ani[0] = copy(ani[0]);
        cus = new OneAnimate(ani[1], ani[0], bg, "hero"+str(hid)+"l.png", 0);//不恢复旧的纹理
    }
    function onHero(n, e, p, x, y, points)
    {
        scene.selectHero(hid); 
    }
    function showMakeUp()
    {
        if(cus != null)
        {
            cus.exitScene();
            cus.setAni(ani, 0);
            cus.enterScene();
        }
    }
    var cus = null;
    function showNormal()
    {
        if(cus != null)
        {
            cus.exitScene();
            var a = copy(ani);
            a[0] = copy(a[0]);//copy a0 reverse
            a[0].reverse();

            cus.setAni(a, 1);//恢复旧的纹理
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
    function SelectMenu(s, cur)
    {
        scene = s;
        curStep = cur;
        word = getStr("selectHero", null).split("\n");

        bg = node();
        init();

        //黑色不需要
        //bg.addsprite("black.png", ARGB_8888).color(0, 0, 0, 30).size(global.director.disSize);

        var hero = new Hero(this, 480, -100);
        addChildZ(hero, 1);
        heros.update(480, hero);

        hero = new Hero(this, 590, -100);
        addChildZ(hero, 2);
        heros.update(590, hero);

        hero = new Hero(this, 550, 100);
        addChildZ(hero, 3);
        heros.update(550, hero);

        hero = new Hero(this, 440, -100);
        addChildZ(hero, 4);
        heros.update(440, hero);


        menuNode = node();
        bg.add(menuNode, 5);
        
        stepTip = new GrayWord(this, getStr("selectHero", null), 22, 5, [100, 100, 100], 800, 0, 6, null, curStep);//passLine 70 70 70
        stepTip.setPos([38, 46])
        addChildZ(stepTip, 10);

        selectHero(-1);
        //updateMenu();
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
                hero = heros.get(curSelHero);
                hero.showMakeUp();
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
        else if(colNames.get(name) == null)
        {
            tooLong = 0;
            col = 0;
            colNames.update(name, 1);
            inConnect = 1;
            global.httpController.addRequest("chooseFirstHero", dict([["uid", global.user.uid], ["hid", curSelHero], ["name", name]]), finishName, null);
            curStep++;
            updateMenu();
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
        global.director.replaceScene(new CastleScene());
        global.director.pushView(new Loading(), 1, 0);//DarkNod
        //初始化场景数据 数据初始化结束之后 取出loading页面
        global.user.initData();
    }
    function finishName(rid, rcode, con, param)
    {
        inConnect = 0;
        if(rcode != 0)
        {
            con = json_loads(con);
            if(con.get("id") != 0)
            {
                trace("finishName");
                if(inGame != null)
                {
                    inGame.setevent(EVENT_TOUCH, enterGame);
                }
                else 
                    enterGame();
            }
            else//名字重复 退回到上一步 显示名字冲突
            {
                tooLong = 0; 
                col = 1;
                curStep--;
                //onInput();
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
            heroDes = menuNode.addsprite("heroDes"+str(curSelHero)+".png").pos(517, 12); 
            //-40
            sureBut = menuNode.addsprite("heroSure.png").anchor(0, 50).pos(517, 140).setevent(EVENT_TOUCH, onSure);
        }
        else if(curStep == 1)
        {
            heroDes = menuNode.addsprite("storeBlack.png").pos(517, 12).size(273, 172); 
            heroDes.addlabel(getStr("heroName", null), null, 20).pos(24, 12);

            sureBut = heroDes.addsprite("heroSure.png").anchor(0, 50).pos(58, 146).setevent(EVENT_TOUCH, onInput);
            backBut = heroDes.addsprite("heroBack.png").anchor(0, 50).pos(142, 146).setevent(EVENT_TOUCH, onBack);
            //723 165 - 200 120 = 523 45
            inputView = v_create(V_INPUT_VIEW, 539, 63, 230, 50);
            v_root().addview(inputView);
            warnLabel = heroDes.addlabel(getStr("nameLen", null), null, 18).color(100, 0, 0).pos(23, 94).visible(0);
            if(name != null)
                inputView.text(name);
            if(tooLong)
            {
                warnLabel.text(getStr("nameLen", null));
                warnLabel.visible(1);
            }
            else if(col)
            {
                warnLabel.text(getStr("nameRepeat", null));
                warnLabel.visible(1);
            }
        }
        else if(curStep == 2)
        {
            inGame = menuNode.addsprite("in0.png", ARGB_8888).pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50).addaction(repeat(animate(1000, "in0.png", "in1.png","in2.png","in3.png","in4.png",UPDATE_SIZE, ARGB_8888)));
            stepTip.setWord(getStr("selectHero", ["[NAME]", name]));
            //设定英雄类型
            //设定英雄名字
            
        }
        stepTip.setCurLine(curStep);
    }
    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        if(inputView != null)
        {
            inputView.removefromparent()
            inputView = null;
        }
        super.exitScene();
    }
}
