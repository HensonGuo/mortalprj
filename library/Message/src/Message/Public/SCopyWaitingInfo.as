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


public class SCopyWaitingInfo extends IMessageBase 
{
    public var copyCode : int;

    public var groupInfos : Dictionary;

    [ArrayElementType("SPublicPlayer")]
    public var waitingPlayers : Array;

    public var haveSignUp : Boolean;

    public var memberEnterNum : Dictionary;

    public function SCopyWaitingInfo(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SCopyWaitingInfo = new SCopyWaitingInfo( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 5006;

    override public function clone() : IMessageBase
    {
        return new SCopyWaitingInfo;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(copyCode);
        MapSCopyGroupInfoHelper.write(__os, groupInfos);
        SeqPublicPlayerHelper.write(__os, waitingPlayers);
        __os.writeBool(haveSignUp);
        DictEntityIdIntHelper.write(__os, memberEnterNum);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        copyCode = __is.readInt();
        groupInfos = MapSCopyGroupInfoHelper.read(__is);
        waitingPlayers = SeqPublicPlayerHelper.read(__is);
        haveSignUp = __is.readBool();
        memberEnterNum = DictEntityIdIntHelper.read(__is);
    }
}
}

