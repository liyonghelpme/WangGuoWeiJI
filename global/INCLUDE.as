//注意这些文件是倒序编译的，所以其排序和依赖关系相反

import global.Timer;
import global.Director;
import views.Dark;
import global.MyNode;
import global.Controller;
import global.TouchManager;
import util.Util;
import global.Global;


global.director = new Director();
//var touchManager = new TouchManager();
global.timer = new Timer(50);
//global.touchManager = touchManager;
global.controller = new Controller();


