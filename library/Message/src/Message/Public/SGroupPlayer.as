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


public class SGroupPlayer
{
    public var player : SPublicPlayer;

    public var groupState : int;

    public function SGroupPlayer()
    {
    }

    public function __write( __os : SerializeStream ) : void
    {
        player.__write(__os);
        __os.writeInt(groupState);
    }

    public function __read( __is : SerializeStream ) : void 
    {
        player = new SPublicPlayer();
        player.__read(__is);
        groupState = __is.readInt();
    }
}
}
