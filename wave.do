#①退出当前仿真功能，退出当前的工程，跟在modelsim界面的命令行敲入命令的效果一样，之后就可以创建其他的工程
quit -sim 

#②清除命令行显示信息；在命令行‘敲入这个命令，回车’的效果一样。实测无法运行因此注释掉
#.main    clear

#③创建库：vlib:创建库到一个物理目录中，也就是创建文件夹目录了。
#可以理解库为某一个路径的文件夹，用来存储modelsim的一些数据文件；
#创建库的格式vlib <library name>,默认库的名字为work
#下面的代码意思是：1-在当前路径（.do文件的路径）下，创建lib文件夹；相当于在命令行敲‘vlib lib  回车’
#2-在当前路径的lib文件夹下，创建work文件夹库；相当于在命令行敲‘vlib    ./lib/work’
vlib    ./lib
vlib    ./lib/work

#④映射逻辑库到物理目录;也就是说，在modelsimGUI界面的Library选项卡里面创建子选项，这个子选项就叫做逻辑库，
#编译工程之后，得到一堆编译文件，这些文件名就放在这个逻辑库选项卡里面。但是编译得到的是实体文件，这些文件必须
#有一个目录存储，因此就需要把逻辑库映射到物理（文件夹）目录，也就是把那些得到的实体文件放在某一个文件夹目录（路径当中）
#这样，就可以在实际文件夹里面查看编译得到的文件内容，而不是单单从选项卡里面看到名字而已
#注意，在映射之前，一定要先创建好对应的物理路径
#语法为 vmap work(逻辑库名称)  <library name>(库的路径)
#下面的代码意思是：在modelsim界面的library选项卡创建一个叫work的选项卡（逻辑库），编译之后得到的文件名称就在，
#相应的文件就放在./lib/work这个文件夹里面。
vmap     work ./lib/work

#⑤编译Verilog 源代码，将编译得到的信息文件与编译的文件放到④的逻辑库里面，库名缺省编译到work本地库，文件按顺序编译。
#语法为vlog –work(固定格式)  work(逻辑库名字)  <file1>.v <file2>.v(要编译的文件：路径/文件)
#主要是编译设计文件，测试文件，调用的IP核.v文件，相应的库文件，通配符./../xxx/*.v，要注意编译的顺序
#注意，.v文件应该是放在设计或者仿真的文件里面，不要仿真逻辑库路径里面，逻辑库路径在编译之后会自然得复制过来
#-l参数 输出编译过程中的信息到文件中
vlog    -work    work    ./design/*.v -l ./design/vcompile.txt

#⑥编译完后启动仿真，语法格式为vsim –lib <library name>.<top level design>，
#下面的代码意思是：优化部分参数(-voptargs=+acc)，链接到默认的work 库，启动仿真顶层测试逻辑库(work)里面的tb文件
#-l参数 输出仿真过程中的信息到文件中
#-wlf参数 保存波形文件
#可以用log /* -r保存所有信号波形
vsim    -voptargs=+acc    work.tb -l ./design/vsim.txt -wlf ./vsim.wlf
log /* -r

#⑦添加波形与分割线。
#添加波形：就是添加要显示波形，语法格式:add wave <mydesign>/<signal>
#。。。如果添加的波形不只是顶层模块的，还有顶层下面的例化模块的信号，
#就是#add wave 测试顶层的名字/例化子模块的例化名字/子模块信号的名字
#添加分割线：不同的信号之间进行分割，语法格式是add    wave    -divider    {分割线的名字}。
#分割线所处的位置是相对于波形信号的。下面代码的意思就是在lvds_clock信号上面添加了一条分割线。
add    wave    -divider 	{tb}
add    wave    tb/*
add    wave    -divider 	{uut}
add    wave    tb/uut/*

#⑧运行，格式是 run 运行时间
run    80us