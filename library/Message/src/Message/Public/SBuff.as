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


public class SBuff
{
    public var buffId : int;

    public var cdDt : Date;

    public var beginDt : Date;

    public var endDt : Date;

    public var remainSec : int;

    public var value : int;

    public var count : int;

    public var overLay : int;

    public function SBuff()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(buffId);
        __os.writeDate(cdDt);
        __os.writeDate(beginDt);
        __os.writeDate(endDt);
        __os.writeInt(remainSec);
        __os.writeInt(value);
        __os.writeInt(count);
        __os.writeInt(overLay);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        buffId = __is.readInt();
        cdDt = __is.readDate();
        beginDt = __is.readDate();
        endDt = __is.readDate();
        remainSec = __is.readInt();
        value = __is.readInt();
        count = __is.readInt();
        overLay = __is.readInt();
    }
}
}
