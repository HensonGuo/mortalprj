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



public class AMI_IPlayer_findMiniPlayerByName extends RMIObject
{
    public function AMI_IPlayer_findMiniPlayerByName(response : Function = null , ex : Function = null , obj : Object = null )
    {
        super( response , ex );
        userObject = obj;
        callFunction = "findMiniPlayerByName";
    }

    override public function __response( __is : SerializeStream ) : void
    {
        var players : Array;
        try
        {
            players = SeqMiniPlayerHelper.read(__is);
        }
        catch( __ex : Error )
        {
            cdeException( new Exception( "ExceptionCodeSerialize" , Exception.ExceptionCodeSerialize ) );
            return;
        }
        cdeResponse(players);
    }

    public function cdeResponse(players : Array ) : void
    {
        if( null != _response )
        {
            _response.call( null , this , players );
        }
    }
}
}

