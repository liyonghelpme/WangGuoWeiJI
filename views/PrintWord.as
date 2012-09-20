/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

功能：
    换行
    识别非中文字符---》英文字符


当前打字的位置
中文3个字符

打字频率

需要scene提供打字频率的timer 用于控制
*/
class PrintWord extends MyNode
{
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

    //var totalWord;
    var totalNum;
    var sound;
    
    //音效存在问题 不能 有效播放
    //var player;
    //段落停顿时间
    var callback;
    var font;
    function PrintWord(sc, w, sz, h, c, wid, hei, n, cb, ft)
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
        //totalWord = w;
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
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
        //player = sound.play(-1, 100, 100, 0, 100);
        //sound.play(-1);
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
    function update(diff)
    {
        accTick += 1;
        if(accTick == tick)
        {
            if(startYet == 0)
            {
                startYet = 1;
                sound.play(-1);
            }
            accTick = 0;
            if(curLine < len(word))//当前行小于总行数
            {
                var line = word[curLine];
                while(curPos < len(line) && line[curPos] == " ")//忽略空格
                {
                    curPos++;
                    curWordPos++;
                }
                if(curPos < len(line))
                {
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
                    trace("curPos", curPos, curWordPos, totalNum, curLine, len(word), len(line));
                    
                    
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
                    curPos = 0;
                    curWordPos = 0;
                    curLine++;
                    totalNum += 2;//换行符号\n
                }
            }
            else//结束弹出场景 压入新的战斗场景
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
