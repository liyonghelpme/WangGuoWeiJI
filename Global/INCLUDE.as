//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图

import views.FriendScene;
//import views.FriendMenu;
import busiViews.FriendMenu;
import busiViews.FriendRightMenu;

import views.FriendSoldier;


//import views.SettingDialog;
import busiViews.SettingDialog;

import views.TaskDialog;
import views.TipDialog;
//import views.MakeDrugDialog;
import busiViews.MakeDrugDialog;

import busiViews.SoldierDialog;
import busiViews.AllSoldier;
import busiViews.DeadSoldier;
import busiViews.TransferSoldier;

//import views.SoldierDialog;
//import views.AllSoldier;
//import views.DeadSoldier;
//import views.TransferSoldier;
//import views.DrugDialog;
import busiViews.DrugDialog;
import busiViews.DrugList;


//经营页面
import views.CastlePage;
import views.BuildLayer;
import views.BuildLand;
import views.SoldierMax;
import views.CrystalIsland;
import views.MineMenu;
import views.MineFunc;

import views.FallGoods;
import views.FallObj;




//菜单
import views.MenuLayer;





//import views.RoleName;
import busiViews.RoleName;


//人物对话框
import views.SoldierStore;
import views.BusiSoldier;

import views.TrainBanner;
import views.ProfessionIntroDialog;

//成功提示

import views.ResourceBanner;


import views.SoldierMenu;
import busiViews.DetailDialog;

import views.ChildMenuLayer;
import views.GameTwo;
import views.GameOne;

import busiViews.MailDialog;
import busiViews.RequestView;
import busiViews.MoreView;

//import views.GiftView;
//import views.AllGoods;
import busiViews.AllGoods;

//import views.UpgradeDialog;
import busiViews.UpgradeDialog;
//import views.SkillDialog;
import busiViews.SkillDialog;

//import views.UpgradeSkillDialog;
import busiViews.UpgradeSkillDialog;
import views.TrainDialog;


//import views.HeartRankDialog;
//import views.HeartRankBase;



//import views.TrainScene; 统一使用battleScene
import views.TrainTip;






//大地图
import views.CastleScene;
//建筑物
//采用组合的方式 将farm相关的行为 实现在farm中
import views.Building;
import views.PopBanner;
import views.BuildMenu;
import views.BuildWorkMenu;

import fight.RingFightingScene;
import fight.FightMap;
import fight.FightMenu;
import fight.MakeArenaDialog;
import fight.FightSoldier;

import views.MoveMap;
import views.MoveSoldier;

import views.Camp;




import views.SellDialog;
import views.AccDialog;

import busiViews.FriendDialog;
import busiViews.Neibor;
import busiViews.OtherPlayer;

import busiViews.FriendList;
import busiViews.SearchDialog;
import busiViews.InviteDialog;
import busiViews.InviteList;



//import views.FriendDialog;
//import views.FriendList;
//import views.GiftDialog;
import busiViews.GiftDialog;

import views.FlowScene;
import views.FlowMenu;
import views.FlowIsland;



import views.ResourceWarningDialog;



//import views.GloryDialog;
import busiViews.CollectionDialog;
import busiViews.CollectionList;

import views.Farm;
import views.Plant;
import views.PlantChoose;
import views.House;
import views.FuncBuild;

//经营页面场景飞行的银币
import views.FlyObject;


import views.Loading;




//新手剧情对话框 依赖于CastlePageScene
//如果使用消息机制就能避免显示的依赖关系
import welcome.SelectHero;
import welcome.SelectMenu;

import welcome.BattleEnd;
import welcome.BackWord;
import welcome.NewBattle;
import welcome.WelcomeDialog;

import welcome.GrayWord;

import battle.MapScene;
import battle.FlyLayer;
import battle.MapLayer;
import battle.LevelChoose;


//战斗页面
import war.BattleScene;
import war.MapBanner;
//闯关地图
import war.Map;
import war.Soldier;

import views.MonSmoke;
import views.DeadOver;
import views.LineSkill;
import views.SingleSkill;
import views.MultiSkill;
import views.SpinSkill;
import views.HealSkill;
import views.SaveSkill;
import views.UseDrugSkill;

import views.SoldierAnimate;

import views.CloseSoldier;
import views.CloseAttackEffect;
import views.ChallengeOver;

import views.Arrow;
import views.Magic;
import views.MoveObject;
import views.MapPause;
import views.SkillFlowBanner;
import views.MapDefense;


import views.DialogController;
import views.Mask;

//import views.ScoreDialog;
//import views.LevupDialog;
import busiViews.ScoreDialog;
import busiViews.LevupDialog;



import views.NoTipDialog;


//战斗结束奖励 对话框
import views.TrainOverDialog;
import views.ChallengeFight;
import views.ChallengeNeibor;
import views.BreakDialog;


import views.CallSoldier;
import views.SoldierGoods;

//import views.RankDialog;
//import views.RankBase;
import busiViews.RankDialog;
import busiViews.RankBase;

import views.ChallengeScene;
//import views.VisitDialog;
import busiViews.VisitDialog;



//商店
import views.Store;
import views.Choice;
import views.Goods;
import views.ResLackBanner;

import views.UpdateDialog;
import views.LoveUpgradeDialog;
import views.LoveDialog;
import views.LiveHeartDialog;
import views.LoginDialog;

//菜单使用的按钮对象
import views.Button;
import views.UpgradeBanner;



import model.SoldierAI;
import model.BusinessModel;
import model.RoundModel;
import model.MapGridController;
import model.SoldierBase;

import views.MyWarningDialog;
import views.ShadowWords;
import views.NewButton;
import views.BannerController;




import Global.User;
import Global.MessageCenter;


import Global.SensorController;
import Global.Director;
import Global.Controller;
//import views.QuitBanner;
import Global.Timer;
import views.Dark;
import views.StandardTouchHandler;
import Global.MyAnimate;

import model.FightModel;

import Global.TouchManager;
import model.TaskModel;
import views.TaskFinish;
import model.MailController;

import Global.MyNode;

import model.FriendController;
import model.HttpController;
import util.Util;

import Global.GlobalController;

//import data.String;
import data.constant;
import data.Static;
import data.words;


import data.String;


global.timer = new Timer(1000);
global.httpController = new HttpController();
global.msgCenter = new MessageCenter();
global.director = new Director();
global.touchManager = new TouchManager();
global.controller = new Controller();
global.myAction = new MyAction();

//global.staticScene = new CastleScene();
global.user = new User();
global.sensorController = new SensorController();
global.friendController = new FriendController();
global.taskModel = new TaskModel();
global.mailController = new MailController();
global.fightModel = new FightModel();
global.bannerController = new BannerController();



