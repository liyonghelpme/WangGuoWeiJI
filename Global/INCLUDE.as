//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图

import views.FriendScene;
import busiViews.FriendMenu;
import busiViews.FriendRightMenu;
import busiViews.TreasureBox;
import busiViews.BoxReward;

import views.FriendSoldier;


//import views.SettingDialog;
import busiViews.SettingDialog;

import busiViews.TaskDialog;
import busiViews.TipDialog;

import busiViews.NewSoldierDialog;
import busiViews.AllSoldier;

import busiViews.DrugDialog;
import busiViews.DrugList;


//经营页面
import views.CastlePage;
import busiViews.SoldierNumBanner;
import busiViews.NewTaskReward;
import busiViews.BoxOnMap;
import busiViews.DownloadDialog;
import busiViews.DownloadIcon;

import busiViews.BuildLayer;
import busiViews.BuildLand;
import views.SoldierMax;

import views.MineFunc;
import busiViews.UpgradeMine;

import views.FallGoods;
import views.FallObj;


//菜单
import views.MenuLayer;
import busiViews.CastleRightMenu;

//人物对话框
import busiViews.BusiSoldier;

//成功提示


import busiViews.SoldierMenu;
//import busiViews.DetailDialog;

import views.ChildMenuLayer;
import busiViews.TransferDialog;
import views.GameTwo;
import busiViews.InviteIntro;
import busiViews.InviteInput;

import busiViews.MailDialog;
import busiViews.RequestView;
import busiViews.MoreView;

import busiViews.AllGoods;


//大地图
import views.CastleScene;
//建筑物
//采用组合的方式 将farm相关的行为 实现在farm中
import busiViews.Building;
import busiViews.BuildAnimate;
import busiViews.BuildMenu;
import busiViews.BuildWorkMenu;

import views.MoveMap;
import views.MoveSoldier;

import views.Camp;



import busiViews.FriendDialog;
import busiViews.Neibor;
import busiViews.OtherPlayer;

import busiViews.FriendList;
import busiViews.SearchDialog;
import busiViews.InviteDialog;
import busiViews.InviteList;

import busiViews.GiftDialog;

import views.FlowScene;
import views.FlowMenu;
import views.FlowIsland;

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
import war.ChallengeInfo;
import war.MapBanner;
//闯关地图
import war.Map;
import war.Soldier;

import war.FireBall;
import war.GunSmoke;
import war.GunSmokeTrail;
import war.MagicFly;
import war.MakeFlyEffect;
import war.MakeFlyTrail;

import war.Galaxy;
import war.GalaxyFireBall;
import war.ThreeBall;
import war.ThreeTrail;

import war.CloseSoldier;
import war.AttackBombEffect;
import war.ArrowFlyEffect;
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
import war.LineSkill;
import war.SingleSkill;
import war.MultiSkill;
import war.SpinSkill;
import war.HealSkill;
import war.SaveSkill;
import war.UseDrugSkill;



import views.MoveObject;
import war.MapPause;
import war.SkillFlowBanner;
import war.MapDefense;




import views.DialogController;
import busiViews.ChallengeMsgDialog;
//import busiViews.NewTaskDialog2;
import views.Mask;
import busiViews.NewTaskMask;

//import views.ScoreDialog;
//import views.LevupDialog;
import busiViews.ScoreDialog;
import busiViews.LevupDialog;



//import views.NoTipDialog;
import busiViews.NoTipDialog;



//战斗结束奖励 对话框

import war.RoundWin;
import war.RoundFail;

import war.NewChallengeWin;
import war.NewChallengeFail;


import busiViews.CallSoldier;
import busiViews.SoldierGoods;

//import views.RankDialog;
//import views.RankBase;
import busiViews.RankDialog;
import busiViews.RankBase;

import views.ChallengeScene;
import busiViews.VisitDialog;



//商店
import views.Store;
import views.Choice;
import views.Goods;
import views.ResLackBanner;

import busiViews.LoadChallenge;

import views.LoginDialog;
import busiViews.LoadChallenge;

//菜单使用的按钮对象
import views.UpgradeBanner;

import model.SoldierAI;
import model.SoldierModel;
import model.BusinessModel;
import model.RoundModel;
import model.RoundMonsterGen;
import model.RoundGridController;
import model.MapGridController;

import views.MyWarningDialog;
import views.ShadowWords;
import views.NewButton;




import Global.User;
import Global.MessageCenter;


import Global.SensorController;
import Global.Director;
import Global.Controller;
import Global.Timer;
import views.Dark;
import views.StandardTouchHandler;
import Global.MyAnimate;


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

import Global.GlobalController;


//import data.String;
import data.constant;
import data.Static;
import data.words;

import data.Name;
import data.String;



global.timer = new Timer(1000);

global.httpController = new HttpController();
global.paramController = new ParamController();

//Message 要比Controller 先初始化
global.msgCenter = new MessageCenter();
global.director = new Director();
global.touchManager = new TouchManager();
global.controller = new Controller();
global.myAction = new MyAction();



//friend  task mail fight  castleScene
//不同途径相同归一目的地
//global.staticScene = new CastleScene();
global.user = new User();
global.pictureManager = new PictureManager();
global.sensorController = new SensorController();
global.friendController = new FriendController();
global.taskModel = new TaskModel();
global.mailController = new MailController();




