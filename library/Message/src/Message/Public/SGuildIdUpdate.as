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


public class SGuildIdUpdate extends IMessageBase 
{
    public var updateEntityId : SEntityId;

    public var guildId : SEntityId;

    public function SGuildIdUpdate(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SGuildIdUpdate = new SGuildIdUpdate( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 2009;

    override public function clone() : IMessageBase
    {
        return new SGuildIdUpdate;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        updateEntityId.__write(__os);
        guildId.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        updateEntityId = new SEntityId();
        updateEntityId.__read(__is);
        guildId = new SEntityId();
        guildId.__read(__is);
    }
}
}
