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


public class SBossRefreshKey
{
    public var mapId : int;

    public var plan : int;

    public function SBossRefreshKey()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(mapId);
        __os.writeInt(plan);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        mapId = __is.readInt();
        plan = __is.readInt();
    }
}
}
