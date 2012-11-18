//import Global.INCLUDE;
//import test.GameInclude;
import test.BattleINCLUDE;


//初始化经营页面
//获取用户数据---->发送消息给经营页面----》初始化经营页面---》
//newState

//如果数据---》新手---》  不发送消息给经营页面数据-- -》 替换经营页面场景----》则压入新手欢迎页面
//新手结束-----》重新压入经营页面----》重新初始化经营页面数据 initData--->

//global.director.pushScene(new SelectHero());

//global.director.pushScene(new WelcomeDialog());
//global.director.pushScene(new SelectHero());
//global.director.pushScene(new NewBattle());


//显示场景
//global.director.pushScene(new CastleScene(1));
//global.director.curScene.addChild(new Loading());
//global.user.initData();

//global.director.pushView(new Loading(), 1, 0);//DarkNod
//初始化场景数据 数据初始化结束之后 取出loading页面
//在loading页面开始初始化数据 保证view 先显示 再加载数据
//global.user.initData();

//var b = new Building(null, getData(BUILD, 208), null);
//global.director.pushView(new LoveDialog(b), 1, 0);

//global.director.pushView(new UpdateDialog(BUILD, 0), 1, 0);

//global.director.pushScene(new BattleEnd());


//global.director.pushView(new LevelChoose(null, 0), 1, 0);
//global.director.pushScene(new MapScene());

//global.director.pushView(new LoginDialog(dict([["loginDays", 5]])), 1, 0);

//global.director.pushView(new LiveHeartDialog(), 1, 0);
//global.director.pushView(new LoveDialog(null), 1, 0);
//global.director.pushView(new LoveUpgradeDialog(null), 1, 0);
//global.director.pushView(new UpdateDialog(EQUIP, 0), 1, 0);



//global.director.pushView(new Loading(), 1, 0);
//var scene = new Scene();
//global.replaceScene(scene);
//var soldier = new BusiSoldier(scene, getData(SOLDIER, 0), null, 0);
//global.director.pushView(new GameThree(soldier), 1, 0);

//soldier Data px py level sid kindId equips skills 
global.director.pushScene(new BattleScene(dict([["kind", CHALLENGE_MON], ["big", 0], ["small", 0]])));


