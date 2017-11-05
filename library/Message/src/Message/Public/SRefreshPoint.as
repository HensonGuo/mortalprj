// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SRefreshPoint
{
    public var mapId : int;

    public var bossRefresh : Dictionary;

    public function SRefreshPoint()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(mapId);
        DictBossRefreshHelper.write(__os, bossRefresh);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        mapId = __is.readInt();
        bossRefresh = DictBossRefreshHelper.read(__is);
    }
}
}
