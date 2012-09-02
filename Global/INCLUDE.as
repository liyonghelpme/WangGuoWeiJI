//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图


import views.FriendScene;
import views.FriendMenu;
import views.VisitDialog;
import views.FriendSoldier;


import views.RankDialog;
//import views.HeroRank;
//import views.GroupRank;
//import views.NewRank;
import views.RankBase;
import views.ChallengeScene;
import views.ChallengeNeibor;


import views.LoginDialog;
import views.SettingDialog;
import views.TaskDialog;
import views.TipDialog;
import views.MakeDrugDialog;
import views.ScoreDialog;

import views.SoldierDialog;
import views.AllSoldier;
import views.DeadSoldier;
import views.TransferSoldier;
import views.DrugDialog;


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

import views.DialogController;

import views.UpdateDialog;
//菜单
import views.MenuLayer;


//商店
import views.Store;
import views.Choice;
import views.Goods;

import views.RoleName;


//人物对话框
import views.SoldierStore;
import views.BusiSoldier;

import views.TrainBanner;
import views.ProfessionIntroDialog;

//成功提示
import views.SucBanner;
import views.ResourceBanner;


import views.SoldierMenu;
import views.DetailDialog;
import views.ChildMenuLayer;
import views.GameTwo;
import views.GameOne;
import views.MailDialog;
import views.RequestView;
import views.GiftView;
import views.AllGoods;
import views.UpgradeDialog;
import views.SkillDialog;
import views.UpgradeSkillDialog;
import views.TrainDialog;
import views.LoveDialog;
import views.HeartRankDialog;
import views.HeartRankBase;
import views.LiveHeartDialog;

import views.TrainScene;
import views.TrainTip;

import views.BreakDialog;




//大地图
import views.CastleScene;
//建筑物
//采用组合的方式 将farm相关的行为 实现在farm中
import views.Building;
import views.BuildMenu;
import views.BuildWorkMenu;

import views.SellDialog;
import views.AccDialog;
import views.FriendDialog;
import views.GiftDialog;

import views.FlowScene;
import views.FlowMenu;
import views.FlowIsland;


import views.ResourceWarningDialog;



import views.GloryDialog;

import views.Farm;
import views.PlantChoose;
import views.House;
import views.FuncBuild;

//经营页面场景飞行的银币
import views.FlyObject;

import views.MapScene;
import views.MapLayer;
import views.FlyLayer;
import views.LevelSelectLayer;

import views.BattleScene;
import views.MapBanner;
import views.NoTipDialog;

//闯关地图
import views.Map;
import views.TrainOverDialog;
import views.Soldier;
import views.MonSmoke;
import views.DeadOver;
//import views.SkillEffect;
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

import views.Loading;
import views.LevupDialog;

//菜单使用的按钮对象
import views.Button;


//新手剧情对话框 依赖于CastlePageScene
//如果使用消息机制就能避免显示的依赖关系
import views.SelectHero;
import views.SelectMenu;

import views.BattleEnd;
import views.NewBattle;
import views.WelcomeDialog;
import views.PrintWord;
import views.GrayWord;



import model.BusinessModel;
import model.RoundModel;
import model.MapGridController;
import model.SoldierBase;

import views.MyWarningDialog;




import Global.User;
import Global.MessageCenter;


import Global.SensorController;
import Global.Director;
import Global.Controller;
import views.QuitBanner;
import Global.Timer;
import views.Dark;
import views.StandardTouchHandler;
import Global.MyAnimate;

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



