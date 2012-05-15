//注意这些文件是倒序编译的，所以其排序和依赖关系相反


import views.CastlePage;
import views.BuildLand;
import views.FallGoods;
import views.FallObj;


import views.Store;
import views.Choice;
import views.Goods;

import views.MenuLayer;
import views.ChildMenuLayer;
import views.Button;

import views.MapScene;
import views.MapLayer;
import views.FlyLayer;
import views.LevelSelectLayer;


//采用组合的方式 将farm相关的行为 实现在farm中
import views.Building;
import views.BuildMenu;

import views.Farm;

import views.PlantChoose;

/*
import views.Map;
import views.MoveObject;
*/

import global.Timer;
import global.Director;
import views.Dark;


import views.StandardTouchHandler;

import global.MyAnimate;
import global.MyNode;
import global.Controller;
import global.TouchManager;
import util.Util;
import global.User;
import global.Global;
import data.String;
import data.Static;

import data.String;

global.director = new Director();
global.touchManager = new TouchManager();
global.timer = new Timer(1000);
global.controller = new Controller();
global.myAction = new MyAction();

global.user = new User();


