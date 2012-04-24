//注意这些文件是倒序编译的，所以其排序和依赖关系相反


import views.CastlePage;
import views.Store;
import views.Choice;

import global.Timer;
import global.Director;
import views.Dark;
import views.StandardTouchHandler;
import global.MyNode;
import global.Controller;
import global.TouchManager;
import util.Util;
import global.Global;


global.director = new Director();
global.touchManager = new TouchManager();
global.timer = new Timer(1000);
global.controller = new Controller();


