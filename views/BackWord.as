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
    over
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
        paraHei = h;
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
                        var w1 = lab.addlabel(word[i], null, siz, font, width, 0, ALIGN_LEFT).color(col);
                        var wSize = w1.prepare().size();
                        w1.pos(0, curSize[1]);
                        curSize[0] = max(wSize[0], curSize[0]);
                        curSize[1] += wSize[1]+paraHei;
                    }
                    //当前段落位置
                    showWord = line.substr(0, curWordPos);
                    var w2 = lab.addlabel(showWord, null, siz, font, width, 0, ALIGN_LEFT).color(col);
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
            sound.pause();
            curCmd++;
        }
    }
    function executePrint()
    {
        var c = cmd[curCmd]; 
        var op = c[0];
        var par = c[1];

        trace("print curWordPos par", curLine, curWordPos, totalNum, par);
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
                        var w1 = lab.addlabel(word[i], null, siz, font, width, 0, ALIGN_LEFT).color(col);
                        var wSize = w1.prepare().size();
                        w1.pos(0, curSize[1]);
                        curSize[0] = max(wSize[0], curSize[0]);
                        curSize[1] += wSize[1]+paraHei;
                    }
                    //当前段落位置
                    showWord = line.substr(0, curWordPos);//19 
                    var w2 = lab.addlabel(showWord, null, siz, font, width, 0, ALIGN_LEFT).color(col);
                    w2.pos(0, curSize[1]);
                }
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
            sound.stop();
            curCmd++;
        }
    }
    function update(diff)
    {
        if(initYet == 1)
        {   
            if(curCmd < len(cmd))
            {
                var c = cmd[curCmd]; 
                var op = c[0];
                var par = c[1];
                //当前打印的位置 和目的打印的位置 检测
                if(op == PRINT)
                {
                    executePrint();
                }
                else if(op == SET_TIME)
                {
                    tick = par; 
                    curCmd++;
                }
                else if(op == BACK_PRINT)
                {
                    executeBackPrint(); 
                }
                else if(op == SET_WORD)
                {
                    word = getStr(par, null).split("\n");
                    curCmd++;
                }
            }
            else
            {
                callback();
            }
        }
    }
    override function exitScene()
    {
        //player.stop();
        sound.stop();
        //sound.destory();
        //sound.destory();

        global.myAction.removeAct(this);
        super.exitScene();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
