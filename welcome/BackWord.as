/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

功能：
    换行
    识别非中文字符---》英文字符


当前打字的位置
中文3个字符

打字频率

需要scene提供打字频率的timer 用于Back

脚本：
    setLine 0
    printTo 25 
    setPrintTime 0.5--->10
    printTo 26
    setTime 20 
    printTo 27
    setTime 4
    backPrint 17
    setLine 1
    print 28
    over null
 
所有指令 都必须有一个参数
循环执行 BEGIN_REPEAT END_REPEAT  指定循环次数 和 循环跳转位置
*/
class BackWord extends MyNode
{
    var progress = 0;
    var lab;
    var word;
    var width;
    var height;
    var siz;
    var paraHei;
    var col;
    var tick;
    var accTick;

    //段落间距
    //\n 分割的段落

    var scene;
    var curPos;//字节位置
    var curWordPos;//字符位置

    var curLine;

    var totalNum;
    var sound;
    
    //音效存在问题 不能 有效播放
    //var player;
    //段落停顿时间
    var callback;
    var font;

    var cmd = [];


    var initYet = 0;
    function setCommand(c)
    {
        /*
        cmd.append([SET_TIME, 4]);
        cmd.append([PRINT, 25]);
        cmd.append([SET_TIME, 10]);
        cmd.append([PRINT, 26]);
        cmd.append([SET_TIME, 20]);
        cmd.append([PRINT, 27]);
        cmd.append([SET_TIME, 4]);
        cmd.append([BACK_PRINT, 17]);
        cmd.append([SET_WORD, "battleEnd1"]);
        cmd.append([PRINT, 28]);
        */
        cmd = c;
        //callback
        initYet = 1;
    }
    var toPlay = 1;
    //父亲节点  字符串  字符大小 行高度  字符颜色  每行字符区域宽度 每行字符区域高度  打字tick*50ms 回调函数 粗体/斜体/正常体 
    function closeSound()
    {
        toPlay = 0;
    }
    function openSound()
    {
        toPlay = 1;
    }
    function BackWord(sc, w, sz, h, c, wid, hei, n, cb, ft)
    {
        font = ft;
        sound = createaudio("print.mp3");
        accTick = 0;
        tick = n;
        curPos = 0;
        curWordPos = 0;
        curLine = 0;

        scene = sc;
        totalNum = 0;
        word = w.split("\n");
        
        callback = cb;

        siz = sz;
        paraHei = h;//段落高度10
        col = c;
        width = wid;
        height = hei;

        bg = node();
        init();
        lab = bg.addnode();
        //setCommand();
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    /*
    ord() <= 128 ascii 字符 > 128 汉字
    len 返回的是字节长度
    substr 确实字符长度
    记录字符位置
    记录当前的字节长度
    []访问的是字节位置

    访问+1 字符
    +1 +3 字节
    */
    var startYet = 0;
    var curCmd = 0;
    
    //谁修改状态 谁恢复状态
    //accTick
    //tick 
    //startYet
    //curPos  记录字节位置
    //curWordPos 记录字符位子
    //totalNum 是总长度 包括换行符
    //curLine
    function executeBackPrint()
    {
        var c = cmd[curCmd]; 
        var op = c[0];
        var par = c[1];

        trace("curWordPos, par", curWordPos, par);
        //if(curWordPos > par)//字符位置
        if(totalNum > par)
        {
            accTick += 1;
            if(accTick == tick)
            {
                accTick = 0;
                if(startYet == 0)
                {
                    startYet = 1;
                    if(toPlay)
                        sound.play(-1);
                }
                var line = word[curLine];

                while(curPos >= 0 && curPos < len(line) && line[curPos] == " ")//忽略空格
                {
                    curPos--;
                    curWordPos--;
                    totalNum--;
                }

                if(curPos > 0)
                {
                    //计算当前位置
                    var o = ord(line[curPos-1]);
                    if(o < 128)
                    {
                        curPos -= 1;
                    }
                    else
                    {
                        curPos -= 3;
                    }
                    curWordPos--;
                    totalNum--;



                    var showWord;
                    var curSize = [0, 0];//width height 每段开始位置
                    lab.removefromparent();
                    lab = bg.addnode();
                    //之前段落
                    for(var i = 0; i < curLine; i++)
                    {
var w1 = lab.addlabel(word[i], "fonts/heiti.ttf", siz, font, width, 0, ALIGN_LEFT).color(col);
                        var wSize = w1.prepare().size();
                        w1.pos(0, curSize[1]);
                        curSize[0] = max(wSize[0], curSize[0]);
                        curSize[1] += wSize[1]+paraHei;
                    }
                    //当前段落位置
                    showWord = line.substr(0, curWordPos);
var w2 = lab.addlabel(showWord, "fonts/heiti.ttf", siz, font, width, 0, ALIGN_LEFT).color(col);
                    w2.pos(0, curSize[1]);
                }
                else
                {
                    curLine--;
                    totalNum -= 1;

                    curWordPos = getLineWordNum(word[curLine]);
                    curPos = len(word[curLine]);
                }

            }
        }
        else
        {
            accTick = 0;
            startYet = 0;
            if(toPlay)
                sound.pause();
            curCmd++;
        }
    }
    //设定所在行
    //设定当前所在行字符串 传入字符位置 设定当前位置
    //只支持单行文字
    function setCurPos(l, p)
    {
        trace("setCurPos", l, p);
        totalNum = 0;
        curLine = l;
        for(var i = 0; i < curLine; i++)
        {
            totalNum += getWordLen(word[curLine]);
            if(i < (curLine-1))
                totalNum += 2;//增加\n换行符号长度
        }

        var line = word[curLine];
        curPos = 0;
        curWordPos = 0;

        while(curPos < len(line) && curWordPos < p)
        {
            var o = ord(line[curPos]);
            if(o < 128)
                curPos++;
            else
                curPos += 3;
            curWordPos++;
            totalNum++;
        }
        trace("set", curLine, curPos, curWordPos, totalNum);
    }
    //打字到固定文字长度结束
    function executePrint()
    {
        var c = cmd[curCmd]; 
        var op = c[0];
        var par = c[1];

        //trace("print curWordPos par", curLine, curWordPos, totalNum, par);
        //if(curWordPos < par)//字符位置
        if(totalNum < par)
        {
            accTick += 1;
            if(accTick == tick)
            {
                accTick = 0;
                if(startYet == 0)
                {
                    startYet = 1;
                    if(toPlay)
                        sound.play(-1);
                }
                var line = word[curLine];
                //通过curPos 判断空格 忽略行首空格
                while(curPos < len(line) && line[curPos] == " ")//忽略空格
                {
                    curPos++;
                    curWordPos++;
                    totalNum++;
                }
                if(curPos < len(line))
                {
                    //计算当前位置
                    var o = ord(line[curPos]);
                    if(o < 128)
                    {
                        curPos += 1;
                    }
                    else
                    {
                        curPos += 3;
                    }
                    curWordPos++;
                    totalNum++;

                    var showWord;
                    var curSize = [0, 0];//width height 每段开始位置
                    lab.removefromparent();
                    lab = bg.addnode();
                    //之前段落
                    for(var i = 0; i < curLine; i++)
                    {
var w1 = lab.addlabel(word[i], "fonts/heiti.ttf", siz, font, width, 0, ALIGN_LEFT).color(col);
                        var wSize = w1.prepare().size();
                        w1.pos(0, curSize[1]);
                        curSize[0] = max(wSize[0], curSize[0]);
                        curSize[1] += wSize[1]+paraHei;
                    }
                    //当前段落位置
                    showWord = line.substr(0, curWordPos);//19 
var w2 = lab.addlabel(showWord, "fonts/heiti.ttf", siz, font, width, 0, ALIGN_LEFT).color(col);
                    w2.pos(0, curSize[1]);
                }
                //换行有两个字符 \ 和 n
                else
                {
                    curLine++;
                    curPos = 0;
                    curWordPos = 0;
                    totalNum += 1;// 上面totalNum 已经+1
                }

            }
        }
        else
        {
            accTick = 0;
            startYet = 0;
            if(toPlay)
                sound.pause();
            curCmd++;
        }
    }
    var passTime = 0;
    function update(diff)
    {
        var j;
        var stack;
        if(initYet == 1)
        {   
            //非瞬时命令 break
            //瞬时命令  循环执行
            while(curCmd < len(cmd))
            {
                var c = cmd[curCmd]; 
                var op = c[0];
                var par = c[1];
                //当前打印的位置 和目的打印的位置 检测
                if(op == PRINT)
                {
                    executePrint();//非瞬时
                    break;
                }
                else if(op == SET_TIME)
                {
                    tick = par; 
                    curCmd++;
                }
                else if(op == BACK_PRINT)
                {
                    executeBackPrint(); //非瞬时
                    break;
                }
                else if(op == SET_WORD)
                {
                    word = getStr(par, null).split("\n");
                    curCmd++;
                }
                else if(op == WAIT_PRINT)//非瞬时
                {
                    passTime += diff;
                    if(passTime >= par)
                    {
                        passTime = 0;
                        curCmd++;
                    }
                    break;
                }
                else if(op == SET_CURPOS)
                {
                    setCurPos(par[0], par[1]);
                    curCmd++;
                }
                else if(op == BEGIN_REPEAT)
                {
                    if(par[1] == -1)//循环结束 进入的下一条语句位置
                    {
                        stack = [];
                        for(j = curCmd; j < len(cmd); j++)
                        {
                            if(cmd[j][0] == BEGIN_REPEAT)
                                stack.append(j);
                            else if(cmd[j][0] == END_REPEAT)
                            {
                                stack.pop();
                                if(len(stack) == 0)
                                {
                                    break;
                                }   
                            }
                        }
                        par[1] = j+1;//结束END_REPEAT 位置
                    }
                    if(par[0] == 0)//循环执行结束
                    {
                        curCmd = par[1];
                    }
                    else//仍然执行循环
                    {
                        if(par[0] > 0)//不是无限循环
                            par[0]--;
                        curCmd++;
                    }
                }
                else if(op == END_REPEAT)
                {
                    if(par == -1)//缓存 语句开始位置
                    {
                        stack = [];
                        for(j = curCmd; j >= 0; j--)
                        {
                            if(cmd[j][0] == END_REPEAT)
                            {
                                stack.append(j)
                            }
                            else if(cmd[j][0] == BEGIN_REPEAT)
                            {
                                stack.pop();
                                if(len(stack) == 0)
                                {
                                    break;
                                }
                            }
                        }
                        par = j;
                    }
                    curCmd = par; 
                }
                else
                    break;
            }

            if(curCmd >= len(cmd))
            {
                if(callback != null)
                    callback();
            }
        }
    }
    override function exitScene()
    {
        sound.stop();

        global.myAction.removeAct(this);
        super.exitScene();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
