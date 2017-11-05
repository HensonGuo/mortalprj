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

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPassPoint
{
    public var passPointId : int;

    public var mapId : int;

    public var type : int;

    public var point : SPoint;

    public var name : String;

    [ArrayElementType("SPassTo")]
    public var passTo : Array;

    public var effectName : String;

    public var process : int;

    public function SPassPoint()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(passPointId);
        __os.writeInt(mapId);
        __os.writeInt(type);
        point.__write(__os);
        __os.writeString(name);
        SeqPassToHelper.write(__os, passTo);
        __os.writeString(effectName);
        __os.writeInt(process);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        passPointId = __is.readInt();
        mapId = __is.readInt();
        type = __is.readInt();
        point = new SPoint();
        point.__read(__is);
        name = __is.readString();
        passTo = SeqPassToHelper.read(__is);
        effectName = __is.readString();
        process = __is.readInt();
    }
}
}

