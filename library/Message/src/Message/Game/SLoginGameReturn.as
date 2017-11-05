// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SLoginGameReturn
{
    public var entityId : SEntityId;

    public var player : SPlayer;

    public var role : SRole;

    public var money : SMoney;

    public var pos : SPos;

    public var baseFight : SFightAttribute;

    public var sesionKey : SSessionKey;

    public var sysDt : Date;

    public function SLoginGameReturn()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        entityId.__write(__os);
        player.__write(__os);
        role.__write(__os);
        money.__write(__os);
        pos.__write(__os);
        baseFight.__write(__os);
        sesionKey.__write(__os);
        __os.writeDate(sysDt);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        entityId = new SEntityId();
        entityId.__read(__is);
        player = new SPlayer();
        player.__read(__is);
        role = new SRole();
        role.__read(__is);
        money = new SMoney();
        money.__read(__is);
        pos = new SPos();
        pos.__read(__is);
        baseFight = new SFightAttribute();
        baseFight.__read(__is);
        sesionKey = new SSessionKey();
        sesionKey.__read(__is);
        sysDt = __is.readDate();
    }
}
}

