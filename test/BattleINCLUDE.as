//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图
/*

import views.FriendScene;
//import views.FriendMenu;
import busiViews.FriendMenu;
import busiViews.FriendRightMenu;
import busiViews.TreasureBox;
import busiViews.BoxReward;

import views.FriendSoldier;


//import views.SettingDialog;
import busiViews.SettingDialog;

import busiViews.TaskDialog;
import views.TipDialog;
//import views.MakeDrugDialog;
import busiViews.MakeDrugDialog;

import busiViews.SoldierDialog;
import busiViews.AllSoldier;
import busiViews.DeadSoldier;
import busiViews.TransferSoldier;

import busiViews.DrugDialog;
import busiViews.DrugList;


//经营页面
import views.CastlePage;
import busiViews.NewTaskReward;
import busiViews.BoxOnMap;
import busiViews.DownloadDialog;
import busiViews.DownloadIcon;

import busiViews.BuildLayer;
import views.BuildLand;
import views.SoldierMax;

import mine.MineScene;
import mine.MineMenu;
import mine.MakeMine;
import mine.CrystalIsland;
import mine.MoveIsland;

import views.MineFunc;
import mine.UpgradeMine;

import views.FallGoods;
import views.FallObj;


//菜单
import views.MenuLayer;
import busiViews.CastleRightMenu;
import busiViews.DailyTask;
import busiViews.DailyReward;


import busiViews.RoleName;


//人物对话框
import views.BusiSoldier;

import views.TrainBanner;
import views.ProfessionIntroDialog;

//成功提示

import views.ResourceBanner;


import views.SoldierMenu;
import busiViews.DetailDialog;

import views.ChildMenuLayer;
import views.GameFour;
import views.GameTwo;
import views.GameThree;
import views.FlowReward;
//import views.GameOne;
import busiViews.InviteIntro;
import busiViews.InviteInput;

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
import views.BuildAnimate;
import views.PopBanner;
import views.BuildMenu;
import views.BuildWorkMenu;

import fight.FightingScene;
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
import views.LoveTree;
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

import busiViews.ScoreDialog;
import busiViews.LevupDialog;

import busiViews.NoTipDialog;
import views.MoveObject;

import busiViews.NewTaskDialog2;
import views.Mask;

import views.DialogController;
import views.TrainOverDialog;

//战斗结束奖励 对话框
import views.ChallengeFight;
import views.ChallengeNeibor;
//import views.BreakDialog;
import war.ChallengeFail;
import war.ChallengeWin;
import war.SkillFlowBanner;
*/

//战斗页面
import war.BattleScene;
import model.WarStateModel;
//import model.MapGenSolAI;
import model.NewMapGenSolAI;
import model.MiniSoldier;
import war.OkBanner;
import war.SelBanner;
import war.SelBanner2;
//闯关地图
import war.Map;
import war.Soldier;

import war.CloseSoldier;
import war.Arrow;
import war.Magic;
import war.Rocket;
import war.FlyAndBomb;
import war.RollBall;
import war.MakeFly;
import war.MakeFlyRoll;
import war.FullStage;
import war.GroundBomb;
import war.TransformAnimate;
import war.EarthQuake;
import war.DeadOver;
import war.SoldierAnimate;
import model.SoldierEffect;
import war.EffectBase;

import views.MonSmoke;
import views.LineSkill;
import views.SingleSkill;
import views.MultiSkill;
import views.SpinSkill;
import views.HealSkill;
import views.SaveSkill;
import views.UseDrugSkill;

import views.CloseAttackEffect;
import views.ChallengeOver;


import war.MapPause;

import war.MapDefense;




/*
import views.CallSoldier;
import views.SoldierGoods;

import busiViews.RankDialog;
import busiViews.RankBase;

import views.ChallengeScene;
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
import busiViews.LoadChallenge;
*/

//菜单使用的按钮对象
import views.Button;
import views.UpgradeBanner;



import model.SoldierAI;
import model.BusinessModel;
import model.RoundModel;
import model.RoundGridController;
import model.MapGridController;
import model.SoldierBase;
import model.SoldierModel;

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

import model.ParamController;
import model.FriendController;
import model.HttpController;
import util.Util;
import model.PictureManager;
import model.WarHttpController;

import Global.GlobalController;


//import data.String;
import data.constant;
import data.Static;
import data.words;

import data.Name;
import data.String;



global.timer = new Timer(1000);

global.httpController = new HttpController();
global.msgCenter = new MessageCenter();
global.director = new Director();
global.touchManager = new TouchManager();
global.controller = new Controller();
global.myAction = new MyAction();
global.paramController = new ParamController();


//friend  task mail fight  castleScene
//不同途径相同归一目的地
//global.staticScene = new CastleScene();
global.user = new User();
global.pictureManager = new PictureManager();
global.sensorController = new SensorController();
global.friendController = new FriendController();
global.taskModel = new TaskModel();
global.mailController = new MailController();
global.fightModel = new FightModel();
global.bannerController = new BannerController();




