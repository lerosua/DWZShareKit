DWZShareKit
===========
自用项目，集合新浪，QQ，QQ空间，微信 分享。
直接跳到相应的应用里分享信息。如果没装则不能分享。
也加了腾讯微博SDK，但它不能跳到应用上分享，目前没启作用。

编译注意事项。
微信等SDK不支持64位编译，因此引入后要把 Target Build Setting中的Architectures改为 $(ARCHS\_STANDARD\_32\_BIT)
SDK里有用到C++混编，因此要最好把main.m改成main.mm才能通过编译。

