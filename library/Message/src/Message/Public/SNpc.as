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


public class SNpc
{
    public var npcId : int;

    public var npcType : ENpcType;

    public var name : String;

    public var mapId : int;

    public var notShowInMap : int;

    public var point : SPoint;

    public var relPoint : SPoint;

    [ArrayElementType("SPassTo")]
    public var passTo : Array;

    public function SNpc()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(npcId);
        npcType.__write(__os);
        __os.writeString(name);
        __os.writeInt(mapId);
        __os.writeInt(notShowInMap);
        point.__write(__os);
        relPoint.__write(__os);
        SeqPassToHelper.write(__os, passTo);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        npcId = __is.readInt();
        npcType = ENpcType.__read(__is);
        name = __is.readString();
        mapId = __is.readInt();
        notShowInMap = __is.readInt();
        point = new SPoint();
        point.__read(__is);
        relPoint = new SPoint();
        relPoint.__read(__is);
        passTo = SeqPassToHelper.read(__is);
    }
}
}

