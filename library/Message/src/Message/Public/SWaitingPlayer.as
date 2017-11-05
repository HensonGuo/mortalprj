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


public class SWaitingPlayer extends IMessageBase 
{
    public var player : SPublicPlayer;

    public var maxProcessMap : Dictionary;

    public function SWaitingPlayer(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SWaitingPlayer = new SWaitingPlayer( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 5005;

    override public function clone() : IMessageBase
    {
        return new SWaitingPlayer;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        player.__write(__os);
        MapSMaxProcessHelper.write(__os, maxProcessMap);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        player = new SPublicPlayer();
        player.__read(__is);
        maxProcessMap = MapSMaxProcessHelper.read(__is);
    }
}
}
